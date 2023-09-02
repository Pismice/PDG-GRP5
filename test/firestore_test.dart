import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g2g/model/exercice.dart';
import 'package:g2g/model/session.dart';
import 'package:g2g/model/workout.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

final instance = FakeFirebaseFirestore();

Future<void> addUser() async {
  await instance.collection('user').add({
    'authid': 'nimportequoi',
    'name': 'Bob',
  });
}

Future<void> addExercice(Exercise e) async {
  await instance.collection('exercise').add({
    'img': e.img,
    'name': e.name,
  });
}

Future<DocumentSnapshot<Object?>> getExercise(String documentId) async {
  return exercises.doc(documentId).get();
}

Future<void> addSession(Session s) async {
  await instance.collection('session').add({
    'duration': 5,
    'exercices': s.exercises,
  });
}

Future<void> addWorkout(Workout s) async {
  await instance.collection('workout').add({
    'name': 'workout2',
    'duration': 5,
    'sessions': s.sessions,
  });
}

Future<void> updateExercise(String docId, String newName) async {
  try {
    await exercises.doc(docId).update({'name': newName});
  } on Exception catch (e) {
    throw Exception("Erreur lors de la modification : $e");
  }
}

Future<void> deleteExercise(String docId) async {
  try {
    await exercises.doc(docId).delete();
  } on Exception catch (e) {
    throw Exception("Erreur lors de la suppressions : $e");
  }
}

final users = instance.collection('user');
final exercises = instance.collection('exercise');

Future<DocumentReference<Map<String, dynamic>>> getReference(
    Exercise ex) async {
  return await exercises
      .where('name', isEqualTo: ex.name)
      .where('img', isEqualTo: ex.img)
      .limit(1)
      .get()
      .then((value) => exercises.doc(value.docs[0].id));
}

void main() async {}
