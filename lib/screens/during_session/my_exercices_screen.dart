import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_exercise.dart';
import 'package:g2g/api/firebase_session.dart';
import 'package:g2g/model/session.dart';
import 'package:g2g/model/workout.dart';

// ignore: must_be_immutable
class MyExercices extends StatelessWidget {
  MyExercices({super.key, required this.onGoingSession});
  final WorkoutSessions onGoingSession;
  Session session = Session();

  Future<void> loadSessionData() async {
    session = await getSession(onGoingSession.id!);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadSessionData(),
        builder: (context, empty) {
          if (empty.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Loading indicator
          } else if (empty.hasError) {
            return Text('Error: ${empty.error}'); // Handle errors
          } else {
            return Scaffold(
                appBar: AppBar(
                  title: Text(session.name!),
                ),
                body: ListView.builder(
                  itemCount: session.exercises!.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                        future: getExercise(session.exercises![index].id!),
                        builder: (context, exoBase) {
                          if (exoBase.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (exoBase.hasError) {
                            return Text('Error: ${exoBase.error}');
                          } else {
                            return Row(
                              children: [
                                FutureBuilder(
                                  future: FirebaseStorage.instance
                                      .refFromURL(
                                          'gs://hongym-4cb68.appspot.com')
                                      .child(
                                          "img/exercises/${exoBase.data!.img!}") // TODO image de secours
                                      .getDownloadURL(),
                                  builder: (context, snapshotImage) {
                                    if (exoBase.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshotImage.hasError) {
                                      return Text(
                                          'Error: ${snapshotImage.error}');
                                    } else {
                                      return Image.network(
                                        snapshotImage.data.toString(),
                                        height: 100,
                                        width: 100,
                                      );
                                    }
                                  },
                                ),
                                Column(
                                  children: [
                                    Text(exoBase.data!.name!),
                                    Row(
                                      children: [
                                        Text(
                                            "${session.exercises![index].set.toString()} x ${session.exercises![index].repetition.toString()}")
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            );
                          }
                        });
                  },
                ));
          }
        });
  }
}
