import 'package:flutter/material.dart';
import 'package:g2g/screens/gestion/affichage/affichage_seance.dart';

/*void main() {
  runApp(//MaterialApp(
    //title: 'Workout Info',
    //theme: ThemeData(primarySwatch: Colors.blue),
    /*home: */const MyWorkoutInfoPage(),
  ));
}*/

class MyWorkoutInfoPage extends StatefulWidget {
  const MyWorkoutInfoPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyWorkoutInfoPage createState() => _MyWorkoutInfoPage();
}

class _MyWorkoutInfoPage extends State<MyWorkoutInfoPage> {
  final items = List<String>.generate(4, (i) => "Séance $i");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Workout X"),
        ),
        body: Column(children: <Widget>[
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
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(items[index])),
                  ));
            },
          ),
          Row(children: [
            Expanded(
                child:
                    IconButton(onPressed: () {}, icon: const Icon(Icons.add))),
            Expanded(
                child:
                    IconButton(onPressed: () {}, icon: const Icon(Icons.edit))),
            Expanded(
                child: IconButton(
                    onPressed: () {}, icon: const Icon(Icons.delete)))
          ])
        ]));
  }
}
