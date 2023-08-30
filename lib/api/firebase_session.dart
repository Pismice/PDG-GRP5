import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_exercise.dart';

class GetSession extends StatelessWidget {
  final String documentId;

  const GetSession(this.documentId, {super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference sessions =
        FirebaseFirestore.instance.collection('session');

    return FutureBuilder(
      future: sessions.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Quelque chose n'a pas fonctionné");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Le document n'existe pas");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Column(
            children: [
              Text("Nom de la séance: ${data['name']}"),
              Text("Crée par ${data['user']}"),
              Text("Durée de la session : ${data['duration']} min"),
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(),
                  child: Column(
                    children: data['exercises'].map<Widget>(
                      (ex) {
                        final id = ex['id'];
                        int index = id.indexOf('/');
                        String res = "";
                        if (index != -1) {
                          res = id.substring(index + 1);
                        }
                        return Column(
                          children: [
                            GetExercise(res),
                            Text("Séries : ${ex['repetition']} x ${ex['set']}"),
                            Text("Poids : ${ex['weight']} kg"),
                          ],
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
            ],
          );
        }

        return const Text("Chargement");
      },
    );
  }
}
