import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

const double _kItemExtent = 32.0;

class MyCreateSeance extends StatefulWidget {
  const MyCreateSeance({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyCreateSeance createState() => _MyCreateSeance();
}

class _MyCreateSeance extends State<MyCreateSeance> {
  final items = List<String>.generate(0, (i) => "Exo $i");
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
          title: const Text("Séance X"),
        ),
        body: Column(children: <Widget>[
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                  decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Rename Seance',
              ))),
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
                      const Text(' X '),
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
                      Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: IconButton(
                              onPressed: () {}, icon: const Icon(Icons.delete)))
                    ]),
                  ));
            },
          ),
          Expanded(
              child: IconButton(onPressed: () {}, icon: const Icon(Icons.add))),
        ]));
  }
}
