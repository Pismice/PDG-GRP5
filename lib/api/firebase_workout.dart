import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_session.dart';
import 'package:g2g/model/session.dart';
import 'package:g2g/model/workout.dart';
import 'package:intl/intl.dart';

class GetWorkout extends StatelessWidget {
  final String documentId;

  const GetWorkout(this.documentId, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getWorkout(documentId),
      builder: (BuildContext context, AsyncSnapshot<Workout> snapshot) {
        if (snapshot.hasError) {
          return const Text("Quelque chose n'a pas fonctionné");
        }

        if (!snapshot.hasData) {
          return const Text("Le document n'existe pas");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return Text("${snapshot.data!.sessions!.length}");
        }

        return const Text("Chargement");
      },
    );
  }
}

final workouts = FirebaseFirestore.instance.collection('workout');
final users = FirebaseFirestore.instance.collection('user');

Future<Workout> getWorkout(String documentId) async {
  final snapshot = await workouts.doc(documentId).get();
  if (snapshot.data() == null) {
    throw Exception("Workout non trouvé");
  }
  Workout workout = Workout.fromJson(snapshot.data()!);
  workout.uid = documentId;

  for (var i = 0; i < workout.sessions!.length; i++) {
    workout.sessions![i].workoutId = workout.uid;
    if (workout.sessions![i].exercises == null) continue;
    for (var j = 0; j < workout.sessions![i].exercises!.length; ++j) {
      workout.sessions![i].exercises![j].session = workout.sessions![i];
    }
  }

  return workout;
}

Future<List<Workout>> getAllWorkoutsFrom({String? uid}) async {
  String id = (uid != null) ? uid : FirebaseAuth.instance.currentUser!.uid;

  final userRef = await users
      .where('authid', isEqualTo: id)
      .limit(1)
      .get()
      .then((value) => users.doc(value.docs[0].id));

  final snapshot = await workouts.where('user', isEqualTo: userRef).get();

  final data = snapshot.docs.map((w) {
    Workout workout = Workout.fromJson(w.data());
    workout.uid = w.id;
    for (var i = 0; i < workout.sessions!.length; i++) {
      workout.sessions![i].workoutId = workout.uid;
      if (workout.sessions![i].exercises == null) continue;
      for (var j = 0; j < workout.sessions![i].exercises!.length; ++j) {
        workout.sessions![i].exercises![j].session = workout.sessions![i];
      }
    }
    return workout;
  }).toList();

  return data;
}

Future<void> addSessionToWorkout(String idWorkout, String idSession) async {
  final w = await getWorkout(idWorkout);
  final s = await getSession(idSession);
  final ws = WorkoutSessions.fromSession(s);

  w.sessions!.add(ws);
  updateWorkout(w);
}

Future<void> deleteSessionFromWorkout(
    String idWorkout, String idSession) async {
  final w = await getWorkout(idWorkout);
  final sessions = <WorkoutSessions>[];
  if (w.sessions == null) {
    return;
  }
  bool deleted = false;
  for (var sess in w.sessions!) {
    if (sess.id == idSession && !deleted) {
      deleted = true;
      continue;
    }
    sessions.add(sess);
  }
  w.sessions = sessions;
  updateWorkout(w);
}

int numOfWeeks(int year) {
  DateTime dec28 = DateTime(year, 12, 28);
  int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
  return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
}

int weekNumber(DateTime date) {
  int dayOfYear = int.parse(DateFormat("D").format(date));
  int woy = ((dayOfYear - date.weekday + 10) / 7).floor();
  if (woy < 1) {
    woy = numOfWeeks(date.year - 1);
  } else if (woy > numOfWeeks(date.year)) {
    woy = 1;
  }
  return woy;
}

Future<List<Workout>> getAllActiveWorkoutsFrom({String? uid}) async {
  final data = await getAllWorkoutsFrom(uid: uid);
  final out = <Workout>[];
  final currentWeek = weekNumber(DateTime.now());
  for (var d in data) {
    if (d.week! >= currentWeek &&
        d.week! <= (currentWeek + (d.duration as int))) {
      out.add(d);
    }
  }
  return out;
}

Future<Workout> addWorkout(Workout workout) async {
  try {
    final newWorkoutRef = workouts
        .withConverter(
            fromFirestore: Workout.fromFirestore,
            toFirestore: (Workout session, options) => session.toFirestore())
        .doc();
    await newWorkoutRef.set(workout);

    // Get the newly added workout document
    final snapshot = await newWorkoutRef.get();

    // Create a Workout object from the fetched data
    final w = snapshot.data() as Workout;

    return w;
  } on Exception catch (e) {
    throw Exception("Erreur lors de l'ajout : $e");
  }
}

Future<void> updateWorkout(Workout workout) async {
  try {
    await workouts.doc(workout.uid).update(workout.toFirestore());
  } on Exception catch (e) {
    throw Exception("Erreur lors de la modification : $e");
  }
}

Future<void> deleteWorkout(String docId) async {
  try {
    await workouts.doc(docId).delete();
  } on Exception catch (e) {
    throw Exception("Erreur lors de la suppression : $e");
  }
}

Future<void> addExerciseDone(
    Workout workout, ExercisesDone exercise, String sessionId) async {
  Session session = await getSession(sessionId);
  bool inSession = false;
  for (var sessExercise in session.exercises!) {
    if (sessExercise.id == exercise.id) {
      inSession = true;
    }
  }

  if (!inSession) {
    throw Exception("L'exercice effectué n'est pas prévu dans cette séance");
  }

  for (var session in workout.sessions!) {
    if (session.id != sessionId) continue;
    session.exercises!.add(exercise);
  }
  updateWorkout(workout);
}
