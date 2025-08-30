# TP DevOps – Niveau 1 : Bases GitHub & CI simple

Bienvenue dans le premier niveau du TP DevOps ! 
Il est fait usage de conteneur.

## Travail à faire
1. Construire :
   docker-compose -f docker-compose.tp.yml build

2. Lancer :
   docker-compose -f docker-compose.tp.yml up -d

3. Entrer dans le conteneur :
   docker exec -it devops-tp bash

4. Créer une branche, coder, tester (pytest), commit & push puis ouvrir une PR.
   Actions :
      - git checkout -b feature-newroute
      - pytest -v
      - flake8 app.py tests/
      - python app.py
      - Consigne : ajouter le route `/hello/<name>`
         - retester et executer app.py comme ci-dessus


---

test prof sur VM

