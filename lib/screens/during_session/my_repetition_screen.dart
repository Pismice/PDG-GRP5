import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_session.dart';
import 'package:g2g/model/exercise.dart';
import 'package:g2g/model/session.dart';
import 'package:g2g/model/workout.dart';

// ignore: must_be_immutable
class MyRepetition extends StatefulWidget {
  MyRepetition(
      {super.key,
      required this.exercise,
      required this.exoBase,
      required this.mySets});
  final SessionExercises exercise;
  final Exercise exoBase;
  List<Sets> mySets;

  @override
  State<MyRepetition> createState() => _MyRepetitionState();
}

class _MyRepetitionState extends State<MyRepetition> {
  List<Sets> onGoingSets = List<Sets>.from(List.empty(growable: true));
  bool isPlaying = false;
  bool isSent = false;
  final controller = ConfettiController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    onGoingSets = List<Sets>.from(widget.mySets);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController ctrlNbReps = TextEditingController();
    TextEditingController ctrlWeight = TextEditingController();
    return Stack(
      alignment: Alignment.center,
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(widget.exoBase.name!),
          ),
          body: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                    "Série ${onGoingSets.length + 1} sur ${widget.exercise.set}"),
                Row(
                  children: [
                    const Text("Nombre de répétitions"),
                    Expanded(
                        child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: ctrlNbReps,
                      validator: (value) {
                        try {
                          int.parse(value!);
                        } catch (e) {
                          return "Must be a number";
                        }
                        if (int.parse(value) <= 0) {
                          return "Must be positive";
                        }
                        return null;
                      },
                    )),
                  ],
                ),
                Row(
                  children: [
                    const Text("Poids (kg)"),
                    Expanded(
                        child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: ctrlWeight,
                      validator: (value) {
                        try {
                          int.parse(value!);
                        } catch (e) {
                          return "Must be a number";
                        }
                        if (int.parse(value) <= 0) {
                          return "Must be positive";
                        }
                        return null;
                      },
                    )),
                  ],
                ),
                const Image(
                  width: 100.0,
                  fit: BoxFit.fitWidth,
                  image: NetworkImage(
                      'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                ),
                ElevatedButton(
                    onPressed: () async {
                      int myPR = await getWeightPR(widget.exoBase.uid!);
                      if (_formKey.currentState!.validate() && !isSent) {
                        int myPerformance = int.parse(ctrlWeight.text);
                        bool isPrBeaten = false;
                        isSent = true;
                        if (myPR < myPerformance) {
                          isPrBeaten = true;
                          for (Sets exo in onGoingSets) {
                            if (exo.weight! >= myPerformance) {
                              // Un exercice recent est meilleur donc pas de PR ...
                              isPrBeaten = false;
                              break;
                            }
                          }
                          if (context.mounted && isPrBeaten) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("New PR for this exercise !!!")),
                            );
                            controller.play();
                            await Future.delayed(
                                const Duration(milliseconds: 3000), () {
                              controller.stop();
                            });
                          }
                        }
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Your performance is now in the ROCK!")),
                          );
                        }

                        // Inserer dans la liste de sets
                        Sets sets = Sets(
                            repetition: int.parse(ctrlNbReps.text),
                            weight: int.parse(ctrlWeight.text));
                        onGoingSets.add(sets);

                        // Passer a la serie suivante ou revenir sur l ecran des exercices si cest termine
                        if (onGoingSets.length < widget.exercise.set!) {
                          // Il reste des séries
                          if (context.mounted) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyRepetition(
                                        exercise: widget.exercise,
                                        exoBase: widget.exoBase,
                                        mySets: onGoingSets)));
                          }
                        } else {
                          // Il ne reste plus de série à effectuer
                          // Inserer dans la BD
                          ExercisesDone exercisesDone = ExercisesDone(
                              id: widget.exercise.id, sets: onGoingSets);
                          Session session =
                              await getSession(widget.exercise.sessionId!);
                          //TODO: addExerciseDone(//TODO, exercisesDone, widget.exercise.sessionId!);
                          if (context.mounted) {
                            //Future.delayed(const Duration(seconds: 3));
                            Navigator.pop(context);
                          }
                        }
                      }
                    },
                    child: const Text("Enter my results in the rock"))
              ],
            ),
          ),
        ),
        ConfettiWidget(
          confettiController: controller,
          shouldLoop: true,
          blastDirection: -pi / 2, // up
          numberOfParticles: 50,
          minBlastForce: 5,
          maxBlastForce: 10,
          gravity: 0.001,
        )
      ],
    );
  }
}
