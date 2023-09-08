import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_session.dart';
import 'package:g2g/api/firebase_workout.dart';
import 'package:g2g/model/session.dart';
import 'package:g2g/model/workout.dart';
//import 'package:g2g/screens/gestion/creation/create_exercise.dart';

/// Widget qui ajoute une ou plusieur séance à un workout [workout] lors de sa création
class MyAddNewSeance extends StatefulWidget {
  final Workout workout;
  const MyAddNewSeance({required this.workout, Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyEditSeancePage createState() => _MyEditSeancePage();
}

class _MyEditSeancePage extends State<MyAddNewSeance> {
  List<Session> itemslist = <Session>[];

  @override
  Widget build(BuildContext context) {
    // liste des séances
    return FutureBuilder(
        future: getAllSessionsFrom(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          if (snapshot.hasError) {
            return Text("Error : ${snapshot.error.toString()}");
          }
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            var items = snapshot.data!;
            return Scaffold(
                appBar: AppBar(
                  title: const Text("Add session to workout"),
                ),
                // info de séance
                body: Column(children: <Widget>[
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      if (widget.workout
                              .findWorkoutSessionById(items[index].uid!) !=
                          null) return Container();
                      return ElevatedButton(
                          onPressed: () {},
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: Row(children: [
                              Expanded(child: Text(items[index].name!)),
                              Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: IconButton(
                                      onPressed: () {
                                        addSessionToWorkout(
                                            widget.workout, items[index].uid!);
                                      },
                                      icon: const Icon(Icons.add)))
                            ]),
                          ));
                    },
                  ),
                  // bouton de validation
                  Row(children: [
                    Expanded(child: Container()),
                    Expanded(
                        child: Container(
                            color: Colors.green[200],
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.check)))),
                  ])
                ]));
          }
          return Container();
        });
  }
}
