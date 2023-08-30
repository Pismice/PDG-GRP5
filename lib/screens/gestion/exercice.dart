import 'package:flutter/material.dart';

void main() => runApp(MyExerciceScreen());

class MyExerciceScreen extends StatefulWidget {
  MyExerciceScreen({Key? key}) : super(key: key);

  @override
  _MyExerciceScreen createState() => _MyExerciceScreen();
}

class _MyExerciceScreen extends State<MyExerciceScreen> {
  @override
  Widget build(BuildContext context) {
    return const Text('test 2');
  }
}
