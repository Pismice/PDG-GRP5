import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_exercise.dart';
import 'package:g2g/model/session.dart';
import 'package:g2g/screens/during_session/my_repetition_screen.dart';

class MyExercices extends StatelessWidget {
  const MyExercices({super.key, required this.session});
  final Session session;

  @override
  Widget build(BuildContext context) {
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
                  return Row(
                    children: [
                      Image(
                          image: NetworkImage(exoBase.data!.img ??
                              "https://cdn-icons-png.flaticon.com/512/1053/1053916.png")),
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
                });
          },
        ));
  }
}
