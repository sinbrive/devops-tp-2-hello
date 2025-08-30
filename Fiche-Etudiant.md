# 📝 FICHE ÉTUDIANT – TP  DEVOPS 

## 🎯 Cycle DevOps (simplifié)
1. Développer une fonctionnalité ✍️
2. Écrire un test unitaire 🧪
3. Pousser le code et ouvrir une Pull Request 🔀
4. CI GitHub Actions valide ou bloque ✅❌
5. Le code validé peut être intégré 🚀

---

## ⚙️ Commandes de base Git

### Config initiale (à faire UNE seule fois)
```
git config --global user.name "VotreNom"
git config --global user.email "vous@example.com"
```

### Workflow classique
```
# Clonez votre fork
git clone https://github.com/<user>/devops-tp-hello.git
cd devops-tp-hello

# Créez une nouvelle branche
git checkout -b feature-nouvelle-route

# (codez votre feature...)

# Vérifiez l’état et ajoutez vos modifications
git status
git add .

# Enregistrez un commit
git commit -m "Ajout route /hello/<name>"

# Poussez vos changements
git push origin feature-nouvelle-route
```

➡️ Ensuite, ouvrez une **Pull Request** vers le dépôt enseignant.

---

## 🐍 Commandes Python utiles

### Installer dépendances
```
pip install -r requirements.txt
```

### Lancer l’application Flask
```
python app.py
```

### Lancer les tests
```
pytest -v
```

➡️ Tous les tests doivent être verts ✅ !

---

## 🔍 Qualité du code (niveau avancé)
```
flake8 app.py tests/
```
➡️ Corrigez les erreurs signalées avant de pousser votre code.

---

## 🔀 Workflow PR + CI/CD

1. Développez une feature sur une BRANCHE.  
2. Commitez → pushez → ouvrez une Pull Request.  
3. **GitHub Actions** exécute automatiquement :  
   - flake8 → qualité du code  
   - pytest → tests unitaires  
   - (bonus) docker build → validation du conteneur  
4. La PR ne peut être fusionnée que si tout est vert ✅.  

---

## ✅ Bonnes pratiques
- Toujours créer une **branche** avant de coder !  
- Toujours lancer `pytest` en local avant de pousser.  
- Un commit = une étape claire (message explicite).  
- Une PR doit contenir code + test associé.  

---
