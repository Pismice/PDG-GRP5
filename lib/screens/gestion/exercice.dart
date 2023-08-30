import 'package:flutter/material.dart';

void main() => runApp(const MyExerciceScreen());

class MyExerciceScreen extends StatefulWidget {
  const MyExerciceScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyExerciceScreen createState() => _MyExerciceScreen();
}

class _MyExerciceScreen extends State<MyExerciceScreen> {
  TextEditingController editingController = TextEditingController();

  final duplicateItems = List<String>.generate(10000, (i) => "Séance $i");
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
                      Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Image.asset(
                                'assets/images/cervin.jpg',
                                height: 75,
                                width: 75,
                              ))),
                      Expanded(child: Text('Nom exo $index')),
                      Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.edit),
                            padding: const EdgeInsets.all(0),
                            color: Colors.black,
                            onPressed: () {},
                          )),
                    ]),
                  ]));
            },
          ),
        ),
      ],
    );
  }
}
