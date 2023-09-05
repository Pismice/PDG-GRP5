import 'package:flutter/material.dart';
import 'package:g2g/screens/gestion/creation/create_exercise.dart';

void main() => runApp(const MyAddNewExercise());

class MyAddNewExercise extends StatefulWidget {
  const MyAddNewExercise({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyAddNewExercise createState() => _MyAddNewExercise();
}

class _MyAddNewExercise extends State<MyAddNewExercise> {
  TextEditingController editingController = TextEditingController();

  final duplicateItems = List<String>.generate(100, (i) => "Exo $i");
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
    return Scaffold(
        appBar: AppBar(
          title: const Text("Séance X"),
        ),
        body: Column(
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
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0)))),
                ),
              )),
              Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: IconButton(
                        icon: const Icon(Icons.add),
                        color: Colors.black,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MyCreateExercice()));
                        },
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
                          foregroundColor:
                              MaterialStateProperty.all(Colors.black),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          overlayColor:
                              MaterialStateProperty.all(Colors.grey.shade100)),
                      child: Column(children: <Widget>[
                        Row(children: <Widget>[
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
                        ]),
                      ]));
                },
              ),
            ),
          ],
        ));
  }
}
