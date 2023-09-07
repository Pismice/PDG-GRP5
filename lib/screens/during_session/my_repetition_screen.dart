import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_session.dart';
import 'package:g2g/api/firebase_workout.dart';
import 'package:g2g/model/exercise.dart';
import 'package:g2g/model/session.dart';
import 'package:g2g/model/workout.dart';

class MyRepetition extends StatefulWidget {
  final SessionExercises exercise;
  final Exercise exoBase;
  final WorkoutSessions workoutSessions;
  final List<Sets> mySets;
  const MyRepetition(
      {super.key,
      required this.exercise,
      required this.exoBase,
      required this.workoutSessions,
      required this.mySets});

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
                    const Text("Number of repetitions"),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: widget.exercise.repetition.toString(),
                      ),
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
                    const Text("Weights (kg)"),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: widget.exercise.weight.toString(),
                      ),
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
                FutureBuilder(
                    future: getWeightPR(FirebaseAuth.instance.currentUser!.uid),
                    builder: (context, prSnapshot) {
                      if (prSnapshot.connectionState == ConnectionState.done) {
                        if (prSnapshot.hasData) {
                          int myPR = prSnapshot.data!;
                          for (Sets exo in onGoingSets) {
                            if (exo.weight! >= prSnapshot.data!) {
                              myPR = exo.weight!;
                            }
                          }
                          return Text("My current PR = ${myPR.toString()} kg");
                        }
                        return const Text("No PR found for this exercise");
                      }
                      return const CircularProgressIndicator();
                    }),
                FutureBuilder(
                  future: FirebaseStorage.instance
                      .refFromURL('gs://hongym-4cb68.appspot.com')
                      .child("img/exercises/${widget.exoBase.img}")
                      .getDownloadURL(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    return Image.network(
                      snapshot.data.toString(),
                      height: 100,
                      width: 100,
                    );
                  },
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
                                const Duration(milliseconds: 1000), () {
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
                                        workoutSessions: widget.workoutSessions,
                                        mySets: onGoingSets)));
                          }
                        } else {
                          // Il ne reste plus de série à effectuer
                          // Inserer dans la BD
                          ExercisesDone exercisesDone = ExercisesDone(
                              id: widget.exercise.id, sets: onGoingSets);
                          Workout workout = await getWorkout(
                              widget.workoutSessions.workoutId!);

                          await addExerciseDone(workout, exercisesDone,
                              widget.workoutSessions.id!);

                          if (context.mounted) {
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
