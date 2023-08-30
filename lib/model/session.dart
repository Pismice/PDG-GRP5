import 'package:cloud_firestore/cloud_firestore.dart';

class Session {
  String? name;
  String? user;
  int? duration;
  List<SessionExercises>? exercises;

  Session({this.name, this.user, this.duration, this.exercises});

  factory Session.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Session(
        name: data?['name'],
        user: data?['user'],
        duration: data?['duration'],
        exercises: data?['exercises'].map<Session>((e) => e.toFirestore()));
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (user != null) "user": user,
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

  factory SessionExercises.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return SessionExercises(
      id: data?['name'],
      repetition: data?['repetition'],
      set: data?['set'],
      weight: data?['weight'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (repetition != null) "repetition": repetition,
      if (set != null) "set": set,
      if (weight != null) "weight": weight,
      if (duration != null) "duration": duration,
    };
  }
}
