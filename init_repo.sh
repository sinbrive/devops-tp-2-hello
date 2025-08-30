#!/bin/bash
set -e

# Nom du projet
REPO_NAME="devops-lab-hello"

# 1. Créer le dossier
rm -rf $REPO_NAME
mkdir $REPO_NAME && cd $REPO_NAME

# 2. Fichiers sources
cat > app.py <<'EOF'
from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello, World!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
EOF

cat > requirements.txt <<'EOF'
flask==2.3.2
pytest==7.4.0
flake8==6.0.0
EOF

mkdir -p tests
cat > tests/test_app.py <<'EOF'
from app import app

def test_home():
    client = app.test_client()
    response = client.get("/")
    assert response.status_code == 200
    assert response.data == b"Hello, World!"
EOF

# 3. Dockerfiles & Compose
cat > Dockerfile <<'EOF'
FROM python:3.10-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 5000
CMD ["python", "app.py"]
EOF

cat > Dockerfile.dev <<'EOF'
FROM python:3.10-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash student
USER student
WORKDIR /home/student/app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

CMD ["/bin/bash"]
EOF

cat > docker-compose.dev.yml <<'EOF'
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
EOF

# 4. GitHub Actions
mkdir -p .github/workflows
cat > .github/workflows/ci.yml <<'EOF'
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
          python-version: '3.10'

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
EOF

# 5. README principal (main)
cat > README.md <<'EOF'
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
EOF

cat > README-devcontainer.md <<'EOF'
# 📘 README – Environnement Dev Container

## Étapes
1. Construire :
   docker-compose -f docker-compose.dev.yml build

2. Lancer :
   docker-compose -f docker-compose.dev.yml up -d

3. Rentrer dedans :
   docker exec -it devops-lab-dev bash
EOF

# 6. Initialiser Git et branches
git init
git add .
git commit -m "Initial commit - main lab level"

# Création branche solution
git checkout -b solution
cat > app.py <<'EOF'
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
EOF

cat > tests/test_app.py <<'EOF'
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
EOF

git add .
git commit -m "Solution branch with extra routes and tests"

# Création branche solution-extended
git checkout -b solution-extended
# (ci.yml déjà multi-job + flake8 intégré)

git add .
git commit -m "Extended solution with linting and Docker build job"

# Retour sur main
git checkout main

echo "✅ Repo $REPO_NAME initialisé avec 3 branches (main, solution, solution-extended)."
echo "👉 Étape suivante : créez un repo GitHub et poussez avec :"
echo "git remote add origin https://github.com/<YOUR-USER>/$REPO_NAME.git"
echo "git push origin main solution solution-extended"