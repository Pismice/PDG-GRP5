import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_session.dart';
import 'package:g2g/api/firebase_workout.dart';
//import 'package:g2g/screens/gestion/creation/create_exercise.dart';

class MyAddNewSeance extends StatefulWidget {
  final String? id;
  const MyAddNewSeance({this.id, Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyEditSeancePage createState() => _MyEditSeancePage();
}

class _MyEditSeancePage extends State<MyAddNewSeance> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getAllSessionsFrom(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text("Error : ${snapshot.error.toString()}");
          }
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            var items = snapshot.data!;
            return Scaffold(
                appBar: AppBar(
                  title: const Text("Ajout de séance au workout"),
                ),
                body: Column(children: <Widget>[
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.black),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              overlayColor: MaterialStateProperty.all(
                                  Colors.grey.shade100)),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: Row(children: [
                              Expanded(child: Text(items[index].name!)),
                              Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: IconButton(
                                      onPressed: () {
                                        addSessionToWorkout(
                                            widget.id!, items[index].uid!);
                                      },
                                      icon: const Icon(Icons.add)))
                            ]),
                          ));
                    },
                  ),
                  Row(children: [
                    Expanded(child: Container()),
                    Expanded(
                        child: Container(
                            color: Colors.green[200],
                            child: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.check)))),
                  ])
                ]));
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
