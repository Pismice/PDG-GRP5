import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_session.dart';
import 'package:g2g/api/firebase_workout.dart';
import 'package:g2g/model/workout.dart';
import 'package:g2g/screens/available_workouts_screen.dart';
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
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AvailableWorkouts()));
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text(
              'My ongoing workouts for week ${weekNumber(DateTime.now())}'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                      Color.fromARGB(255, 0, 6, 83),
                      Color.fromARGB(255, 38, 1, 73)
                    ])),
                child: FutureBuilder(
                  future: getAllActiveWorkoutsFrom(),
                  builder: (context, workoutsSnapshot) {
                    if (workoutsSnapshot.connectionState == ConnectionState.waiting ||
                        workoutsSnapshot.connectionState == ConnectionState.active) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (workoutsSnapshot.hasError) {
                      return Text("Error ${workoutsSnapshot.error.toString()}");
                    }
                    if (workoutsSnapshot.connectionState == ConnectionState.done &&
                        workoutsSnapshot.hasData) {
                      if (workoutsSnapshot.data!.isEmpty) {
                        return const Center(
                            child: Text("No active workout this week"));
                      }
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: workoutsSnapshot.data!.length,
                          itemBuilder: (context, i) {
                            return Container(
                                padding: const EdgeInsets.all(15),
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MyWorkoutInfoPage(
                                                workout: workoutsSnapshot.data![i])),
                                      );
                                    },
                                    child: Column(children: <Widget>[
                                      Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Container(
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                  workoutsSnapshot.data![i].name!, style: Theme.of(context)
                                                    .textTheme
                                                    .displayLarge,
                                              ))),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: workoutsSnapshot
                                              .data![i].sessions!.length,
                                          itemBuilder: (context, j) {
                                            return Container(
                                                padding: const EdgeInsets.all(1),
                                                color: Colors.blue,
                                                height: 100,
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
                                                                workoutsSnapshot
                                                                    .data![i]
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
                                                          child: Text(snapshotSession
                                                              .data!.name!));
                                                    }
                                                    return const Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                  }),
                                                  future: getSession(workoutsSnapshot
                                                      .data![i].sessions![j].id!),
                                                ));
                                          }),
                                      const SizedBox(
                                        height: 20,
                                      )
                                    ])));
                          });
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
