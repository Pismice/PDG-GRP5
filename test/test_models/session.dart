import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

final instance = FakeFirebaseFirestore();

class Session {
  String? name;
  String? user;
  int? duration;
  List<SessionExercises>? exercises;

  Session({this.name, this.user, this.duration, this.exercises});

  Session.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    user = json['user'].id;
    duration = json['duration'];
    if (json['exercises'] != null) {
      exercises = <SessionExercises>[];
      json['exercises']
          .forEach((e) => exercises!.add(SessionExercises.fromJson(e)));
    }
  }

  factory Session.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    return Session();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (name != null) data['name'] = name;

    if (user != null) {
      data['user'] = instance.doc("user/$user");
    }

    if (duration != null) data['duration'] = duration;
    if (exercises != null) {
      data['exercises'] = exercises!.map((e) => e.toJson()).toList();
    }
    return data;
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (user != null) "user": instance.doc("user/$user"),
      if (duration != null) "duration": duration,
      if (exercises != null)
        "exercises": exercises!.map((e) => e.toFirestore()).toList(),
    };
  }
}

class SessionExercises {
  String? id;
  int? repetition;
  int? set;
  int? weight;
  int? duration;

  SessionExercises(
      {this.id, this.repetition, this.set, this.weight, this.duration});

  SessionExercises.fromJson(Map<String, dynamic> json) {
    id = json['id'].id;
    repetition = json['repetition'];
    set = json['set'];
    weight = json['weight'];
    duration = json['duration'];
  }

  factory SessionExercises.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return SessionExercises(
      id: data?['id'].id,
      repetition: data?['repetition'],
      set: data?['set'],
      weight: data?['weight'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = instance.doc("session/$id");
    if (repetition != null) data['repetition'] = repetition;
    if (set != null) data['set'] = set;
    if (weight != null) data['weight'] = weight;
    if (duration != null) data['duration'] = duration;
    return data;
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": instance.doc("exercise/$id"),
      if (repetition != null) "repetition": repetition,
      if (set != null) "set": set,
      if (weight != null) "weight": weight,
      if (duration != null) "duration": duration,
    };
  }
}
