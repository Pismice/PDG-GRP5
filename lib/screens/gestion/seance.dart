import 'package:flutter/material.dart';

void main() => runApp(MySessionScreen());

class MySessionScreen extends StatefulWidget {
  MySessionScreen({Key? key}) : super(key: key);

  @override
  _MySessionPageState createState() => _MySessionPageState();
}

class _MySessionPageState extends State<MySessionScreen> {
  @override
  Widget build(BuildContext context) {
    return const Text('test');
  }
}
