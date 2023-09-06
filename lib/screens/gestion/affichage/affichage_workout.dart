import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_session.dart';
import 'package:g2g/api/firebase_workout.dart';
import 'package:g2g/screens/gestion/affichage/affichage_seance.dart';
import 'package:g2g/screens/gestion/modification/editworkout.dart';

class MyWorkoutInfoPage extends StatefulWidget {
  final String id;
  const MyWorkoutInfoPage(this.id, {Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyWorkoutInfoPage createState() => _MyWorkoutInfoPage();
}

class _MyWorkoutInfoPage extends State<MyWorkoutInfoPage> {
  @override
  Widget build(BuildContext context) {
    final items = getWorkout(widget.id);
    return FutureBuilder(
      future: items,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text("Error : ${snapshot.error.toString()}");
        }
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Scaffold(
              appBar: AppBar(
                title: Text(snapshot.data!.name as String),
              ),
              body: Column(children: <Widget>[
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.sessions!.length,
                  itemBuilder: (context, index) {
                    return ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MySeanceInfoPage()),
                          );
                        },
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all(Colors.black),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            overlayColor: MaterialStateProperty.all(
                                Colors.grey.shade100)),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: FutureBuilder(
                                future: getSession(snapshot
                                    .data!.sessions![index].id as String),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }
                                  if (snapshot.hasError) {
                                    return Text(
                                        "Error : ${snapshot.error.toString()}");
                                  }
                                  if (snapshot.connectionState ==
                                          ConnectionState.done &&
                                      snapshot.hasData) {
                                    return Text(snapshot.data!.name as String);
                                  }
                                  return const CircularProgressIndicator();
                                },
                              )),
                        ));
                  },
                ),
                Row(children: [
                  Expanded(
                      child: IconButton(
                          onPressed: () {}, icon: const Icon(Icons.add))),
                  Expanded(
                      child: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MyEditWorkoutPage(widget.id)));
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
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Annuler'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      deleteWorkout(widget.id);
                                      Navigator.pop(context, 'OK');
                                    },
                                    child: const Text('Supprimer'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete)))
                ])
              ]));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
