import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:g2g/model/exercise.dart';
import 'package:g2g/model/session.dart';
import 'package:g2g/api/firebase_exercise.dart';

class MyAddNewExercise extends StatefulWidget {
  const MyAddNewExercise({Key? key, required this.session}) : super(key: key);
  final Session session;
  @override
  // ignore: library_private_types_in_public_api
  _MyAddNewExercise createState() => _MyAddNewExercise();
}

class _MyAddNewExercise extends State<MyAddNewExercise> {
  TextEditingController editingController = TextEditingController();

  List<Exercise>? exercises = [];
  var items = <Exercise>[];
  bool queryEmpty = true;

  @override
  void initState() {
    items = exercises!;
    super.initState();
  }

  void filterSearchResults(String query) {
    queryEmpty = query.isEmpty;
    setState(() {
      items = exercises!
          .where(
              (item) => item.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Session creation"),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: const InputDecoration(
                    labelText: "Search",
                    hintText: "An exercise",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)))),
              ),
            ),
            FutureBuilder(
                future: getAllExercises(
                    authid: FirebaseAuth.instance.currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    exercises = snapshot.data;
                    if (exercises!.isEmpty) {
                      return const Text("No available exercise");
                    }
                    if (items.isEmpty && queryEmpty) {
                      items = exercises!;
                    }
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return ElevatedButton(
                              onPressed: () {
                                widget.session.exercises ??= [];
                                widget.session.exercises?.add(SessionExercises(
                                    id: items[index].uid!,
                                    repetition: 1,
                                    set: 1,
                                    weight: 1,
                                    duration: 1,
                                    sessionId: widget.session.uid));
                                Navigator.pop(context);
                              },
                              child: Column(children: <Widget>[
                                Row(children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: FutureBuilder(
                                        future: FirebaseStorage.instance
                                            .refFromURL(
                                                'gs://hongym-4cb68.appspot.com')
                                            .child(
                                                "img/exercises/${items[index].img}")
                                            .getDownloadURL(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Container();
                                          }
                                          return Image.network(
                                            snapshot.data.toString(),
                                            height: 100,
                                            width: 100,
                                          );
                                        },
                                      )),
                                  Expanded(child: Text(items[index].name!)),
                                ]),
                              ]));
                        },
                      ),
                    );
                  }
                  return const Text("");
                })
          ],
        ));
  }
}
