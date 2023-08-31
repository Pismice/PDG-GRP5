import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_exercise.dart';
import 'package:g2g/model/session.dart';
import 'package:uuid/uuid.dart';

class GetSession extends StatelessWidget {
  final String documentId;

  const GetSession(this.documentId, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSession(documentId),
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
              Text("Crée par ${data['user'].id}"),
              Text("Durée de la session : ${data['duration']} min"),
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(),
                  child: Column(
                    children: data['exercises'].map<Widget>(
                      (ex) {
                        return Column(
                          children: [
                            GetExercise(ex['id'].id),
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

CollectionReference sessions = FirebaseFirestore.instance.collection('session');

Future<DocumentSnapshot<Object?>> getSession(String documentId) async {
  return sessions.doc(documentId).get();
}

/// Ajoute une [Session] qui correspond à une séance dans la base de donnée
Future<void> addSession(Session session) async {
  await sessions
      .withConverter(
          fromFirestore: Session.fromFirestore,
          toFirestore: (Session session, options) => session.toFirestore())
      .doc(const Uuid().v1())
      .set(session);
}

/// Met à jour une [Session] passée en paramètre en fonction de son
/// [docId]
Future<void> updateSession(String docId, Session session) async {
  await sessions.doc(docId).update(session.toFirestore());
}
