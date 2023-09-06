import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_exercise.dart';
import 'package:g2g/api/firebase_session.dart';
import 'package:g2g/model/exercise.dart';
import 'package:g2g/model/session.dart';
import 'package:g2g/screens/gestion/modification/editseance.dart';

class MySeanceInfoPage extends StatefulWidget {
  final Session session;
  const MySeanceInfoPage(this.session, {Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MySeanceInfoPage createState() => _MySeanceInfoPage();
}

class _MySeanceInfoPage extends State<MySeanceInfoPage> {
  String displaySet(Exercise ex) {
    for (var sessEx in widget.session.exercises!) {
      if (sessEx.id != ex.uid) continue;
      String res = "";
      switch (ex.type) {
        case "TIME":
          return "${sessEx.duration} sec";
        case "WEIGHT":
          res = "${sessEx.weight} kg |";
          continue rest;
        rest:
        default:
          return "$res ${sessEx.repetition} x ${sessEx.set}";
      }
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.session.name}"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.session.exercises!.length,
              itemBuilder: (context, index) {
                final data = widget.session.exercises![index];
                return FutureBuilder(
                  future: getExercise(data.id!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    final exercise = snapshot.data!;
                    return ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.black),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          overlayColor:
                              MaterialStateProperty.all(Colors.grey.shade100)),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: FutureBuilder(
                                  future: FirebaseStorage.instance
                                      .refFromURL(
                                          'gs://hongym-4cb68.appspot.com')
                                      .child("img/exercises/${exercise.img}")
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
                                ),
                              ),
                            ),
                            Expanded(child: Text(exercise.name!)),
                            Text(
                              displaySet(exercise),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyEditSeancePage(widget.session),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Suppression du workout'),
                        content: const Text(
                            'Êtes-vous certain de vouloir supprimer cette session ?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Annuler'),
                          ),
                          TextButton(
                            onPressed: () {
                              deleteSession(widget.session.uid!);
                              Navigator.pop(context, 'OK');
                            },
                            child: const Text('Supprimer'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
