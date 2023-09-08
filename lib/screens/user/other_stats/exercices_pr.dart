import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_exercise.dart';
import 'package:g2g/api/firebase_session.dart';
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
          title: const Text("My PRs"),
        ),
        body: FutureBuilder(
            future: getAllExercisesFrom(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text(
                    "Do you first exercices in order to have PRs displayed");
              } else {
                final exercices = snapshot.data!;
                return ListView.builder(
                    itemCount: exercices.length,
                    itemBuilder: (context, index) {
                      final exercise = exercices[index];
                      return FutureBuilder(
                          future: buildListTile(exercise),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Text("Error: ${snapshot.error}");
                            } else {
                              return snapshot.data ??
                                  const SizedBox(); // Return an empty SizedBox if data is null
                            }
                          });
                    });
              }
            }));
  }
}

Future<Widget> buildListTile(Exercise exercise) async {
  String metric = "";
  int value = 0;
  switch (exercise.type) {
    case "REP":
      value = await getRepetitionPR(exercise.uid!);
      metric = "x";
      break;
    case "TIME":
      value = await getDurationPR(exercise.uid!);
      metric = "s";
      break;
    case "WEIGHT":
    // Par défaut un exercice est considere comme WEIGHTed
    default:
      value = await getWeightPR(exercise.uid!);
      metric = "kg";
      break;
  }

  return ListTile(
    title: Text(exercise.name ?? "No name"),
    subtitle: Text("$value $metric"),
  );
}
