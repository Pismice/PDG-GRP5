import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:g2g/api/firebase_exercise.dart';
import 'package:g2g/model/exercise.dart';
import 'package:g2g/screens/gestion/exercice.dart';

const double _kItemExtent = 32.0;

class MyEditExoPage extends StatefulWidget {
  const MyEditExoPage({Key? key, required this.exo}) : super(key: key);

  final Exercise exo;
  @override
  // ignore: library_private_types_in_public_api
  _MyEditExoPage createState() => _MyEditExoPage();
}

class _MyEditExoPage extends State<MyEditExoPage> {
  var _selectedNumber = 0;

  int _giveExoItem(Exercise e) {
    if (e.type == "WEIGHT") {
      return 0;
    }
    if (e.type == "TIME") {
      return 1;
    } else {
      return 2;
    }
  }

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
    Exercise ex = widget.exo;
    _selectedNumber = _giveExoItem(ex);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.exo.name!),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                    alignment: Alignment.centerLeft,
                    child: FutureBuilder(
                      future: FirebaseStorage.instance
                          .refFromURL('gs://hongym-4cb68.appspot.com')
                          .child("img/exercises/${widget.exo.img}")
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
                    )),
                /*ElevatedButton(
                    onPressed: () {},
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.grey)),
                    child: const Text("change photo")),*/
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    onChanged: (value) {
                      ex.name = value;
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: widget.exo.name,
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
                                initialItem: _giveExoItem(widget.exo),
                              ),
                              // This is called when selected item is changed.
                              onSelectedItemChanged: (int selectedItem) {
                                setState(() {
                                  _selectedNumber = selectedItem;
                                  ex.type = _giveUpdateType(_selectedNumber);
                                });
                              },
                              children: list),
                        ),
                    // This displays the selected fruit name.
                    child: list[_selectedNumber]),
                Container(
                    color: Colors.green[200],
                    child: IconButton(
                        onPressed: () {
                          updateExercise(ex);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MyExerciceScreen()));
                        },
                        icon: const Icon(Icons.check)))
              ],
            )));
  }
}
