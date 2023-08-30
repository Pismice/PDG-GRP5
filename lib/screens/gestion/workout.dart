import 'package:flutter/material.dart';

void main() => runApp(MyWorkoutScreen());

class MyWorkoutScreen extends StatefulWidget {
  MyWorkoutScreen({Key? key}) : super(key: key);

  @override
  _MyWorkoutScreen createState() => _MyWorkoutScreen();
}

class _MyWorkoutScreen extends State<MyWorkoutScreen> {
  TextEditingController editingController = TextEditingController();

  final duplicateItems = List<String>.generate(10000, (i) => "Programme $i");
  var items = <String>[];

  @override
  void initState() {
    items = duplicateItems;
    super.initState();
  }

  void filterSearchResults(String query) {
    setState(() {
      items = duplicateItems
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(children: <Widget>[
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextField(
              onChanged: (value) {
                filterSearchResults(value);
              },
              controller: editingController,
              decoration: const InputDecoration(
                  labelText: "Recherche",
                  hintText: "Mon Workout",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
            ),
          )),
          Padding(
              padding: const EdgeInsets.only(right: 0),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    color: Colors.black,
                    onPressed: () {},
                  ))),
        ]),
        Expanded(
          child: ListView.builder(
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
                  child: Column(children: <Widget>[
                    Row(children: <Widget>[
                      Expanded(child: Text('${items[index]}')),
                      Align(
                          alignment: Alignment.topCenter,
                          child: IconButton(
                            icon: const Icon(Icons.edit),
                            color: Colors.black,
                            onPressed: () {},
                          )),
                    ]),
                    Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        child: Row(children: <Widget>[
                          const Icon(Icons.repeat),
                          Expanded(child: Text('${index + 1} Semaine')),
                          Align(
                              alignment: Alignment.topCenter,
                              child: Text('${index * 2} entrainements'))
                        ]))
                  ]));
            },
          ),
        ),
      ],
    );
  }
}
