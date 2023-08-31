import 'dart:convert';
import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:g2g/model/workout.dart';
import 'package:uuid/uuid.dart';

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
          return const Text("data");
        }

        return const Text("Chargement");
      },
    );
  }
}

final workouts = FirebaseFirestore.instance.collection('workout');

Future<Workout> getWorkout(String documentId) async {
  final snapshot = await workouts.doc(documentId).get();
  if (snapshot.data() == null) {
    throw Exception("Workout non trouvé");
  }
  final workout = Workout.fromJson(snapshot.data()!);
  return workout;
}

Future<void> addWorkout(Workout workout) async {
  await workouts
      .withConverter(
          fromFirestore: Workout.fromFirestore,
          toFirestore: (Workout session, options) => session.toFirestore())
      .doc(const Uuid().v1())
      .set(workout);
}

Future<void> updateWorkout(String docId, Workout workout) async {
  try {
    await workouts.doc(docId).update(workout.toFirestore());
  } on Exception catch (e) {
    throw Exception(e.toString());
  }
}
