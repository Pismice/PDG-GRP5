import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_exercise.dart';
import 'package:g2g/model/exercise.dart';
import 'package:g2g/api/firebase_user.dart';
import 'package:g2g/screens/gestion_screen.dart';

const double _kItemExtent = 32.0;

class MyCreateExercice extends StatefulWidget {
  const MyCreateExercice({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyCreateExercice createState() => _MyCreateExercice();
}

class _MyCreateExercice extends State<MyCreateExercice> {
  String name = "Exercice";
  var _selectedNumber = 0;

  String _giveUpdateType(int i) {
    if (i == 1) {
      return "TIME";
    }
    if (i == 2) {
      return "REP";
    } else {
      return "WEIGHT";
    }
  }

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

  final List<Widget> list = <Widget>[
    const Icon(Icons.fitness_center),
    const Icon(Icons.timer),
    const Icon(Icons.replay)
  ];

  @override
  Widget build(BuildContext context) {
    /*Future<User> user = getUser(FirebaseAuth.instance.currentUser!.uid);*/
    return Scaffold(
        appBar: AppBar(title: const Text("New exercices")),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ElevatedButton(
                    onPressed: () {},
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.grey)),
                    child: const Text("add photo")),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    onChanged: (value) {
                      name = value;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Nom exercice',
                    ),
                  ),
                ),
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
                              children: list),
                        ),
                    // This displays the selected fruit name.
                    child: list[_selectedNumber]),
                Container(
                    color: Colors.green[200],
                    child: IconButton(
                        onPressed: () async {
                          Navigator.pop(
                              context /*,
                              MaterialPageRoute(
                                  builder: (context) => const GestionScreen()))*/
                              );
                          if (name != "Exercice") {
                            addExercise(Exercise(
                                name: name,
                                img: "default.png",
                                type: _giveUpdateType(_selectedNumber),
                                user: await getUser(
                                        FirebaseAuth.instance.currentUser!.uid)
                                    .then((value) => value.uid)));
                          }
                        },
                        icon: const Icon(Icons.check)))
              ],
            )));
  }
}
