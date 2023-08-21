# PDG-GRP5 - Georian Gillioz, Jérémie Santoro, Oscar Baume, Théo Coutaudier
## Description du projet
Application mobile (avec version WEB) qui accompagne les utilisateurs durant leurs séances de sport.
L'application correspond à un modèle de séances de sport avec des séries, répétitions, poids, ...
Workout(planning) -> Séances -> Exercices
### Architecture
TODO: On aurait que notre App qui communique avec Firebase pour accéder à Firestore et Auth ?
### Choix technique
1. Frontend
Nous avons choisi Flutter car étant une petite équipe voulant développer une app mobile sur Android et iOS et éviter de faire du code à double il s'agit de la meilleure solution pour effectuer la tâche dans le temps imparti.
Un autre avantage de Flutter est la possiblité de pouvoir également servir une app web avec le même code source
2. Backend
Nous avons choisi Firebase qui est un BaaS qui propose des services tel que l'authentification et le stockage de données avec la BD orientée documents (Firestore)
Firebase nous permet également d'utiliser Hosting pour hoster notre build WEB
Firebase et Flutter étant 2 produits Google la cohabitation entre ces 2 parties sera aisée
### Description du processus de travail (git flow, devops, ...)
### Outils de développement (VCM, Issue tracker, ...)
### Environnement de déploiement
### Pipeline de livraison et de déploiement (CI/CD)
### Démo du déploiement d'une modification

## Requirments fonctionnels
- L'utilisateur peut se connecter et retrouver toutes ses données peu importe la machine depuis laquelle il se connecte
- L'utilisateur peut créer des workouts ou il donne les séances qu'il voudrait faire chaque semaine (il peut mettre plusieurs fois la même séance)
- L'utilisateur peut créer des séances qu'il pourra ensuite assigner à ses workouts
- L'utilisateur peut créer des des exercices qu'il pourra ensuite assigner à ses séances (poids et nb de rep de ceux-ci par défaut)
- Les séances sont composés d'exercices par défaut proposés par l'application ou des exercices personnalisés ajoutés par chaque utilisateur (les exercices crées ne seront visibles que pour l'auteur de l'exercice sauf si ce dernier le partage)
- Durant la séance de sport l'utilisateur peut rentrer son nombre de répétitions et le poids utilisé pour chaque série de chaque exercice (il y aura cependant une valeur par défaut de 8 répétitions pour faire gagner du temps à l'utilisateur)
- Pour chaque exercice il existe un PR (Personal Record) qui n'est autre que la valeur maximale effectuée par l'utilisateur sur cet exercice, si le PR est battu un petit truc cool devrait se passer à l'écran au moment de la validation :)
- L'utilisateur peut voir pour chaque exercice qu'il a fait son PR

### Ajouts éventuels
- Possiblité d'avoir des amis pour comparer leurs performances (ex: PR)
- Calendrier hebdo pour Oscar
- Possiblité de faire des exercice "live" (impro), exercices en dehors des séances
- Les workout, les séances et les exercices peuvent être partagés entre utilisateur
- L'utilisateur peut voir pour chaque exercice son évolution (graphe?)
- Superset
- Création de séance assité (meilleurs exo en 1er etc)
- Photo + poids chaque fin de mois (avec notif) pour évolution
- Lier avec le nb de pas de l'appareil (necessite de travailler avec les specificites iOS et Android)
- Notification quand on arrive à la fin d'un workout pour se préparer à faire le suivant
- Historique workouts/séances/exercices effecutés (il faudra donc stocker quand est effectué chacun)

## Requirments non fonctionnels
### Sécurite
TODO: parler des secu firebase et comment on a bien codé l'app ?
TODO: je dois jsute dire que je veuille que tout aille bien alors que ca ne depend pas de moi ?
### Compatibilité
Le système doit tourner autant bien sur smartphone iOS que Android
### Conformité
- Quand un utilisateur supprime son compte toutes les données qui lui sont liés seront supprimées
### Usabilité
- L'application doît être facilement utilisable par des personnes qui sont à la salle de gym et qui ne sont pas forcément très concentré sur l'app car ils fournissent des efforts intensifs (il faut éviter de devoir passer par plusieurs touches d'écran pour pouvoir faire ce qu'ils ont envie de faire, ex: enregistrer les résultats de leur exercice)
### Evolutivié - Performance - Disponibilité - Fiabilité
- Tout cela est géré et garantit par notre BaaS Firebase

## Description de la méthodologie
1. On regarde ensemble ce qu'il faut faire et on ajoute les tâches à un backlog
2. On répartie les différentes tâches entre les membres du groupe
3. A la fin du sprint (chaque jour), on se concerte ensemble pour voir l'avancement et répéter l'étape 1 avec les modifications nécessaires

SCRUM OU AGILE VU QUE PAS DE CLIENT ?

## Mockups
### Gestion
- Workouts: Créer, modifier et supprimer des workouts
- Séances: Créer, modifier et supprimer des séances
- Exercices: Créer, modifier et supprimer des séances (exercices de base pas compris)
### Progression de la semaine en cours (PAGE D'ACCUEIL)
- Si aucun workout en cours -> Propose de se rendre sous Gestion/Workouts
- Affichage du workout en cours et suivi des semaines (ex: semaine 2/5)
- Affichage du nombre de séances restantes pour la semaine actuelle
- Il est possible de refaire une même séance bien que cela sera précédé par un message demandant de confirmer à l'utilisateur son choix car ce dernier serait contradictoire avec le workout
- Possiblité de stopper le workout actuel
- Quand l'utilisateur veut faire sa séance de sport il choisit une des séances restantes de son choix qui va lancer l'affichage *Séance en cours*
#### Séance en cours
- L'utilisateur choisist dans les exercices possibles quel exercice faire l'un après l'autre (bien qu'un ordre soit recommandé)
- Une fois l'exercice lancé il va pouvoir rentrer combien de répétitions il a fait ainsi que le poids utilisé
- Entre chaque série un chrono se lance pour que l'utilisateur sache combien de temps de repos il utilise
- Dès qu'il le désire il peut stoper le temps de repos pour passer à la série suivante
- Une fois l'exercice terminé il se retrouve sur la page ou il peut choisir un exercice parmis les restants
- Si la séance est terminée l'utilisateur et renvoyé sur la PAGE D'ACCUEIL et la séance effectuée est marquée comme terminée (avec par exemple une coloration en vert9
### Mes péformances
- On peut voir le PR pour chaque exercice qu'on a fait depuis la création du compte
### Paramètres et gestion utilisateur
#### Paramètres
- Dark and light mode ?
- About version
- Feedkback: report a bug
#### Utilisateur
- Supprimer le compte (règles EU)
- Log out
- Modifier pseudo, mdp, email, ...

## Landing page
Speech (ex: https://studystorm.net) + lien pour télécharger l'APK ou si trop compliqée -> hébérger version WEB sur netlify
https://gilliozdorian.wixsite.com/gym2golmon

# Questions
- On peut deploy la version web mais tout de même être focus sur le mobile ?
- Comment automatiser l'hebergement de notre apk (build) avec un script à la main ? Mettre sur github ?
- Requirments non fonctionels
- Faire prévalider notre CDC avant le rendu de vendredi ?
- Valider le stack ?
- Scrum ou Agile ?

# TODO
- Drawio: Workout -> Séances -> Exercices
- Drawio: architecture avec flutter app, firebase... ?
- - CI/CD ...
- Démo de déploiement
- Requirments fonctionels
