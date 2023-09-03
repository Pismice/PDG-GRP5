import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g2g/model/exercice.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

final instance = FakeFirebaseFirestore();

Future<DocumentReference<Map<String, dynamic>>> getReference(
    Exercise ex) async {
  return await exercises
      .where('name', isEqualTo: ex.name)
      .where('img', isEqualTo: ex.img)
      .limit(1)
      .get()
      .then((value) => exercises.doc(value.docs[0].id));
}

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

void main() async {
  Exercise e = Exercise(name: "cool pompe", img: "pompe.png");

  test("addExercise", () async {
    await addExercice(e);

    final exRef = await getReference(e);

    final doc = await getExercise(exRef.id);

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    expect(e.name, data['name']);
    expect(e.img, data['img']);
  });

  test("updateExercise", () async {
    await addExercice(e);

    final exRef = await getReference(e);

    updateExercise(exRef.id, "super cool pompe");

    final doc = await getExercise(exRef.id);

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    expect(data['name'], "super cool pompe");
  });

  test("deleteExercise", () async {
    await addExercice(e);

    final exRef = await getReference(e);

    var doc = await getExercise(exRef.id);

    expect(doc.exists, true);

    deleteExercise(exRef.id);

    doc = await getExercise(exRef.id);
    expect(doc.exists, false);
  });
}
