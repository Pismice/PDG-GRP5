import 'package:flutter/material.dart';

import '../../../model/exercice.dart';

class ExercicesPr extends StatefulWidget {
  const ExercicesPr({super.key});

  @override
  State<ExercicesPr> createState() => _ExercicesPrState();
}

class _ExercicesPrState extends State<ExercicesPr> {
  List<Exercice> myExercicesDone = [] ; // tous les exercices que jai deja fait et qui ont donc un pr

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
