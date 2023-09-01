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
  await instance.collection('exercice').add({
    'img': e.img,
    'name': e.name,
  });
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

void main() async {
  addExercice(Exercise(name: "my exercice"));

  final snapshot = await instance.collection('users').get();

  setUpAll(() async {});

  test("lol", () async {
    expect("actual", "actual");
  });

  // test("Create and get Workout", () async {
  //   Workout myWorkout = Workout(
  //       name: "Mon workout firebase", user: "", duration: 5, sessions: []);
  //   Workout addedWorkout = await addWorkout(myWorkout);
  //   expect(addedWorkout.name, myWorkout.name);
  // });
}
