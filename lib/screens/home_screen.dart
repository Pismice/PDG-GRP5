import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_workout.dart';
import 'package:g2g/screens/gestion/affichage/affichage_workout.dart';

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final workouts = getAllActiveWorkoutFrom();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Workout'),
          ),
          body: FutureBuilder(
            future: getAllWorkoutsFrom(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text("Error ${snapshot.error.toString()}");
              }
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, i) {
                      return Container(
                          padding: const EdgeInsets.all(15),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  backgroundColor: Colors.white),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyWorkoutInfoPage(
                                          snapshot.data![i].uid as String)),
                                );
                              },
                              child: Column(children: <Widget>[
                                Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                            snapshot.data![i].name as String))),
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount:
                                        snapshot.data![i].sessions!.length,
                                    itemBuilder: (context, j) {
                                      return Container(
                                          padding: const EdgeInsets.all(8),
                                          child: FutureBuilder(
                                            builder: ((context, snapshot) {
                                              if (snapshot.connectionState ==
                                                      ConnectionState.done &&
                                                  snapshot.hasData) {
                                                return ElevatedButton(
                                                    onPressed: () {
                                                      /*Changer de pages where la séance en cours*/
                                                    },
                                                    child: Text(snapshot.data!
                                                        .data()!['name']));
                                              }
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }),
                                            future: FirebaseFirestore.instance
                                                .collection('session')
                                                .doc(snapshot
                                                    .data![i].sessions![j].id)
                                                .get(),
                                          ));
                                    })
                              ])));
                    });
              }
              return const Center(child: CircularProgressIndicator());
            },
          )),
    );
  }
}
