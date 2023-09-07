import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_exercise.dart';
import 'package:g2g/api/firebase_session.dart';
import 'package:g2g/model/workout.dart';
import 'package:g2g/screens/during_session/my_repetition_screen.dart';

class MyExercices extends StatefulWidget {
  const MyExercices({super.key, required this.onGoingSession});
  final WorkoutSessions onGoingSession;

  @override
  State<MyExercices> createState() => _MyExercicesState();
}

class _MyExercicesState extends State<MyExercices> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getSession(widget.onGoingSession.id!),
        builder: (context, sessionSnapshot) {
          if (sessionSnapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Loading indicator
          } else if (sessionSnapshot.hasError) {
            return Text('Error: ${sessionSnapshot.error}'); // Handle errors
          } else if (!sessionSnapshot.hasData) {
            return const Text('Session not found');
          } else {
            return Scaffold(
                appBar: AppBar(
                  title: Text(sessionSnapshot.data!.name!),
                ),
                body: ListView.builder(
                  itemCount: sessionSnapshot.data!.exercises!.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                        future: getExercise(
                            sessionSnapshot.data!.exercises![index].id!),
                        builder: (context, exoBase) {
                          if (exoBase.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (exoBase.hasError) {
                            return Text('Error: ${exoBase.error}');
                          } else if (!exoBase.hasData) {
                            return const Text('No data available');
                          } else {
                            String imageName =
                                exoBase.data!.img ?? "default.png";
                            bool isExerciseOver = false;
                            widget.onGoingSession.exercises ??= [];
                            if (sessionSnapshot.data!.exercises!.length ==
                                widget.onGoingSession.exercises!.length) {
                              isExerciseOver = true;
                            }
                            return GestureDetector(
                              onTap: () {
                                if (isExerciseOver) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "You have already done this exercise, choose another remaining one")),
                                  );
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyRepetition(
                                                exoBase: exoBase.data!,
                                                exercise: sessionSnapshot
                                                    .data!.exercises![index],
                                                workoutSessions:
                                                    widget.onGoingSession,
                                                mySets: List.empty(),
                                              )));
                                }
                              },
                              child: Container(
                                // TODO: si toutes les series de cet exercice sont faits il faut mettre en vert
                                decoration: BoxDecoration(
                                    color: isExerciseOver
                                        ? Colors.green
                                        : Colors.grey,
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2.0,
                                    )),
                                child: Row(
                                  children: [
                                    FutureBuilder(
                                      future: FirebaseStorage.instance
                                          .refFromURL(
                                              'gs://hongym-4cb68.appspot.com')
                                          .child("img/exercises/$imageName")
                                          .getDownloadURL(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        }
                                        return Image.network(
                                          snapshot.data.toString(),
                                          height: 100,
                                          width: 100,
                                        );
                                      },
                                    ),
                                    Column(
                                      children: [
                                        Text(exoBase.data!.name!),
                                        Row(
                                          children: [
                                            Text(
                                                "${sessionSnapshot.data!.exercises![index].set.toString()} series of  ${sessionSnapshot.data!.exercises![index].repetition.toString()} repetitions")
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        });
                  },
                ));
          }
        });
  }
}
