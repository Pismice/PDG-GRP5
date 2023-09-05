import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

const double _kItemExtent = 32.0;

class MyEditWorkoutPage extends StatefulWidget {
  const MyEditWorkoutPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyEditWorkoutPage createState() => _MyEditWorkoutPage();
}

class _MyEditWorkoutPage extends State<MyEditWorkoutPage> {
  final items = List<String>.generate(4, (i) => "Seance $i");
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
          title: const Text("Workout X"),
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
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      overlayColor:
                          MaterialStateProperty.all(Colors.grey.shade100)),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(children: [
                      Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Image.asset(
                                'assets/images/cervin.jpg',
                                height: 75,
                                width: 75,
                              ))),
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
                child:
                    IconButton(onPressed: () {}, icon: const Icon(Icons.add))),
            Expanded(
                child: Container(
                    color: Colors.green[200],
                    child: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.check)))),
            Expanded(
                child: IconButton(
                    onPressed: () {}, icon: const Icon(Icons.delete)))
          ])
        ]));
  }
}
