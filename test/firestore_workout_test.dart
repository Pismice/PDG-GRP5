import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_models/workout.dart';

final instance = FakeFirebaseFirestore();

var workouts = instance.collection("workout");
var users = instance.collection("user");

Future<DocumentReference<Map<String, dynamic>>> getUserReference(
    String authid) async {
  return await users
      .where('authid', isEqualTo: authid)
      .limit(1)
      .get()
      .then((value) => users.doc(value.docs[0].id));
}

Future<Workout> getWorkout(String documentId) async {
  final snapshot = await workouts.doc(documentId).get();
  if (snapshot.data() == null) {
    throw Exception("Workout non trouvée");
  }
  var workout = Workout.fromJson(snapshot.data()!);
  workout.uid = documentId;
  return workout;
}

Future<List<Workout>> getAllWorkoutsFrom(String? uid) async {
  final userRef = await users
      .where('authid', isEqualTo: uid)
      .limit(1)
      .get()
      .then((value) => users.doc(value.docs[0].id));

  final truc = await workouts.get();
  truc.docs.map((e) async => await e.data()['user'].get());
  final snapshot = await workouts.where('user', isEqualTo: userRef).get();

  final data = snapshot.docs.map((w) {
    var workout = Workout.fromJson(w.data());
    workout.uid = w.id;
    return workout;
  }).toList();

  return data;
}

Future<void> addWorkout(Workout workout) async {
  try {
    await workouts
        .withConverter(
            fromFirestore: Workout.fromFirestore,
            toFirestore: (Workout workout, options) => workout.toFirestore())
        .doc(workout.uid)
        .set(workout);
  } on Exception catch (e) {
    throw Exception("Erreur lors de l'ajout : $e");
  }
}

Future<void> updateWorkout(Workout workout) async {
  try {
    await workouts.doc(workout.uid).update(workout.toFirestore());
  } on Exception catch (e) {
    throw Exception("Erreur lors de la modification : $e");
  }
}

Future<void> deleteWorkout(String docId) async {
  try {
    await workouts.doc(docId).delete();
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

  Workout workout = Workout(
      uid: "hiphiphip",
      name: "workout test",
      user: (await getUserReference("hihihihihhi")).id,
      duration: 50);

  /*test("getAllWorkouts", () async {
    await addWorkout(workout);
    await addWorkout(workout);

    final doc = await getAllWorkoutsFrom("hihihihihhi");

    expect(doc.length, 2);
  });*/

  test("addWorkout", () async {
    await addWorkout(workout);

    final doc = await getWorkout(workout.uid!);

    expect(doc.name, workout.name);
  });

  test("updateWorkout", () async {
    await addWorkout(workout);

    workout.name = "euh voila quoi c'est un workout quoi";

    await updateWorkout(workout);
    final doc = await getWorkout(workout.uid!);

    expect(doc.name, "euh voila quoi c'est un workout quoi");
  });

  test("deleteWorkout", () async {
    await addWorkout(workout);

    var doc = await workouts.doc(workout.uid).get();
    expect(true, doc.exists);

    deleteWorkout(workout.uid!);

    doc = await workouts.doc(workout.uid).get();
    expect(false, doc.exists);
  });
}
