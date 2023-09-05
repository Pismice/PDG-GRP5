import 'package:flutter_test/flutter_test.dart';
import 'package:g2g/model/exercise.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

final instance = FakeFirebaseFirestore();

Future<void> addUser() async {
  await instance.collection('user').add({
    'authid': 'nimportequoi',
    'name': 'Bob',
  });
}

Future<Exercise> getExercise(String documentId) async {
  final snapshot = await exercises.doc(documentId).get();
  if (snapshot.data() == null) {
    throw Exception("Exercice non trouvé");
  }
  Exercise exercise = Exercise.fromJson(snapshot.data()!);
  exercise.uid = documentId;
  return exercise;
}

Future<void> addExercise(Exercise exercise) async {
  try {
    await exercises
        .withConverter(
            fromFirestore: Exercise.fromFirestore,
            toFirestore: (Exercise exercise, options) => exercise.toFirestore())
        .doc(exercise.uid)
        .set(exercise);
  } on Exception catch (e) {
    throw Exception("Erreur lors de l'ajout : $e");
  }
}

Future<void> updateExercise(Exercise exercise) async {
  try {
    await exercises.doc(exercise.uid).update(exercise.toFirestore());
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
  Exercise e = Exercise(
    uid: "nimportequoi",
    name: "cool pompe",
    img: "pompe.png",
    type: "REP",
  );

  test("addExercise", () async {
    await addExercise(e);

    final doc = await getExercise(e.uid!);

    expect(doc.uid, e.uid);
  });

  test("updateExercise", () async {
    await addExercise(e);

    e.name = "super cool pompe";

    updateExercise(e);

    final doc = await getExercise(e.uid!);

    expect(doc.name, "super cool pompe");
  });

  test("deleteExercise", () async {
    await addExercise(e);

    var doc = await exercises.doc(e.uid).get();
    expect(true, doc.exists);

    deleteExercise(e.uid!);

    doc = await exercises.doc(e.uid).get();
    expect(false, doc.exists);
  });
}
