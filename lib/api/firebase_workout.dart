import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:g2g/model/workout.dart';

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

Future<Workout> getWorkout(String documentId) async {
  final snapshot = await workouts.doc(documentId).get();
  if (snapshot.data() == null) {
    throw Exception("Workout non trouvé");
  }
  final workout = Workout.fromJson(snapshot.data()!);
  return workout;
}

Future<void> addWorkout(Workout workout) async {
  try {
    await workouts
        .withConverter(
            fromFirestore: Workout.fromFirestore,
            toFirestore: (Workout session, options) => session.toFirestore())
        .doc()
        .set(workout);
  } on Exception catch (e) {
    throw Exception("Erreur lors de l'ajout : $e");
  }
}

Future<void> updateWorkout(String docId, Workout workout) async {
  try {
    await workouts.doc(docId).update(workout.toFirestore());
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
