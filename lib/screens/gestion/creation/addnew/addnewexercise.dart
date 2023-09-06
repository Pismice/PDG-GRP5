import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Nouvelle Séance"),
        ),
        body: FutureBuilder(
            future: getAllExercises(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final exercises = snapshot.data;
                if (exercises!.isEmpty) {
                  return const Text("Aucun exercice disponible");
                }
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextField(
                        onChanged: (value) {},
                        controller: editingController,
                        decoration: const InputDecoration(
                            labelText: "Recherche",
                            hintText: "Un exercice",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)))),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: exercises.length,
                        itemBuilder: (context, index) {
                          return ElevatedButton(
                              onPressed: () {
                                widget.session.exercises ??= [];
                                widget.session.exercises?.add(SessionExercises(
                                    id: exercises[index].uid!,
                                    repetition: 1,
                                    set: 1,
                                    weight: 1,
                                    duration: 1,
                                    sessionId: widget.session.uid));
                                Navigator.pop(context);
                              },
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.black),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.grey.shade100)),
                              child: Column(children: <Widget>[
                                Row(children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: FutureBuilder(
                                        future: FirebaseStorage.instance
                                            .refFromURL(
                                                'gs://hongym-4cb68.appspot.com')
                                            .child(
                                                "img/exercises/${exercises[index].img}")
                                            .getDownloadURL(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          }
                                          return Image.network(
                                            snapshot.data.toString(),
                                            height: 100,
                                            width: 100,
                                          );
                                        },
                                      )),
                                  Expanded(child: Text(exercises[index].name!)),
                                ]),
                              ]));
                        },
                      ),
                    ),
                  ],
                );
              }
              return const Text("");
            }));
  }
}
