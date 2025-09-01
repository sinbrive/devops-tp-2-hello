# Mini-Projet DevOps – Bases GitHub PipeLine & CI/CD simple

> Bienvenue dans le mini-projet DevOps !

## Travail à faire ([aide: Fiche-CI](Fiche-CI.md)) 
1. Lancer :`docker-compose up -d`

2. Tester le site : `curl localhost:5000`

3. Coder, tester (pytest), téléverser et ouvrir/suivre une PR.
      - Entrer dans le shell du conteneur : 
      `docker exec -it devops-tp bash `
      - modifier les fichiers app.py et test_app.py
         - Consigne : ajouter le route `/hello/<name>` avec les variables nécessaires
      - `pytest -v`
      - `flake8 app.py test_app/py`
      - si erreur, cooriger et tester
      - sortir du shell: exit

4. stopper le conteneur : `docker-compose down` 

5. relancer : `docker-compose up -d --build`

6. vérifier : `curl localhots:5000`

7. si le résultat est conforme aux attentes, pousser la branche : git push origin main 

8. aller sur Github et initier un Pull Request 

9. suivre l'état du PR

10. Niveau 2 : Déploiement ([voir Fiche-CD](Fiche-CD.md)) 



