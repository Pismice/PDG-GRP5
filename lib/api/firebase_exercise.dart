import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:g2g/api/firebase_workout.dart';
import 'package:g2g/model/exercise.dart';
import 'package:g2g/model/workout.dart';

final exercises = FirebaseFirestore.instance.collection('exercise');

Future<Exercise> getExercise(String documentId) async {
  final snapshot = await exercises.doc(documentId).get();
  if (snapshot.data() == null) {
    throw Exception("Exercice non trouvé");
  }
  Exercise exercise = Exercise.fromJson(snapshot.data()!);
  exercise.uid = documentId;
  return exercise;
}

Future<void> addExercise(Exercise exercise) async {
  try {
    await exercises
        .withConverter(
            fromFirestore: Exercise.fromFirestore,
            toFirestore: (Exercise exercise, options) => exercise.toFirestore())
        .doc()
        .set(exercise);
  } on Exception catch (e) {
    throw Exception("Erreur lors de l'ajout : $e");
  }
}

Future<void> updateExercise(Exercise exercise) async {
  try {
    await exercises.doc(exercise.uid).update(exercise.toFirestore());
  } on Exception catch (e) {
    throw Exception("Erreur lors de la modification : $e");
  }
}

Future<void> deleteExercise(String docId) async {
  try {
    await exercises.doc(docId).delete();
  } on Exception catch (e) {
    throw Exception("Erreur lors de la suppressions : $e");
  }
}

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
