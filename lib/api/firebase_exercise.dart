import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:g2g/api/firebase_workout.dart';
import 'package:g2g/model/exercise.dart';
import 'package:g2g/model/workout.dart';

final exercises = FirebaseFirestore.instance.collection('exercise');

/// Fonction qui retourne l'exercice correspondant au [documentId]
Future<Exercise> getExercise(String documentId) async {
  // on attends qu'on aille reçu le document
  final snapshot = await exercises.doc(documentId).get();

  if (snapshot.data() == null) {
    throw Exception("Exercice non trouvé");
  }
  // on remplie les infos concernant l'exercice
  Exercise exercise = Exercise.fromJson(snapshot.data()!);
  exercise.uid = documentId;

  return exercise;
}

/// Fonction qui ajoute un exercice à la base de données
Future<void> addExercise(Exercise exercise) async {
  try {
    // on convertis l'exercice dans le format requis
    await exercises
        .withConverter(
            fromFirestore: Exercise.fromFirestore,
            toFirestore: (Exercise exercise, options) => exercise.toFirestore())
        // on lui donne un nom de document
        .doc()
        // et on donne les infos
        .set(exercise);
  } on Exception catch (e) {
    throw Exception("Erreur lors de l'ajout : $e");
  }
}

/// Fonction qui met à jour un [exercice]
Future<void> updateExercise(Exercise exercise) async {
  try {
    // on recupère le document de la bdd et on le met à jour
    await exercises.doc(exercise.uid).update(exercise.toFirestore());
  } on Exception catch (e) {
    throw Exception("Erreur lors de la modification : $e");
  }
}

/// Fonction qui supprime l'exercice correspondant à [docId]
Future<void> deleteExercise(String docId) async {
  try {
    // on supprime le doc docId
    await exercises.doc(docId).delete();
  } on Exception catch (e) {
    throw Exception("Erreur lors de la suppressions : $e");
  }
}

/// Fonction qui retourne tous les exercices pour un utilsateur ayant
/// comme id d'authentification [authid]
Future<List<Exercise>> getAllExercisesOf({String? authid}) async {
  // on récupère l'id d'authentification de l'utilisateur
  String id =
      (authid != null) ? authid : FirebaseAuth.instance.currentUser!.uid;

  // on récupère une reference vers le user dans la bdd
  final userRef = await users
      .where('authid', isEqualTo: id)
      .limit(1)
      .get()
      .then((value) => users.doc(value.docs[0].id));

  // on récupère tout les exercices que l'user à créé
  final snapshot = await exercises.where("user", isEqualTo: userRef).get();

  // on formate la snapshot pour avoir une liste d'exercice
  final data = snapshot.docs.map((e) {
    Exercise exercise = Exercise.fromJson(e.data());
    exercise.uid = e.id;
    return exercise;
  }).toList();

  return data;
}

/// Récupère la liste de tous les exercices, on va récupérer tous
/// les exercices par défaut (n'ont pas de créateur) ou si [authid]
/// est renseigné, va retourner la même liste avec tous les exercices
/// que l'utilsateur renseigné a crée
Future<List<Exercise>> getAllExercises({String? authid}) async {
  final snapshot = await exercises /*.where("user", isEqualTo: null)*/ .get();

  List<Exercise> data = snapshot.docs.map((e) {
    Exercise exercise = Exercise.fromJson(e.data());
    exercise.uid = e.id;
    return exercise;
  }).toList();

  if (authid != null) {
    final userRef = await users
        .where('authid', isEqualTo: authid)
        .limit(1)
        .get()
        .then((value) => users.doc(value.docs[0].id));

    data.removeWhere(
        (exercise) => exercise.user != null && exercise.user != userRef.id);
  } else {
    data.removeWhere((exercise) => exercise.user != null);
  }

  return data;
}

/// Fonction qui retourne tout les exercices qu'un user a fait durant un workout
Future<List<Exercise>> getAllExercisesFrom({String? authid}) async {
  final List<Workout> workouts;
  if (authid != null) {
    workouts = await getAllWorkoutsFrom(uid: authid);
  } else {
    workouts = await getAllWorkoutsFrom();
  }

  List<Exercise> exercises = [];

  for (var workout in workouts) {
    for (var session in workout.sessions!) {
      if (session.exercises == null) continue;
      for (var exercise in session.exercises!) {
        var ex = await getExercise(exercise.id!);
        if (!exercises.any((e) => e.uid == exercise.id)) {
          exercises.add(ex);
        }
      }
    }
  }

  return exercises;
}
