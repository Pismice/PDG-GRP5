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
                const Text("Série 2 sur 3"),
                Row(
                  children: [
                    const Text("Nombre de répétitions"),
                    Expanded(
                        child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: ctrlNbReps,
                      validator: (value) {
                        if (int.parse(value!) < 0) {
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
                        if (int.parse(value!) < 0) {
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
                      if (_formKey.currentState!.validate()) {
                        if (await getWeightPR(widget.exoBase.uid!) <
                            int.parse(ctrlWeight.text)) {
                              // PR battu !
                          controller.play();
                          Future.delayed(const Duration(milliseconds: 500), () {
                            controller.stop();
                          });
                        }
                        // Inserer dans la BD l exo effectue
                        
                      }
                    },
                    child: const Text("Valider ma série"))
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
