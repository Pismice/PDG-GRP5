import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_exercise.dart';
import 'package:g2g/model/exercise.dart';

class ExercicesPr extends StatefulWidget {
  const ExercicesPr({super.key});

  @override
  State<ExercicesPr> createState() => _ExercicesPrState();
}

class _ExercicesPrState extends State<ExercicesPr> {
  List<Exercise> myExercicesDone =
      []; // tous les exercices que jai deja fait et qui ont donc un pr

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Mes PR"),
        ),
        body: FutureBuilder(
            future: getAllExercisesFrom(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Eroor: ${snapshot.error}");
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text(
                    "Do you first exercices in order to have PRs displayed");
              } else {
                final exercices = snapshot.data!;
                return ListView.builder(
                    itemCount: exercices.length,
                    itemBuilder: (context, index) {
                      final exercise = exercices[index];
                      return ListTile(
                        title: Text(exercise.name ?? "No name"),
                        subtitle: Text("0 kg"),
                      );
                    });
              }
            }));
  }
}
