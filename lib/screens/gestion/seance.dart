import 'package:flutter/material.dart';
import 'package:g2g/screens/gestion/affichage/affichage_seance.dart';

void main() => runApp(const MySessionScreen());

class MySessionScreen extends StatefulWidget {
  const MySessionScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MySessionPageState createState() => _MySessionPageState();
}

class _MySessionPageState extends State<MySessionScreen> {
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MySeanceInfoPage()),
                    );
                  },
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      overlayColor:
                          MaterialStateProperty.all(Colors.grey.shade100)),
                  child: Column(children: <Widget>[
                    Row(children: <Widget>[
                      Expanded(child: Text(items[index])),
                      Expanded(child: Text('$index exercices')),
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
