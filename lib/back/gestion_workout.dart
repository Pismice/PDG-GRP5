import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:g2g/model/workout.dart';
import 'package:g2g/model/user.dart';

final workout = FirebaseFirestore.instance.collection('workout');
final users = FirebaseFirestore.instance.collection('user');
Future<List<Workout>> getAllWorkoutFor(User user) async {
  List<Workout> workouts = List.empty();
  var docs = await workout
      .where('user', isEqualTo: users.doc(user.uid))
      .get()
      .then((value) => value.docs);
  for (var doc in docs) {
    Workout temp = Workout.fromJson(doc.data());
    temp.uid = doc.id;
    workouts.add(temp);
  }
  return workouts;
}
