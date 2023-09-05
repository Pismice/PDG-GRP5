import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:g2g/model/user.dart';
import 'package:g2g/model/exercise.dart';

final exercise = FirebaseFirestore.instance.collection('exercise');
final users = FirebaseFirestore.instance.collection('user');

Future<List<Exercise>> getAllExerciseFor(User user) async {
  List<Exercise> exercises = List.empty();
  var docs = await exercise.get().then((value) => value.docs);
  for (var doc in docs) {
    Exercise temp;
    if (doc.data().containsKey('user')) {
      if (doc.data()['user'] == user.uid) {
        temp = Exercise.fromJson(doc.data());
        temp.uid = doc.id;
      }
      continue;
    }
    temp = Exercise.fromJson(doc.data());
    temp.uid = doc.id;
  }
  return exercises;
}
