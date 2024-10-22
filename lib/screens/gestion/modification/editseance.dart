import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:g2g/api/firebase_exercise.dart';
import 'package:g2g/api/firebase_session.dart';
import 'package:g2g/model/exercise.dart';
import 'package:g2g/model/session.dart';
import 'package:g2g/screens/gestion/creation/addnew/addnewexercise.dart';

const double _kItemExtent = 32.0;

class MyEditSeancePage extends StatefulWidget {
  final Session session;
  const MyEditSeancePage(this.session, {Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyEditSeancePage createState() => _MyEditSeancePage();
}

class _MyEditSeancePage extends State<MyEditSeancePage> {
  Widget _displaySet(Exercise ex) {
    for (var sessEx in widget.session.exercises!) {
      if (sessEx.id != ex.uid) continue;
      List<Widget> children = [];
      switch (ex.type) {
        case "TIME":
          children.addAll([
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => _showDialog(
                CupertinoPicker(
                  itemExtent: _kItemExtent,
                  // This sets the initial item.
                  scrollController: FixedExtentScrollController(
                    initialItem: sessEx.set!,
                  ),
                  // This is called when selected item is changed.
                  onSelectedItemChanged: (int selectedItem) {
                    setState(
                      () {
                        sessEx.set = selectedItem;
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
              child: Text(
                '${sessEx.set}',
              ),
            ),
            const Text(' X '),
            CupertinoButton(
              padding: EdgeInsets.zero,
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
              child: Text(
                '${sessEx.duration}',
              ),
            ),
            const Text(' sec'),
          ]);
          break;
        case "WEIGHT":
          children.addAll([
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => _showDialog(
                CupertinoPicker(
                  itemExtent: _kItemExtent,
                  scrollController: FixedExtentScrollController(
                    initialItem: sessEx.repetition!,
                  ),
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
              const Text('sets'),
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
              const Text("reps"),
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
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.session.name}"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Rename the session',
              ),
              onChanged: (value) => widget.session.name = value,
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.session.exercises!.length,
              itemBuilder: (context, index) {
                final data = widget.session.exercises![index];
                return FutureBuilder(
                  future: getExercise(data.id!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    }
                    final exercise = snapshot.data!;
                    return ElevatedButton(
                      onPressed: () {},
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: FutureBuilder(
                                    future: FirebaseStorage.instance
                                        .refFromURL(
                                            'gs://hongym-4cb68.appspot.com')
                                        .child("img/exercises/${exercise.img}")
                                        .getDownloadURL(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Container();
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
                            ),
                            Expanded(child: Text(exercise.name!)),
                            _displaySet(exercise),
                            IconButton(
                              onPressed: () {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('Delete session'),
                                    content: const Text(
                                        'Are your sure that you want to remove this exercise from the session ?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            deleteExerciseFromSession(
                                                widget.session,
                                                widget
                                                    .session.exercises![index]);
                                          });
                                          Navigator.pop(context, 'OK');
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
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
                            MyAddNewExercise(session: widget.session),
                        maintainState: false,
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.green[200],
                  child: IconButton(
                    onPressed: () {
                      updateSession(widget.session);
                      Navigator.pop(context);
                      setState(() {
                        widget.session.name = widget.session.name;
                      });
                    },
                    icon: const Icon(Icons.check),
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Delete session'),
                        content: const Text(
                            'Are you sure that you want to delete the session ?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              deleteSession(widget.session.uid!);
                              Navigator.pop(context, 'OK');
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
