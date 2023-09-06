import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:g2g/api/firebase_session.dart';
import 'package:g2g/api/firebase_workout.dart';
import 'package:g2g/screens/gestion/creation/addnew/addnewseance.dart';

const double _kItemExtent = 32.0;

class MyEditWorkoutPage extends StatefulWidget {
  final String? id;
  const MyEditWorkoutPage(this.id, {Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyEditWorkoutPage createState() => _MyEditWorkoutPage();
}

class _MyEditWorkoutPage extends State<MyEditWorkoutPage> {
  var _selectedNumber = 1;

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
    return FutureBuilder(
        future: getWorkout(widget.id as String),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text("Error : ${snapshot.error.toString()}");
          }
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            _selectedNumber = snapshot.data!.duration!;
            return Scaffold(
                appBar: AppBar(
                  title: Text(snapshot.data!.name as String),
                ),
                body: Column(children: <Widget>[
                  const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: TextField(
                          decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Rename Workout',
                      ))),
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
                                  initialItem: _selectedNumber,
                                ),
                                // This is called when selected item is changed.
                                onSelectedItemChanged: (int selectedItem) {
                                  setState(() {
                                    _selectedNumber = selectedItem;
                                  });
                                },
                                children:
                                    List<Widget>.generate(50, (int index) {
                                  return Center(child: Text('$index'));
                                }),
                              ),
                            ),
                        // This displays the selected fruit name.
                        child: Text(
                          '$_selectedNumber',
                        )),
                  ]),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.sessions!.length,
                    itemBuilder: (context, index) {
                      return ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.black),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              overlayColor: MaterialStateProperty.all(
                                  Colors.grey.shade100)),
                          child: FutureBuilder(
                            future: getSession(
                                snapshot.data!.sessions![index].id as String),
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
                                return Container(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(children: [
                                    Expanded(
                                        child: Text(
                                            snapshot.data!.name as String)),
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(left: 30),
                                        child: IconButton(
                                            onPressed: () {
                                              showDialog<String>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                  title: const Text(
                                                      'Suppréssion de séance dans un workout'),
                                                  content: const Text(
                                                      'Êtes-vous certain de vouloir supprimer cette séance de ce workout ?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(context,
                                                              'Cancel'),
                                                      child:
                                                          const Text('Annuler'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        deleteSessionFromWorkout(
                                                            widget.id!,
                                                            snapshot
                                                                .data!.uid!);
                                                        Navigator.pop(
                                                            context, 'OK');
                                                      },
                                                      child: const Text(
                                                          'Supprimer'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            icon: const Icon(Icons.delete)))
                                  ]),
                                );
                              }
                              return const Center(
                                  child: CircularProgressIndicator());
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
                                          const MyAddNewSeance()));
                            },
                            icon: const Icon(Icons.add))),
                    Expanded(
                        child: Container(
                            color: Colors.green[200],
                            child: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.check)))),
                    Expanded(
                        child: IconButton(
                            onPressed: () {}, icon: const Icon(Icons.delete)))
                  ])
                ]));
          }
          return const Center(child: CircularProgressIndicator());
        }));
  }
}
