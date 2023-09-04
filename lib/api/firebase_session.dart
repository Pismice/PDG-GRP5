import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_workout.dart';
import 'package:g2g/model/session.dart';
import 'package:g2g/model/workout.dart';

class GetSession extends StatelessWidget {
  final String documentId;

  const GetSession(this.documentId, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSession(documentId),
      builder: (BuildContext context, AsyncSnapshot<Session> snapshot) {
        if (snapshot.hasError) {
          return const Text("Quelque chose n'a pas fonctionné");
        }

        if (!snapshot.hasData) {
          return const Text("Le document n'existe pas");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return Text(snapshot.data!.name!);
        }

        return const Text("Chargement");
      },
    );
  }
}

final sessions = FirebaseFirestore.instance.collection('session');
final users = FirebaseFirestore.instance.collection('user');

Future<Session> getSession(String documentId) async {
  final snapshot = await sessions.doc(documentId).get();
  if (snapshot.data() == null) {
    throw Exception("Séance non trouvée");
  }
  Session session = Session.fromJson(snapshot.data()!);
  session.uid = documentId;
  return session;
}

Future<List<Session>> getAllSessionsFrom({String? uid}) async {
  String id = (uid != null) ? uid : FirebaseAuth.instance.currentUser!.uid;

  final userRef = await users
      .where('authid', isEqualTo: id)
      .limit(1)
      .get()
      .then((value) => users.doc(value.docs[0].id));

  final snapshot = await sessions.where('user', isEqualTo: userRef).get();

  final data = snapshot.docs.map((s) {
    Session session = Session.fromJson(s.data());
    session.uid = s.id;
    return session;
  }).toList();

  return data;
}

/// Ajoute une [Session] qui correspond à une séance dans la base de donnée
Future<void> addSession(Session session) async {
  try {
    await sessions
        .withConverter(
            fromFirestore: Session.fromFirestore,
            toFirestore: (Session session, options) => session.toFirestore())
        .doc()
        .set(session);
  } on Exception catch (e) {
    throw Exception("Erreur lors de l'ajout : $e");
  }
}

/// Met à jour une [Session] passée en paramètre en fonction de son
/// [docId]
Future<void> updateSession(Session session) async {
  try {
    await sessions.doc(session.uid).update(session.toFirestore());
  } on Exception catch (e) {
    throw Exception("Erreur lors de la modification : $e");
  }
}

Future<void> deleteSession(String docId) async {
  try {
    await sessions.doc(docId).delete();
  } on Exception catch (e) {
    throw Exception("Erreur lors de la suppression : $e");
  }
}

enum _SetsValue { repetition, weight, duration }

/// Permet de récupérer la meilleure valeur enregistrée par un utilisateur [authid]
/// sur un exercice donné [exId].
/// Les valeurs possibles sont 'repetition', 'weight' et 'duration'.
///
/// Retourne la meilleure mesure enregristrée
Future<int> _getPR(String exId, _SetsValue sets, {String? authid}) async {
  final List<Workout> workouts;
  if (authid != null) {
    workouts = await getAllWorkoutsFrom(uid: authid);
  } else {
    workouts = await getAllWorkoutsFrom();
  }

  int pr = 0;

  for (var workout in workouts) {
    for (var session in workout.sessions!) {
      for (var exercise in session.exercises!) {
        if (exercise.id != exId) continue;

        for (var set in exercise.sets!) {
          switch (sets) {
            case _SetsValue.repetition:
              if (set.repetition != null && set.repetition! > pr) {
                pr = set.repetition!;
              }
              break;
            case _SetsValue.weight:
              if (set.weight != null && set.weight! > pr) {
                pr = set.weight!;
              }
              break;
            case _SetsValue.duration:
              if (set.duration != null && set.duration! > pr) {
                pr = set.duration!;
              }
              break;
          }
        }
      }
    }
  }

  return pr;
}

Future<int> getWeightPR(String exId, {String? authid}) async {
  if (authid != null) {
    return await _getPR(exId, _SetsValue.weight, authid: authid);
  }
  return await _getPR(exId, _SetsValue.weight);
}

Future<int> getDurationPR(String exId, {String? authid}) async {
  if (authid != null) {
    return await _getPR(exId, _SetsValue.duration, authid: authid);
  }
  return await _getPR(exId, _SetsValue.duration);
}

Future<int> getBestRepetitionNb(String exId, {String? authid}) async {
  if (authid != null) {
    return await _getPR(exId, _SetsValue.repetition, authid: authid);
  }
  return await _getPR(exId, _SetsValue.repetition);
}

Future<int> getBestSetsNb(String exId, {String? authid}) async {
  final List<Workout> workouts;
  if (authid != null) {
    workouts = await getAllWorkoutsFrom(uid: authid);
  } else {
    workouts = await getAllWorkoutsFrom();
  }

  int pr = 0;

  for (var workout in workouts) {
    for (var session in workout.sessions!) {
      for (var exercise in session.exercises!) {
        if (exercise.id != exId) continue;

        if (exercise.sets!.length > pr) {
          pr = exercise.sets!.length;
        }
      }
    }
  }

  return pr;
}
