# Requires PowerShell
# Equivalent of set -e in bash:
$ErrorActionPreference = "Stop"

# Project name
$REPO_NAME = "devops-lab-hello"

# 1. Create the folder
# if (Test-Path $REPO_NAME) {
#     Remove-Item -Recurse -Force $REPO_NAME
# }
# New-Item -ItemType Directory -Path $REPO_NAME | Out-Null
# Set-Location $REPO_NAME

# 2. Source files
@'
from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello, World!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
'@ | Set-Content app.py

@'
flask==2.3.2
pytest==7.4.0
flake8==6.0.0
'@ | Set-Content requirements.txt

New-Item -ItemType Directory -Path "tests" | Out-Null
@'
from app import app

def test_home():
    client = app.test_client()
    response = client.get("/")
    assert response.status_code == 200
    assert response.data == b"Hello, World!"
'@ | Set-Content "tests\test_app.py"

# 3. Docker & Compose files
@'
FROM python:3.10-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 5000
CMD ["python", "app.py"]
'@ | Set-Content Dockerfile

@'
FROM python:3.10-slim

RUN apt-get update && apt-get install -y --no-install-recommends `
    git curl && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash student
USER student
WORKDIR /home/student/app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

CMD ["/bin/bash"]
'@ | Set-Content Dockerfile.dev

@'
version: "3.8"

services:
  devops-lab:
    build:
      context: .
      dockerfile: Dockerfile.dev
    container_name: devops-lab-dev
    volumes:
      - .:/home/student/app
    stdin_open: true
    tty: true
'@ | Set-Content docker-compose.dev.yml

# 4. GitHub Actions workflow
New-Item -ItemType Directory -Force -Path ".github\workflows" | Out-Null
@'
name: CI Pipeline Extended

on:
  pull_request:
  push:

jobs:
  lint-test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repo
        uses: actions/checkout@v3

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: "3.10"

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt

      - name: Run flake8 (linting)
        run: flake8 --max-line-length=100 app.py tests/

      - name: Run pytest (unit tests)
        run: pytest -v

  docker-build:
    runs-on: ubuntu-latest
    needs: lint-test
    steps:
      - name: Checkout repo
        uses: actions/checkout@v3

      - name: Build Docker image
        run: docker build -t devops-lab-hello .
'@ | Set-Content ".github\workflows\ci.yml"

# 5. READMEs
@'
# Lab DevOps – Niveau 1 : Bases GitHub & CI simple (Full Container)

Bienvenue dans le premier niveau du lab DevOps ! 🚀
Tout est fait dans un conteneur.

## Étapes rapides (étudiants)
1. Construire :
   docker-compose -f docker-compose.dev.yml build

2. Lancer :
   docker-compose -f docker-compose.dev.yml up -d

3. Entrer dans le conteneur :
   docker exec -it devops-lab-dev bash

4. Créer une branche, coder, tester (pytest), commit & push puis ouvrir une PR.
'@ | Set-Content README.md

@'
# 📘 README – Environnement Dev Container

## Étapes
1. Construire :
   docker-compose -f docker-compose.dev.yml build

2. Lancer :
   docker-compose -f docker-compose.dev.yml up -d

3. Rentrer dedans :
   docker exec -it devops-lab-dev bash
'@ | Set-Content README-devcontainer.md

# 6. Initialize Git repo and branches
git init
git add .
git commit -m "Initial commit - main lab level"

# Branch: solution
git checkout -b solution

@'
from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello, World!"

@app.route("/hello/<name>")
def hello_name(name):
    return f"Hello, {name}!"

@app.route("/goodbye/<name>")
def goodbye_name(name):
    return f"Goodbye, {name}!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
'@ | Set-Content app.py

@'
from app import app

def test_home():
    client = app.test_client()
    response = client.get("/")
    assert response.status_code == 200
    assert response.data == b"Hello, World!"

def test_hello_name():
    client = app.test_client()
    response = client.get("/hello/Alice")
    assert response.status_code == 200
    assert response.data == b"Hello, Alice!"

def test_goodbye_name():
    client = app.test_client()
    response = client.get("/goodbye/Bob")
    assert response.status_code == 200
    assert response.data == b"Goodbye, Bob!"
'@ | Set-Content "tests\test_app.py"

git add .
git commit -m "Solution branch with extra routes and tests"

# Branch: solution-extended
git checkout -b solution-extended
# (workflow already extended)

git add .
git commit -m "Extended solution with linting and Docker build job"

# Return to main
git checkout main

Write-Output "✅ Repo $REPO_NAME initialisé avec 3 branches (main, solution, solution-extended)."
Write-Output "👉 Étape suivante : créez un repo GitHub et poussez avec :"
Write-Output "git remote add origin https://github.com/<YOUR-USER>/$REPO_NAME.git"
Write-Output "git push origin main solution solution-extended"
