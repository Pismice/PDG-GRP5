![](ressources/large.jpg)
# Gym 2 Golem

Gym 2 golem est une application de fitness qui acompagne les utilisateurs avant, pendant et après leur séance de sport. 
Il est compliqué de structuré ses programmes de sport, de rester motivé, et de garder un suivi de ta progression. 

Et il n'existe pas de solution efficaces actuellement, c'est pourquoi nous avons décidé de développer Gym 2 Golem. 
C'est une solution facile de prise en main, où tout est centraliser au même endroit et accessible partout et à tout moment. 

Sur Gym 2 golem, il est possible de plannifié ces programmes, avec des séances et des exercices. 
Plus besoin de réflechir sur le nombre de set, de répétition ou le poids à utilisé, l'application te suit pendant la séance.
Reste motivé en battant tes records et en suivant ta progression. 

# Acceder à l'application 
Cliquer sur le [lien](https://gilliozdorian.wixsite.com/gym2golem) pour accéder à notre application
# Build notre projet 
1. Installer [Flutter](https://docs.flutter.dev/get-started/install) 
2. Cloner le projet sur votre machine local
3. Executer la commande ```Flutter get pub``` dans l'invite de commandes à la racinde de votre projet
4. Lancer l'application (depuis VSCode par exemple)

# Déployer une nouvelle fonctionnalité 
Avant de coder
1. Créer une issue
2. Assigner l'issue (assigné un label, un milestones, et l'ajouter au projet Kanban, pour plus de Précision voir le point "Pour participer au projet") 
3. Déplacer l'issue dans le Kanban du Backlog à WIP
4. Create une new branch depuis l'issue en question

Avant de commit les modifications

5. ```Flutter analyze```
 
6. ```Flutter test```

7. Commit avec la bonne nomanclature [WIP], [Fix], ...
8. Push sur la branch
9. Pull request sur github et déplacer l'issue dans la colonne Review sur le Kanban 
10. Un autre développeur valide la pull request et deplace l'issue dans la colone Done sur la Kanban 

# Contribution
- Sprints de 2 jours, pour avoir des feedback réguliers et dynamique dans un projet de 3 semaines.
   - Lors des sprints : 
         1. Mise au points ce qui est fait et ce qu'il reste à faire
         1. Ajout de nouvelles tâches à un backlog via les issues github
         2. Répartition des tâches selon le label (```frontend``` (Jérémie et Théo), ```backend``` (Dorian et Oscar))
         3. Review des modifications ensemble pour vérifier que le code soit maintenable et suffisamment compréhensible
         4. Une fois les modifications validées, début du sprint suivant

## Pour participer au projet 
- Le projet contient la branch principal main, nous utilisons les branches pour ne pas travailler directement dessus. 

- Une issue possède un label qui doit être assigné : 
   - ```frontend``` : pour les taches de gestion de l'affichage
   - ```backend``` : pour les tâches sur la database ou pour l'api 

- Une issue possède un Milestones qui doit être assigné : 
   - ```First useable version``` : pour les tâches nécéssaire pour le fonctionnement de la premiere version 
   - ```Required additions``` : addition de features non-nécéssaire au bon fonctionnement mais requise pour l'application
   - ```Possible additions``` : addition de features non-nécéssaire au bon fonctionnement et non requise mais qui peuvent améliorer l'expérience utilisateur

- Convention de nommage des commits: [WIP], [DONE], [FIXED] + nom du commit (en anglais) 
      Ex: [WIP] Add button delete account

      - WIP: En cours mais pas encore terminé

      - DONE: La tâche est terminée et prête à être review

      - FIXED: Modification (si nécessaire) d'une tâche après code review
      

- Il faut ensuite suivre la marche a suivre # Déployer une nouvelle fonctionnalité au dessus

# Architecture 

![](ressources/schema_pdg.png)

# Description du dossier lib 

1 - api — Pour les fonctions de récupération, modification ou suppression de données 
2 - model — Pour les différent model utilisé dans le porjet
3 - screens — Pour les pages d'afficage 
      - during_session - Pour les pages lorsque l'utilisateur est en séance 
      - gestion - Pour la gestion des programmes, des séances, des exercices
      - home_screen - Pour la page d'accueil 
      - introduction - Pour les pages avant de s'identifier
      - user - Pour les pages d'information utilisateur
4 - files.dart - Pour l'upload d'image
5 - firebase_options.dart - Pour les options firebase pour les utiliser avec Firebase apps.
6 - main.dart - Le point d'entrée de notre application.
