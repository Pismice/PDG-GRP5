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
        future: getWorkout(widget.id!),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text("Error : ${snapshot.error.toString()}");
          }
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            var selectedNumber = snapshot.data!.duration!;
            var name = snapshot.data!.name!;
            return Scaffold(
                appBar: AppBar(
                  title: const Text("Modification de "),
                ),
                body: Column(children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextField(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: name,
                        ),
                        onChanged: (text) {
                          name = text;
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
                                  initialItem: selectedNumber,
                                ),
                                // This is called when selected item is changed.
                                onSelectedItemChanged: (int selectedItem) {
                                  setState(() {
                                    selectedNumber = selectedItem;
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
                          '$selectedNumber',
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
                            future:
                                getSession(snapshot.data!.sessions![index].id!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
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
                                    Expanded(child: Text(snapshot.data!.name!)),
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
                                          MyAddNewSeance(id: widget.id)));
                            },
                            icon: const Icon(Icons.add))),
                    Expanded(
                        child: Container(
                            color: Colors.green[200],
                            child: IconButton(
                                onPressed: () {
                                  //acceptChanges();
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.check)))),
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
                                        deleteWorkout(widget.id!);
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
        }));
  }

  // Future<void> acceptChanges() async {
  //   final w = await getWorkout(widget.id!);
  //   if (w.name != _name) {
  //     w.name = _name;
  //   }
  //   if (w.duration != _selectedNumber) {
  //     w.duration = _selectedNumber;
  //   }
  //   updateWorkout(w);
  // }
}
