import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: /*Stack(children: [
          Container(
            color: Colors.blue,
            padding: const EdgeInsets.all(5.0),
            child: const Text(
              'data',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),*/
              ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(24),
              height: 150,
              color: Colors.amber[100],
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  const Text('TITRE WORKOUT'),
                  Container(
                    margin: const EdgeInsets.only(top: 24),
                    padding: const EdgeInsets.all(8),
                    color: Colors.amber[300],
                    child: const Text('SEANCE 1'),
                  )
                ],
              )),
          Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(24),
              height: 150,
              color: Colors.amber[100],
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  const Text('TITRE WORKOUT 2'),
                  Container(
                    margin: const EdgeInsets.only(top: 24),
                    padding: const EdgeInsets.all(8),
                    color: Colors.amber[300],
                    child: const Text('SEANCE 1'),
                  )
                ],
              )),
        ],
      )),
    );
  }
}
