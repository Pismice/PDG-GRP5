import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_session.dart';
import 'package:g2g/api/firebase_workout.dart';
import 'package:g2g/model/workout.dart';
import 'package:g2g/screens/gestion/modification/editworkout.dart';

class MyWorkoutInfoPage extends StatefulWidget {
  final Workout workout;
  const MyWorkoutInfoPage({required this.workout, Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyWorkoutInfoPage createState() => _MyWorkoutInfoPage();
}

class _MyWorkoutInfoPage extends State<MyWorkoutInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.workout.name!),
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.workout.sessions!.length,
              itemBuilder: (context, index) {
                return ElevatedButton(
                  onPressed: () {},
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FutureBuilder(
                        future: getSession(widget.workout.sessions![index].id!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Text("Error : ${snapshot.error.toString()}");
                          }
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            return Text(snapshot.data!.name!);
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Row(children: [
            Expanded(
                child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyEditWorkoutPage(workout: widget.workout)));
                    },
                    icon: const Icon(Icons.edit))),
            Expanded(
                child: IconButton(
                    onPressed: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Suppréssion du workout'),
                          content: const Text(
                              'Êtes-vous certain de vouloir supprimer ce workout ?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Annuler'),
                            ),
                            TextButton(
                              onPressed: () {
                                deleteWorkout(widget.workout.uid!);
                                Navigator.pop(context, 'OK');
                              },
                              child: const Text('Supprimer'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete))),
            if (widget.workout.isActive())
              ElevatedButton(
                  onPressed: () async {
                    await widget.workout.setInactive();
                  },
                  child: const Text("Stop this workout")),
          ])
        ]));
  }
}
