![](ressources/large.jpg)
# Gym 2 Golem

Le sport est important dans la vie de chacun. Malheuresement beaucoup trop de gens ne sont  pas assez accompagnés dans leur vie sportive. 

Nous avons noté 3 pilliers qui sont indispensables pour avoir une bonne relation avec le sport. 

1. La structuration: Il est très important de bien structurer ces entraînements pour avoir des résultats et surtout ne pas se blesser. 
Un programme bien structuré peut être également bénéfique pour motiver la personne qui peut y trouver un objectif dans le temps.

2. La régularité: Trop souvent une personnes qui tentent de se mettre au sport sera très motivée les premières semaines puis cette motivation va baisser avec le temps, jusqu'à disparaitre. Il faut donc garder l'utilisateur motivé/discipliné le plus longtemps possible.

3. L'augmentation progressive: Pour progresser et devenir plus fort (et donc en meilleure santé) il est important d'augmenter la charge de travail progressivment dans le temps. Si l'utilisateur n'est pas motivé à battre ses records parce qu'il ne les connait pas par exemple. Il ne se donnera pas les moyens de se dépasser.

Les solutions proposées aujourd'hui sont soit de faire ces programmes et noter ces performances sur papier ... 
Ce qui n'est clairement pas idéal (trop de papier = désorganisé, peu pratique à déplacer et utiliser pendant les séances, peuvent se perdre, déchirer, ...)

Il existe sinon quelques applications mais elles sont souvent peu flexibles et compliquées à utiliser. De plus, elles sont toutes payantes...

C'est pourquoi nous avons décidé de développer Gym 2 Golem. 
C'est une solution facile de prise en main, avec des données centralisées et flexible dans la planification des activités sportives. 

Gym 2 golem est une application de fitness qui acompagne les utilisateurs avant, pendant et après leurs séances de sport. 
Il est compliqué de structurer ses programmes de sport, de rester motivé, et de garder un suivi de ta progression. 

Sur Gym 2 golem, il est possible d'avant de faire sa séance de sport de planifier ces programmes, avec des séances et des exercices. 
Pendant la séance l'utilisateur est guidé et n'a pas besoin de réfléchir avec notre UI intuitive. Il peut donc se focaliser à 100% sur ses performances sportives.
Après sa séance il peut revoir ses PR ainsi que les séances hébdomadaires qui lui reste à faire.

# Acceder à l'application 
Cliquer sur le [lien](https://gilliozdorian.wixsite.com/gym2golem) pour accéder à notre application

# Build notre projet 
1. Installer [Flutter](https://docs.flutter.dev/get-started/install) 
2. Cloner le projet sur votre machine locale
3. Executer la commande ```flutter pub get``` dans l'invite de commandes à la racinde de votre projet
4. Lancer l'application (depuis VSCode par exemple avec F5)
   
Remarques:
- Il est normal de ne pas voir les images des exercices durant le run en mode debug, pour palier à se problème il faut désactiver le CORS (sécurité WEB), mais ce n'est pas grave car sur la version de prod les images s'affichent.
- Comme dit à l'assistant nous n'avons pas réussi à mettre en place des StreamBuilder ou provider pour gérer les différents states de notre programme, c'est pourquoi il faut des fois F5 ou changer de page puis revenir pour voir les modifications.

# Déployer une nouvelle fonctionnalité 
Avant de coder
1. Créer une issue
2. Assigner l'issue (assigné un label, un milestones, et l'ajouter au projet Kanban, pour plus de Précision voir le point "Pour participer au projet") 
3. Déplacer l'issue dans le Kanban du Backlog à WIP
4. Créer une nouvelle branche depuis l'issue en question

Avant de commit les modifications

5. ```flutter analyze```
 
6. ```flutter test```

7. Commit avec la bonne nomanclature [WIP], [DONE], ...
8. Push sur la branche
9. Pull request sur github et déplacer l'issue dans la colonne Review sur le Kanban 
10. Un autre développeur valide la pull request, l'issue est donc automatiquement déplacée vers la colonne "Done" du Kanban

# Contribution
- Sprints de 2 jours, pour avoir des feedbacks réguliers et dynamiques dans un projet de 3 semaines.
   - Lors des sprints : 
         1. Mise au points ce qui est fait et ce qu'il reste à faire
         2. Ajout de nouvelles tâches à un backlog via les issues github
         3. Répartition des tâches selon le label (```frontend``` (Jérémie et Théo), ```backend``` (Dorian et Oscar))
         4. Review des modifications ensemble pour vérifier que le code soit maintenable et suffisamment compréhensible
         5. Une fois les modifications validées, début du sprint suivant

## Pour participer au projet 
- Le projet contient la branch principal main (qui est automatiquement publié sur notre Firebase Hosting website), nous utilisons les branches pour ne pas travailler directement dessus. 

- Une issue possède un label qui doit être assigné : 
   - ```frontend``` : pour les taches de gestion de l'affichage
   - ```backend``` : pour les tâches sur la database ou pour l'api 

- Une issue possède un Milestones qui doit être assigné : 
   - ```First useable version``` : pour les tâches nécéssaires pour le fonctionnement de la premiere version 
   - ```Required additions``` : addition de features non-nécéssaires au bon fonctionnement mais requises pour l'application
   - ```Possible additions``` : addition de features non-nécéssaires au bon fonctionnement et non requises mais qui peuvent améliorer l'expérience utilisateur

- Convention de nommage des commits: [WIP], [DONE], [FIXED] + nom du commit (en français) 
      Ex: [WIP] Ajout du bouton de suppression de compte

      - WIP: En cours mais pas encore terminé

      - DONE: La tâche est terminée et prête à être review

      - FIXED: Modification (si nécessaire) d'une tâche après code review
      

- Il faut ensuite suivre la marche à suivre # Déployer une nouvelle fonctionnalité au dessus

# Architecture 

![](ressources/schema_pdg.png)

# Description du dossier lib 

1 - api — Pour les fonctions de récupération, modification ou suppression de données via Firebase Firestore

2 - model — Pour les différent model utilisés dans le projet

3 - screens  —  Pour les pages d'affichage 
      - during_session - Pour les pages lorsque l'utilisateur est en séance 
      - gestion - Pour la gestion des programmes, des séances, des exercices (CRUD)
      - home_screen - Pour la page d'accueil 
      - introduction - Pour les pages avant de s'identifier
      - user - Pour les pages d'information utilisateur et des paramètres
      
4 - files.dart - Pour gérer nos images présentes dans Firebase Storage

5 - firebase_options.dart - Pour les options firebase pour les utiliser avec Firebase apps.

6 - main.dart - Le point d'entrée de notre application.
