import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g2g/model/exercice.dart';
import 'package:g2g/model/session.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

final instance = FakeFirebaseFirestore();

Future<void> addExercice(Exercise e) async {
  await instance.collection('exercise').add({
    'img': e.img,
    'name': e.name,
  });
}

Future<DocumentSnapshot<Object?>> getExercise(String documentId) async {
  return exercises.doc(documentId).get();
}

final users = instance.collection('user');
final exercises = instance.collection('exercise');

void main() async {
  addExercice(Exercise(name: "my exercice"));

  final snapshot = await users.get();

  setUpAll(() async {});

  test("addExercise", () async {
    Exercise e = Exercise(name: "cool pompe", img: "pompe.png");
    await addExercice(e);

    final exRef = await exercises
        .where('name', isEqualTo: e.name)
        .where('img', isEqualTo: e.img)
        .limit(1)
        .get()
        .then((value) => exercises.doc(value.docs[0].id));

    final doc = await getExercise(exRef.id);

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    expect(e.name, data['name']);
    expect(e.img, data['img']);
  });

  test("updateExercise", () async {
    Exercise e = Exercise(name: "cool pompe", img: "pompe.png");
    await addExercice(e);

    final exRef = await exercises
        .where('name', isEqualTo: e.name)
        .where('img', isEqualTo: e.img)
        .limit(1)
        .get()
        .then((value) => exercises.doc(value.docs[0].id));

    final doc = await getExercise(exRef.id);

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    expect(e.name, data['name']);
    expect(e.img, data['img']);
  });
}
