import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:g2g/api/firebase_session.dart';
import 'package:g2g/api/firebase_workout.dart';
import 'package:g2g/model/workout.dart';
import 'package:g2g/screens/gestion/creation/addnew/addnewseance.dart';

const double _kItemExtent = 32.0;

class MyCreateWorkout extends StatefulWidget {
  const MyCreateWorkout({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyCreateWorkout createState() => _MyCreateWorkout();
}

class _MyCreateWorkout extends State<MyCreateWorkout> {
  Workout w = Workout();
  bool workoutCreated = false;

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!workoutCreated) {
      w.duration = 1;
      w.name = "during creation";
      w.sessions = <WorkoutSessions>[];
      w.week = weekNumber(DateTime.now());
      workoutCreated = true;
    }
    if (w.sessions == null) {
      return Scaffold(
          appBar: AppBar(
            title: const Text("Création d'un workout"),
          ),
          body: Column(children: <Widget>[
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Nom Workout',
                  ),
                  onChanged: (String text) {
                    w.name = text;
                  },
                )),
            Row(children: [
              const Text('Nombre de semaine'),
              CupertinoButton(
                  padding: EdgeInsets.zero,
                  // Display a CupertinoPicker with list of fruits.
                  onPressed: () => _showDialog(
                        CupertinoPicker(
                          itemExtent: _kItemExtent,
                          // This sets the initial item.
                          scrollController: FixedExtentScrollController(
                            initialItem: w.duration!,
                          ),
                          // This is called when selected item is changed.
                          onSelectedItemChanged: (int selectedItem) {
                            setState(() {
                              w.duration = selectedItem;
                            });
                          },
                          children: List<Widget>.generate(50, (int index) {
                            return Center(child: Text('$index'));
                          }),
                        ),
                      ),
                  // This displays the selected fruit name.
                  child: Text(
                    '${w.duration}',
                  )),
            ]),
            const Center(child: Text("Pas de séance dans ce workout")),
            Row(children: [
              Expanded(
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MyAddNewSeance(workout: w)));
                      },
                      icon: const Icon(Icons.add))),
              Expanded(
                  child: Container(
                      color: Colors.green[200],
                      child: IconButton(
                          onPressed: () async {
                            await addWorkout(w);
                            if (context.mounted) Navigator.pop(context);
                          },
                          icon: const Icon(Icons.check))))
            ]),
          ]));
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text("Création d'un workout"),
        ),
        body: Column(children: <Widget>[
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Nom Workout',
                ),
                onChanged: (String text) {
                  w.name = text;
                },
              )),
          Row(children: [
            const Text('Nombre de semaine'),
            CupertinoButton(
                padding: EdgeInsets.zero,
                // Display a CupertinoPicker with list of fruits.
                onPressed: () => _showDialog(
                      CupertinoPicker(
                        itemExtent: _kItemExtent,
                        // This sets the initial item.
                        scrollController: FixedExtentScrollController(
                          initialItem: w.duration!,
                        ),
                        // This is called when selected item is changed.
                        onSelectedItemChanged: (int selectedItem) {
                          setState(() {
                            w.duration = selectedItem;
                          });
                        },
                        children: List<Widget>.generate(50, (int index) {
                          return Center(child: Text('$index'));
                        }),
                      ),
                    ),
                // This displays the selected fruit name.
                child: Text(
                  '${w.duration}',
                )),
          ]),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Number of week (actual : ${w.week})',
                ),
                keyboardType: TextInputType.number,
                onChanged: (weekText) {
                  w.week = int.parse(weekText);
                },
              )),
          ListView.builder(
            shrinkWrap: true,
            itemCount: w.sessions!.length,
            itemBuilder: (context, index) {
              return ElevatedButton(
                  onPressed: () {},
                  child: Container(
                      padding: const EdgeInsets.all(20),
                      child: FutureBuilder(
                          future: getSession(w.sessions![index].id!),
                          builder: (futureContext, sessionSnapshot) {
                            if (sessionSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (sessionSnapshot.hasError) {
                              return Center(
                                  child: Text(
                                      "Someting went wrong : ${sessionSnapshot.error}"));
                            }
                            if (sessionSnapshot.connectionState ==
                                    ConnectionState.done &&
                                sessionSnapshot.hasData) {
                              return Row(children: [
                                Padding(
                                    padding: const EdgeInsets.only(left: 30),
                                    child: IconButton(
                                        onPressed: () {
                                          AlertDialog(
                                            title: const Text(
                                                'Suppréssion de séance dans un workout'),
                                            content: const Text(
                                                'Êtes-vous certain de vouloir supprimer cette séance de ce workout ?'),
                                            actions: <Widget>[
                                              Expanded(
                                                  child: Text(sessionSnapshot
                                                      .data!.name!)),
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, 'Cancel'),
                                                child: const Text('Annuler'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  w.sessions!.remove(
                                                      w.sessions![index]);
                                                  Navigator.pop(context, 'OK');
                                                },
                                                child: const Text('Supprimer'),
                                              ),
                                            ],
                                          );
                                        },
                                        icon: const Icon(Icons.delete)))
                              ]);
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          })));
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
                                  MyAddNewSeance(workout: w)));
                    },
                    icon: const Icon(Icons.add))),
            Expanded(
                child: Container(
                    color: Colors.green[200],
                    child: IconButton(
                        onPressed: () {
                          addWorkout(w);
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.check))))
          ]),
        ]));
  }
}
