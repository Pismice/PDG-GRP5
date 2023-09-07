import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:g2g/api/firebase_exercise.dart';
import 'package:g2g/api/firebase_session.dart';
import 'package:g2g/api/firebase_user.dart';
import 'package:g2g/model/exercise.dart';
import 'package:g2g/model/session.dart';
import 'package:g2g/screens/gestion/creation/addnew/addnewexercise.dart';

const double _kItemExtent = 32.0;

class MyCreateSeance extends StatefulWidget {
  const MyCreateSeance({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyCreateSeance createState() => _MyCreateSeance();
}

class _MyCreateSeance extends State<MyCreateSeance> {
  final Session session = Session();

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

  Widget _displaySet(Exercise ex) {
    for (var sessEx in session.exercises!) {
      if (sessEx.id != ex.uid) continue;
      List<Widget> children = [];
      switch (ex.type) {
        case "TIME":
          children.addAll([
            CupertinoButton(
              padding: EdgeInsets.zero,
              // Display a CupertinoPicker with list of fruits.
              onPressed: () => _showDialog(
                CupertinoPicker(
                  itemExtent: _kItemExtent,
                  // This sets the initial item.
                  scrollController: FixedExtentScrollController(
                    initialItem: sessEx.duration!,
                  ),
                  // This is called when selected item is changed.
                  onSelectedItemChanged: (int selectedItem) {
                    setState(
                      () {
                        sessEx.duration = selectedItem;
                      },
                    );
                  },
                  children: List<Widget>.generate(
                    600,
                    (int index) {
                      return Center(child: Text('$index'));
                    },
                  ),
                ),
              ),
              // This displays the selected fruit name.
              child: Text(
                '${sessEx.weight}',
              ),
            ),
            const Text(' kg'),
          ]);
          break;
        case "WEIGHT":
          children.addAll([
            CupertinoButton(
              padding: EdgeInsets.zero,
              // Display a CupertinoPicker with list of fruits.
              onPressed: () => _showDialog(
                CupertinoPicker(
                  itemExtent: _kItemExtent,
                  // This sets the initial item.
                  scrollController: FixedExtentScrollController(
                    initialItem: sessEx.repetition!,
                  ),
                  // This is called when selected item is changed.
                  onSelectedItemChanged: (int selectedItem) {
                    setState(() {
                      sessEx.weight = selectedItem;
                    });
                  },
                  children: List<Widget>.generate(150, (int index) {
                    return Center(child: Text('$index'));
                  }),
                ),
              ),
              // This displays the selected fruit name.
              child: Text(
                '${sessEx.weight}',
              ),
            ),
            const Text(' kg'),
          ]);
          continue rest;
        rest:
        default:
          children.addAll(
            [
              CupertinoButton(
                  padding: EdgeInsets.zero,
                  // Display a CupertinoPicker with list of fruits.
                  onPressed: () => _showDialog(
                        CupertinoPicker(
                          itemExtent: _kItemExtent,
                          // This sets the initial item.
                          scrollController: FixedExtentScrollController(
                            initialItem: sessEx.repetition!,
                          ),
                          // This is called when selected item is changed.
                          onSelectedItemChanged: (int selectedItem) {
                            setState(() {
                              sessEx.repetition = selectedItem;
                            });
                          },
                          children: List<Widget>.generate(50, (int index) {
                            return Center(child: Text('$index'));
                          }),
                        ),
                      ),
                  // This displays the selected fruit name.
                  child: Text(
                    '${sessEx.repetition}',
                  )),
              const Text(' X '),
              CupertinoButton(
                padding: EdgeInsets.zero,
                // Display a CupertinoPicker with list of fruits.
                onPressed: () => _showDialog(
                  CupertinoPicker(
                    itemExtent: _kItemExtent,
                    // This sets the initial item.
                    scrollController: FixedExtentScrollController(
                      initialItem: sessEx.set!,
                    ),
                    // This is called when selected item is changed.
                    onSelectedItemChanged: (int selectedItem) {
                      setState(() {
                        sessEx.set = selectedItem;
                      });
                    },
                    children: List<Widget>.generate(50, (int index) {
                      return Center(child: Text('$index'));
                    }),
                  ),
                ),
                // This displays the selected fruit name.
                child: Text(
                  '${sessEx.set}',
                ),
              ),
            ],
          );
          break;
      }
      return Row(
        children: children,
      );
    }
    return const Text("");
  }

  @override
  Widget build(BuildContext context) {
    session.exercises = [];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nouvelle séance"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nom de la séance',
              ),
              onChanged: (value) => session.name = value,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: session.exercises!.length,
            itemBuilder: (context, index) {
              return FutureBuilder(
                future: getExercise(session.exercises![index].id!),
                builder: (context, snapshot) {
                  final exercise = snapshot.data!;
                  return ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      overlayColor:
                          MaterialStateProperty.all(Colors.grey.shade100),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FutureBuilder(
                                future: FirebaseStorage.instance
                                    .refFromURL('gs://hongym-4cb68.appspot.com')
                                    .child("img/exercises/${exercise.img}")
                                    .getDownloadURL(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }
                                  return Image.network(
                                    snapshot.data.toString(),
                                    height: 100,
                                    width: 100,
                                  );
                                },
                              ),
                            ),
                          ),
                          Expanded(child: Text(exercise.name!)),
                          _displaySet(exercise),
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.delete),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          Row(
            children: [
              Expanded(
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MyAddNewExercise(session: session),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: getUser(FirebaseAuth.instance.currentUser!.uid),
                  builder: (context, snapshot) {
                    return Container(
                      color: Colors.green[200],
                      child: IconButton(
                        onPressed: () {
                          session.user = snapshot.data?.uid;
                          addSession(session);
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.check),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
