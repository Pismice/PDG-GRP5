import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:g2g/api/firebase_exercise.dart';
import 'package:g2g/api/firebase_workout.dart';
import 'package:g2g/model/exercise.dart';
//import 'dart:developer' as developer;

class UserStatistics {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String uid;
  late DocumentReference userRef;
  UserStatistics(this.uid) {
    FirebaseFirestore.instance
        .collection('user')
        .where('authid', isEqualTo: uid)
        .limit(1)
        .get()
        .then((value) =>
            userRef = db.collection('user').doc(value.docs[0].id.toString()));
  }

  Future<String> getHoursSpentInGym() async {
    int totalMinutesSpent = 0;
    List<dynamic> sess;
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;
    docs = await FirebaseFirestore.instance
            .collection('workout')
            .where('user', isEqualTo: userRef)
            .get()
            .then((value) => value.docs)
        /*.catchError((error) =>
            developer.log("Something went wrong : ${error.toString()}"))*/
        ;
    for (var doc in docs) {
      sess = doc.data()['sessions'];
      for (int i = 0; i < sess.length; ++i) {
        if (sess[i]['start'] != null && sess[i]['end'] != null) {
          totalMinutesSpent +=
              DateTime.fromMillisecondsSinceEpoch(sess[i]['end'].seconds * 1000)
                  .difference(DateTime.fromMillisecondsSinceEpoch(
                      sess[i]['start'].seconds * 1000))
                  .inMinutes;
        }
      }
    }

    if (totalMinutesSpent >= 60) {
      return "${(totalMinutesSpent / 60).floor()}h ${totalMinutesSpent % 60}";
    }
    return "${totalMinutesSpent}m";
  }

  Future<double> getTotalWeightPushed() async {
    double totalWeight = 0;
    List<dynamic> sess;
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;
    docs = await FirebaseFirestore.instance
            .collection('workout')
            .where('user', isEqualTo: userRef)
            .get()
            .then((value) => value.docs)
        /*.catchError((error) =>
            developer.log("Something went wrong : ${error.toString()}"))*/
        ;
    for (var doc in docs) {
      sess = doc.data()['sessions'];
      for (int i = 0; i < sess.length; ++i) {
        for (int j = 0; j < sess[i]['exercises'].length; ++j) {
          for (int k = 0; k < sess[i]['exercises'][j]['sets'].length; ++k) {
            if (sess[i]['exercises'][j]['sets'][k]['repetition'] != null &&
                sess[i]['exercises'][j]['sets'][k]['weight'] != null) {
              totalWeight += sess[i]['exercises'][j]['sets'][k]['repetition'] *
                  sess[i]['exercises'][j]['sets'][k]['weight'];
            }
          }
        }
      }
    }
    return totalWeight;
  }

  Future<int> getNumberSessionDone() async {
    int numbers = 0;
    List<dynamic> sess;
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;
    docs = await FirebaseFirestore.instance
            .collection('workout')
            .where('user', isEqualTo: userRef)
            .get()
            .then((value) => value.docs)
        /*.catchError((error) =>
            developer.log("Something went wrong : ${error.toString()}"),)*/
        ;

    for (var doc in docs) {
      sess = doc.data()['sessions'];
      for (int i = 0; i < sess.length; ++i) {
        if (sess[i]['start'] != null && sess[i]['end'] != null) {
          numbers++;
        }
      }
    }
    return numbers;
  }
}

Future<Map<int, int>> _getEvolution(Exercise exercise, {String? authid}) async {
  final workouts = await getAllWorkoutsFrom(authid: authid);

  final Map<int, int> evolution = <int, int>{};

  for (var workout in workouts) {
    int weekPR = 0;
    int iter = 0;

    if (workout.duration! > workout.sessions!.length / workout.duration!) {
      iter = 1;
    }

    for (var i = 0; i < iter; i++) {
      for (var j = 0; j < workout.sessions!.length; j++) {
        for (var exerciseDone
            in workout.sessions![j + i * workout.sessions!.length].exercises!) {
          if (exerciseDone.id != exercise.uid) continue;

          for (var set in exerciseDone.sets!) {
            switch (exercise.type) {
              case "REP":
                if (set.repetition! > weekPR) {
                  weekPR = set.repetition!;
                }
                break;
              case "TIME":
                if (set.duration! > weekPR) {
                  weekPR = set.duration!;
                }
                break;
              case "WEIGHT":
              default:
                if (set.weight! > weekPR) {
                  weekPR = set.weight!;
                }
                break;
            }
          }
        }
      }
      evolution[workout.week! + i] = weekPR;
    }
  }

  return evolution;
}

Future<Map<int, int>> getWeightEvolution(String exerciseId,
    {String? authid}) async {
  final exercise = await getExercise(exerciseId);

  if (exercise.type != "WEIGHT") {
    throw Exception("Pas le bon type d'exercice");
  }

  return _getEvolution(exercise, authid: authid);
}

Future<Map<int, int>> getRepEvolution(String exerciseId,
    {String? authid}) async {
  final exercise = await getExercise(exerciseId);

  if (exercise.type != "REP") {
    throw Exception("Pas le bon type d'exercice");
  }

  return _getEvolution(exercise, authid: authid);
}

Future<Map<int, int>> getDurationEvolution(String exerciseId,
    {String? authid}) async {
  final exercise = await getExercise(exerciseId);

  if (exercise.type != "TIME") {
    throw Exception("Pas le bon type d'exercice");
  }

  return _getEvolution(exercise, authid: authid);
}
