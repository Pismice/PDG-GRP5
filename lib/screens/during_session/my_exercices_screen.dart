import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_exercise.dart';
import 'package:g2g/api/firebase_session.dart';
import 'package:g2g/model/workout.dart';
import 'package:g2g/screens/during_session/my_duration_screen.dart';
import 'package:g2g/screens/during_session/my_repetition_screen.dart';

// Widget qui affiche les exercices d'une séance en cours
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
            return Container(); // Loading indicator
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
                            return Container();
                          } else if (exoBase.hasError) {
                            return Text('Error: ${exoBase.error}');
                          } else if (!exoBase.hasData) {
                            return const Text('No data available');
                          } else {
                            String imageName =
                                exoBase.data!.img ?? "default.png";
                            bool isExerciseOver = false;
                            widget.onGoingSession.exercises ??= [];
                            // verifier si le nombre de set correspond au nombre de set voulu
                            if (widget.onGoingSession.exercises![index].sets ==
                                null) {
                              widget.onGoingSession.exercises![index].sets =
                                  <Sets>[];
                            }
                            if (sessionSnapshot.data!.exercises![index].set ==
                                widget.onGoingSession.exercises![index].sets!
                                    .length) {
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
                                  widget.onGoingSession.start = DateTime.now();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        if (exoBase.data!.type == "TIME") {
                                          return MyDuration(
                                            exoBase: exoBase.data!,
                                            exercise: sessionSnapshot
                                                .data!.exercises![index],
                                            workoutSessions:
                                                widget.onGoingSession,
                                            mySets: List.empty(),
                                          );
                                        }
                                        return MyRepetition(
                                          exoBase: exoBase.data!,
                                          exercise: sessionSnapshot
                                              .data!.exercises![index],
                                          workoutSessions:
                                              widget.onGoingSession,
                                          mySets: List.empty(),
                                        );
                                      },
                                    ),
                                  );
                                }
                              },
                              child: Container(
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
                                          return Container();
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
                                            // affiche correctement le message
                                            Text(exoBase.data!.type == "TIME"
                                                ? "${sessionSnapshot.data!.exercises![index].set.toString()} series of  ${sessionSnapshot.data!.exercises![index].duration.toString()} seconds"
                                                : "${sessionSnapshot.data!.exercises![index].set.toString()} series of  ${sessionSnapshot.data!.exercises![index].repetition.toString()} repetitions")
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
