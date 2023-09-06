import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_session.dart';
import 'package:g2g/api/firebase_workout.dart';
import 'package:g2g/model/workout.dart';
import 'package:g2g/screens/during_session/my_exercices_screen.dart';
import 'package:g2g/screens/gestion/affichage/affichage_workout.dart';

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final workouts = getAllActiveWorkoutsFrom();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Workout'),
          ),
          body: FutureBuilder(
            future: getAllActiveWorkoutsFrom(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.active) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text("Error ${snapshot.error.toString()}");
              }
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text("Pas de workout actif pour cette semaine"));
                }
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
                                          snapshot.data![i].uid!)),
                                );
                              },
                              child: Column(children: <Widget>[
                                Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(snapshot.data![i].name!))),
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount:
                                        snapshot.data![i].sessions!.length,
                                    itemBuilder: (context, j) {
                                      return Container(
                                          padding: const EdgeInsets.all(8),
                                          child: FutureBuilder(
                                            builder:
                                                ((context, snapshotSession) {
                                              if (snapshotSession
                                                          .connectionState ==
                                                      ConnectionState.done &&
                                                  snapshotSession.hasData) {
                                                return ElevatedButton(
                                                    onPressed: () {
                                                      WorkoutSessions
                                                          workoutSessions =
                                                          snapshot.data![i]
                                                              .findWorkoutSessionById(
                                                                  snapshotSession
                                                                      .data!
                                                                      .uid!)!;
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                MyExercices(
                                                                    onGoingSession:
                                                                        workoutSessions)),
                                                      );
                                                    },
                                                    child: Text(snapshot
                                                        .data![i].name!));
                                              }
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }),
                                            future: getSession(snapshot
                                                .data![i].sessions![j].id!),
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
