import 'package:flutter/material.dart';
/*import 'package:g2g/screens/during_session/my_exercices_screen.dart';*/

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final item = List<String>.generate(5, (index) => "$index");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: ListView.builder(
              shrinkWrap: true,
              itemCount: item.length,
              itemBuilder: (context, i) {
                return Container(
                    padding: const EdgeInsets.all(15),
                    /*padding: const EdgeInsets.only(top: 5, bottom: 5),
                    margin: const EdgeInsets.only(top: 5, bottom: 5),
                    color: Colors.amber[100],*/

                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            backgroundColor: Colors.white),
                        onPressed: () {},
                        child: Column(children: <Widget>[
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Text("Workout $i"))),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: item.length - i + 1,
                              itemBuilder: (context, j) {
                                return Container(
                                    padding: const EdgeInsets.all(8),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          /* Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MyExercices()));*/
                                        },
                                        child: Text("Séance $i")));
                              })
                        ])));
              }

              /*Container(
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
              )),*/
              )),
    );
  }
}
/*
ElevatedButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MyExercices()));
        },
        child: const Text("Je lance CETTE séance")); */