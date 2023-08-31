import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class MyRepetition extends StatefulWidget {
  const MyRepetition({super.key});

  @override
  State<MyRepetition> createState() => _MyRepetitionState();
}

class _MyRepetitionState extends State<MyRepetition> {
  bool isPlaying = false;
  final controller = ConfettiController();

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
    return Stack(
      alignment: Alignment.center,
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text("Nom de l'exercice"),
          ),
          body: Column(
            children: [
              const Text("Série 2 sur 3"),
              const Row(
                children: [
                  Text("Nombre de répétitions"),
                  Expanded(child: TextField()),
                ],
              ),
              const Row(
                children: [
                  Text("Poids (kg)"),
                  Expanded(child: TextField()),
                ],
              ),
              const Image(
                width: 100.0,
                fit: BoxFit.fitWidth,
                image: NetworkImage(
                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
              ),
              ElevatedButton(
                  onPressed: () {
                    controller.play();
                    Future.delayed(const Duration(milliseconds: 500), () {
                      controller.stop();
                    });
                  },
                  child: const Text("Valider ma série"))
            ],
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
