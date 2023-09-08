import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_exercise.dart';
import 'package:g2g/api/firebase_session.dart';
import 'package:g2g/model/exercise.dart';

/// Page qui affiche les PR de l'utilisateur
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
        // Récupération de la liste des exercices effectués par l'utilisateur
        // ------------------------------------------------------------------
        future: getAllExercisesFrom(),
        builder: (context, snapshot) {
          // Tests de la validation de la récupération des données
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          // S'il n'y a aucun PR effectué
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text(
                "Do you first exercices in order to have PRs displayed");
          }
          final exercices = snapshot.data!;
          return ListView.builder(
            // Affichage de la liste de tous les PR utilisateur
            // ------------------------------------------------
            itemCount: exercices.length,
            itemBuilder: (context, index) {
              final exercise = exercices[index];
              return FutureBuilder(
                future: buildListTile(exercise),
                builder: (context, snapshot) {
                  // Test de la récupération du future
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }
                  return snapshot.data ??
                      const SizedBox(); // Return an empty SizedBox if data is null
                },
              );
            },
          );
        },
      ),
    );
  }
}

/// Création des titres de la List d'affichage, en affichant les infos sur
/// [exercise]
Future<Widget> buildListTile(Exercise exercise) async {
  String metric = "";
  int value = 0;
  // Récupération du PR de l'exercice en fonction de son type d'exercice
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
