import 'package:flutter/material.dart';
import 'package:g2g/screens/during_session/my_exercices_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MyExercices()));
        },
        child: const Text("Je lance CETTE séance"));
  }
}
