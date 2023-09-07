import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:g2g/screens/gestion/creation/addnew/addnewseance.dart';

const double _kItemExtent = 32.0;

class MyCreateWorkout extends StatefulWidget {
  const MyCreateWorkout({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyCreateWorkout createState() => _MyCreateWorkout();
}

class _MyCreateWorkout extends State<MyCreateWorkout> {
  var items = <String>[];
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
    return Scaffold(
        appBar: AppBar(
          title: const Text("Création d'un workout"),
        ),
        body: Column(children: <Widget>[
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                  decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nom Workout',
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
                        children: List<Widget>.generate(50, (int index) {
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
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ElevatedButton(
                  onPressed: () {},
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(children: [
                      Expanded(child: Text(items[index])),
                      Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: IconButton(
                              onPressed: () {}, icon: const Icon(Icons.delete)))
                    ]),
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
                              builder: (context) => const MyAddNewSeance()));
                    },
                    icon: const Icon(Icons.add))),
            Expanded(
                child: Container(
                    color: Colors.green[200],
                    child: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.check))))
          ]),
        ]));
  }
}
