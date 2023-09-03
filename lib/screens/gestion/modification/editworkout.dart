import 'package:flutter/material.dart';

class MyEditWorkoutPage extends StatefulWidget {
  const MyEditWorkoutPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyEditWorkoutPage createState() => _MyEditWorkoutPage();
}

class _MyEditWorkoutPage extends State<MyEditWorkoutPage> {
  final items = List<String>.generate(4, (i) => "Seance $i");

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
                child: IconButton(
                    onPressed: () {}, icon: const Icon(Icons.delete)))
          ])
        ]));
  }
}
