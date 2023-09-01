import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:g2g/model/session.dart';

class GetSession extends StatelessWidget {
  final String documentId;

  const GetSession(this.documentId, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSession(documentId),
      builder: (BuildContext context, AsyncSnapshot<Session> snapshot) {
        if (snapshot.hasError) {
          return const Text("Quelque chose n'a pas fonctionné");
        }

        if (!snapshot.hasData) {
          return const Text("Le document n'existe pas");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return Text(snapshot.data!.name!);
        }

        return const Text("Chargement");
      },
    );
  }
}

final sessions = FirebaseFirestore.instance.collection('session');

Future<Session> getSession(String documentId) async {
  final snapshot = await sessions.doc(documentId).get();
  if (snapshot.data() == null) {
    throw Exception("Séance non trouvée");
  }
  final session = Session.fromJson(snapshot.data()!);
  return session;
}

/// Ajoute une [Session] qui correspond à une séance dans la base de donnée
Future<void> addSession(Session session) async {
  try {
    await sessions
        .withConverter(
            fromFirestore: Session.fromFirestore,
            toFirestore: (Session session, options) => session.toFirestore())
        .doc()
        .set(session);
  } on Exception catch (e) {
    throw Exception("Erreur lors de l'ajout : $e");
  }
}

/// Met à jour une [Session] passée en paramètre en fonction de son
/// [docId]
Future<void> updateSession(String docId, Session session) async {
  try {
    await sessions.doc(docId).update(session.toFirestore());
  } on Exception catch (e) {
    throw Exception("Erreur lors de la modification : $e");
  }
}

Future<void> deleteSession(String docId) async {
  try {
    await sessions.doc(docId).delete();
  } on Exception catch (e) {
    throw Exception("Erreur lors de la suppression : $e");
  }
}
