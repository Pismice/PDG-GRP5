import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_session.dart';
import 'package:g2g/api/firebase_workout.dart';
import 'package:g2g/model/workout.dart';
import 'package:g2g/screens/gestion/creation/addnew/addnewseance.dart';

//const double _kItemExtent = 32.0;

class MyEditWorkoutPage extends StatefulWidget {
  final Workout workout;
  const MyEditWorkoutPage({required this.workout, Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyEditWorkoutPage createState() => _MyEditWorkoutPage();
}

class _MyEditWorkoutPage extends State<MyEditWorkoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Modification de ${widget.workout.name}"),
        ),
        body: Column(children: <Widget>[
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Rename workout",
                ),
                onChanged: (text) {
                  widget.workout.name = text;
                },
              )),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText:
                      'Number of week (actual : ${widget.workout.duration})',
                ),
                keyboardType: TextInputType.number,
                onChanged: (text) {
                  widget.workout.duration = int.parse(text);
                },
              )),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText:
                      'Start week of the workout (actual : ${widget.workout.week})',
                ),
                keyboardType: TextInputType.number,
                onChanged: (text) {
                  widget.workout.week = int.parse(text);
                },
              )),
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.workout.sessions!.length,
            itemBuilder: (context, index) {
              return ElevatedButton(
                  onPressed: () {},
                  child: FutureBuilder(
                    future: getSession(widget.workout.sessions![index].id!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Text("Error : ${snapshot.error.toString()}");
                      }
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return Container(
                          padding: const EdgeInsets.all(20),
                          child: Row(children: [
                            Expanded(child: Text(snapshot.data!.name!)),
                            Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: IconButton(
                                    onPressed: () {
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: const Text('Remove session'),
                                          content: const Text(
                                              'Are you sure you want to remove this session from the workout ?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  context, 'Cancel'),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                deleteSessionFromWorkout(
                                                    widget.workout.uid!,
                                                    snapshot.data!.uid!);
                                                Navigator.pop(context, 'OK');
                                              },
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.delete)))
                          ]),
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ));
            },
          ),
          Row(children: [
            Expanded(
                child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyAddNewSeance(workout: widget.workout)));
                    },
                    icon: const Icon(Icons.add))),
            Expanded(
                child: Container(
                    color: Colors.green[200],
                    child: IconButton(
                        onPressed: () {
                          updateWorkout(widget.workout);
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.check)))),
            Expanded(
                child: IconButton(
                    onPressed: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Delete workout'),
                          content: const Text(
                              'Are you sure that you want to delete this workout ?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                deleteWorkout(widget.workout.uid!);
                                Navigator.pop(context, 'OK');
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete)))
          ])
        ]));
  }
}
