import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:g2g/api/firebase_session.dart';
import 'package:g2g/model/session.dart';
import 'package:g2g/model/workout.dart';
import 'package:intl/intl.dart';

final workouts = FirebaseFirestore.instance.collection('workout');
final users = FirebaseFirestore.instance.collection('user');

/// Fonction qui retourne un workout selon son [documentId]
Future<Workout> getWorkout(String documentId) async {
  final snapshot = await workouts.doc(documentId).get();
  if (snapshot.data() == null) {
    throw Exception("Workout non trouvé");
  }
  Workout workout = Workout.fromJson(snapshot.data()!);
  workout.uid = documentId;

  // ajoute les workoutId au session et les session au exerciseDone
  for (var i = 0; i < workout.sessions!.length; i++) {
    workout.sessions![i].workoutId = workout.uid;
    if (workout.sessions![i].exercises == null) continue;
    for (var j = 0; j < workout.sessions![i].exercises!.length; ++j) {
      workout.sessions![i].exercises![j].session = workout.sessions![i];
    }
  }

  return workout;
}

/// Fonction qui retourne tous les workouts d'un utilisateur
Future<List<Workout>> getAllWorkoutsFrom({String? uid}) async {
  String id = (uid != null) ? uid : FirebaseAuth.instance.currentUser!.uid;


  

  final values = await users
      .where('authid', isEqualTo: id)
      .limit(1)
      .get()
      .then((value) => value);
  // vérifie que l'user existe dans la bdd
  if (values.docs.isEmpty) {
    return <Workout>[];
  }
  // on récupère la référence à l'utilisateur dans la bdd
  final userRef = users.doc(values.docs[0].id);
    // récupère les workouts
  final snapshot = await workouts.where('user', isEqualTo: userRef).get();
  // formate les workout
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

/// Fonction qui ajoute une séance [idSession] à un workout [idWorkou]
Future<void> addSessionToWorkout(String idWorkout, String idSession) async {
  // récup le workout
  final w = await getWorkout(idWorkout);
  // récup la séance
  final s = await getSession(idSession);
  // formate la séance en séance de workout
  final ws = WorkoutSessions.fromSession(s);
  // on ajout la séance au workout
  w.sessions!.add(ws);
  // on mets à jour le workout
  updateWorkout(w);
}

/// Fonction qui supprime une séance [isSession] d'un workout [idWorkout]
Future<void> deleteSessionFromWorkout(
    String idWorkout, String idSession) async {
  final w = await getWorkout(idWorkout);
  final sessions = <WorkoutSessions>[];
  // si il y a pas de sessions dans le workout => on ne peut pas en supprimer
  if (w.sessions == null) {
    return;
  }
  // bool qui nous sert dans le cas ou il y a 2 fois la meme séance dans un workout
  bool deleted = false;
  for (var sess in w.sessions!) {
    // si [sess] est la séance à suppr et qu'on a pas déjà supprimer la séance
    if (sess.id == idSession && !deleted) {
      // on passe à la séance suivante
      deleted = true;
      continue;
    }
    // sinon on ajoute la séance
    sessions.add(sess);
  }
  // on met à jour les séances du workout
  w.sessions = sessions;
  updateWorkout(w);
}

/// Fonction qui nous donne le nombre de semaine d'une année donné
int numOfWeeks(int year) {
  DateTime dec28 = DateTime(year, 12, 28);
  int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
  return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
}

/// Fonction qui retourne quel est le numéro de semaine selon la [date]
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

/// Fonction qui retourne tous les workout qui sont actif cette semaine
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

/// Fonction qui ajoute un [workout] à la bdd
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

/// Fonction qui met à jour un [workout] dans la bdd
Future<void> updateWorkout(Workout workout) async {
  try {
    await workouts.doc(workout.uid).update(workout.toFirestore());
  } on Exception catch (e) {
    throw Exception("Erreur lors de la modification : $e");
  }
}

/// Fonction qui supprime le workout avec le id de doc = [docId]
Future<void> deleteWorkout(String docId) async {
  try {
    await workouts.doc(docId).delete();
  } on Exception catch (e) {
    throw Exception("Erreur lors de la suppression : $e");
  }
}

/// Fonction qui ajoute un exercice fait durant une séance d'un workout
Future<void> addExerciseDone(
    Workout workout, ExercisesDone exercise, String sessionId) async {
  Session session = await getSession(sessionId);
  bool inSession = false;
  // vérifie que l'exercice était prévu
  for (var sessExercise in session.exercises!) {
    if (sessExercise.id == exercise.id) {
      inSession = true;
    }
  }

  if (!inSession) {
    throw Exception("L'exercice effectué n'est pas prévu dans cette séance");
  }
  // ajoute l'exercice
  for (var session in workout.sessions!) {
    if (session.id != sessionId) continue;
    session.exercises!.add(exercise);
  }
  // met à jour le workout
  updateWorkout(workout);
}
