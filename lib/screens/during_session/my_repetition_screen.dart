import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_session.dart';
import 'package:g2g/model/exercise.dart';
import 'package:g2g/model/session.dart';

class MyRepetition extends StatefulWidget {
  const MyRepetition(
      {super.key, required this.exercise, required this.exoBase});
  final SessionExercises exercise;
  final Exercise exoBase;

  @override
  State<MyRepetition> createState() => _MyRepetitionState();
}

class _MyRepetitionState extends State<MyRepetition> {
  bool isPlaying = false;
  final controller = ConfettiController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
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
                // TODO
                const Text("Série 2 sur 3"),
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
                        if (int.parse(value) < 0) {
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
                        if (int.parse(value) < 0) {
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
                      if (_formKey.currentState!.validate()) {
                        if (myPR < int.parse(ctrlWeight.text)) {
                          // PR battu !
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("New PR for this exercise !!!")),
                            );
                          }
                          controller.play();
                          await Future.delayed(
                              const Duration(milliseconds: 3000), () {
                            controller.stop();
                          });
                        }
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Your performance is now in the ROCK!")),
                          );
                        }

                        // TODO
                        // Inserer dans la BD l exo effectue

                        // Passer a la serie suivante ou revenir sur l ecran des exercices si cest termine
                        bool remainingSeries = false;
                        if (remainingSeries) {
                          // TODO
                        } else {
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
