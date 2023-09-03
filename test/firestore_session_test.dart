import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_models/session.dart';

final instance = FakeFirebaseFirestore();

var sessions = instance.collection("session");
var users = instance.collection("user");

Future<DocumentReference<Map<String, dynamic>>> getReference(
    Session session) async {
  return await sessions
      .where('name', isEqualTo: session.name)
      .limit(1)
      .get()
      .then((value) => sessions.doc(value.docs[0].id));
}

Future<DocumentReference<Map<String, dynamic>>> getUserReference(
    String authid) async {
  return await users
      .where('authid', isEqualTo: authid)
      .limit(1)
      .get()
      .then((value) => users.doc(value.docs[0].id));
}

Future<Session> getSession(String documentId) async {
  final snapshot = await sessions.doc(documentId).get();
  if (snapshot.data() == null) {
    throw Exception("Séance non trouvée");
  }
  final session = Session.fromJson(snapshot.data()!);
  return session;
}

Future<List<Session>> getAllSessionsFrom(String? uid) async {
  final userRef = await users
      .where('authid', isEqualTo: uid)
      .limit(1)
      .get()
      .then((value) => users.doc(value.docs[0].id));

  final truc = await sessions.get();
  truc.docs.map((e) async => await e.data()['user'].get());
  final snapshot = await sessions.where('user', isEqualTo: userRef).get();

  final data = snapshot.docs.map((w) => Session.fromJson(w.data())).toList();

  return data;
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

Future<void> addUser() async {
  await users.add({
    'authid': 'hihihihihhi',
    'name': 'Bob',
  });
}

void main() async {
  await addUser();
  SessionExercises exercises1 =
      SessionExercises(id: "26A3qJS4qLtM9nXJx9vE", repetition: 5, set: 5);
  SessionExercises exercises2 =
      SessionExercises(id: "6Rl2uzhZnOnHyODT26KR", repetition: 5, set: 5);
  Session session = Session(
      name: "session test",
      user: (await getUserReference("hihihihihhi")).id,
      duration: 20,
      exercises: [exercises1, exercises2]);
/*
  test("getAllSessions", () async {
    await addSession(session);
    await addSession(session);

    final doc = await getAllSessionsFrom("hihihihihhi");

    expect(doc.length, 2);
  });*/

  test("addSession", () async {
    await addSession(session);

    final ref = await getReference(session);

    final doc = await getSession(ref.id);

    expect(doc.name, session.name);
  });

  test("updateSession", () async {
    await addSession(session);

    final ref = await getReference(session);
    session.name = "euh voila quoi c'est une séance quoi";

    await updateSession(ref.id, session);
    final doc = await getSession(ref.id);

    expect(doc.name, "euh voila quoi c'est une séance quoi");
  });

  test("deleteSession", () async {
    await addSession(session);

    var ref = await getReference(session);

    var doc = await sessions.doc(ref.id).get();
    expect(true, doc.exists);

    deleteSession(ref.id);

    doc = await sessions.doc(ref.id).get();
    expect(false, doc.exists);
  });
}
