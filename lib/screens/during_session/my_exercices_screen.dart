import 'package:flutter/material.dart';
import 'package:g2g/screens/during_session/my_repetition_screen.dart';

class MyExercices extends StatelessWidget {
  const MyExercices({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Le nom de ma séance"),
      ),
      body: Column(
        children: [
          const Text(
              "ici il y aura la liste des exercices de la séance avec le widget à theo"),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyRepetition()));
              },
              child: const Text("un exercice au hasard"))
        ],
      ),
    );
  }
}
