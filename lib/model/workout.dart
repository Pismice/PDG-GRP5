import 'package:cloud_firestore/cloud_firestore.dart';

class Workout {
  String? uid;
  String? name;
  String? user;
  int? duration;
  int? week;
  List<WorkoutSessions>? sessions;

  Workout(
      {this.uid,
      this.name,
      this.user,
      this.duration,
      this.week,
      this.sessions});

  Workout.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    user = json['user'].id;
    duration = json['duration'];
    week = json['week'];
    if (json['sessions'] != null) {
      sessions = <WorkoutSessions>[];
      for (Map<String, dynamic> session in json['sessions']) {
        sessions!.add(WorkoutSessions.fromJson(session));
      }
    }
  }

  factory Workout.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();

    return Workout(
        name: data?['name'],
        user: data?['user'],
        duration: data?['duration'],
        week: data?['week'],
        sessions: data?['sessions']
            .map<WorkoutSessions>((e) => WorkoutSessions.fromJson(e))
            .toList());
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (user != null) "user": FirebaseFirestore.instance.doc("user/$user"),
      if (duration != null) "duration": duration,
      if (week != null) "week": week,
      if (sessions != null)
        "sessions": sessions!.map((s) => s.toFirestore()).toList(),
    };
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (user != null) {
      data['user'] = FirebaseFirestore.instance.doc("user/$user");
    }
    if (duration != null) data['duration'] = duration;
    if (week != null) data['week'] = week;
    if (sessions != null) {
      data['sessions'] = sessions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WorkoutSessions {
  String? id;
  DateTime? start;
  DateTime? end;
  List<ExercisesDone>? exercises;

  WorkoutSessions({this.id, this.start, this.end, this.exercises});

  WorkoutSessions.fromJson(Map<String, dynamic> json) {
    id = json['id'].id;
    if (json['start'] != null) {
      start = DateTime.fromMillisecondsSinceEpoch(json['start'].seconds * 1000);
    }
    if (json['end'] != null) {
      end = DateTime.fromMillisecondsSinceEpoch(json['end'].seconds * 1000);
    }
    if (json['exercises'] != null) {
      exercises = <ExercisesDone>[];
      for (Map<String, dynamic> exercise in json['exercises']) {
        exercises!.add(ExercisesDone.fromJson(exercise));
      }
    }
  }

  factory WorkoutSessions.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return WorkoutSessions(
      id: data?['id'].id,
      start: data?['start'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data?['start'])
          : null,
      end: data?['end'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data?['end'])
          : null,
      exercises:
          data?['sessions'].map<ExercisesDone>((e) => ExercisesDone()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = FirebaseFirestore.instance.doc("session/$id");
    if (start != null) data['start'] = start!.millisecondsSinceEpoch / 1000;
    if (end != null) data['end'] = end!.millisecondsSinceEpoch / 1000;
    if (exercises != null) {
      data['exercises'] = exercises!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": FirebaseFirestore.instance.doc("session/$id"),
      if (start != null) "start": start!.millisecondsSinceEpoch / 1000,
      if (end != null) "end": end!.millisecondsSinceEpoch / 1000,
      if (exercises != null)
        "exercises": exercises!.map((e) => e.toFirestore()).toList(),
    };
  }
}

class ExercisesDone {
  String? id;
  List<Sets>? sets;

  ExercisesDone({this.id, this.sets});

  ExercisesDone.fromJson(Map<String, dynamic> json) {
    id = json['id'].id;
    if (json['sets'] != null) {
      final jsets = json['sets'];
      sets = <Sets>[];
      for (Map<String, dynamic> set in jsets) {
        sets!.add(Sets.fromJson(set));
      }
    }
  }

  factory ExercisesDone.fromFirebase(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();

    return ExercisesDone(
      id: data?['id'].id,
      sets: data?['sets'].map<Sets>((s) => {}),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = FirebaseFirestore.instance.doc("exercise/$id");
    if (sets != null) {
      data['sets'] = sets!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": FirebaseFirestore.instance.doc("exercise/$id"),
      if (sets != null) "sets": sets!.map((s) => s.toFirestore()).toList(),
    };
  }
}

class Sets {
  int? weight;
  int? repetition;
  int? duration;

  Sets({this.weight, this.repetition, this.duration});

  Sets.fromJson(Map<String, dynamic> json) {
    if (json['weight'] != null) weight = json['weight'];
    if (json['repetition'] != null) repetition = json['repetition'];
    if (json['duration'] != null) duration = json['duration'];
  }

  factory Sets.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Sets(
      weight: data?['weight'],
      repetition: data?['repetition'],
      duration: data?['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (weight != null) data['weight'] = weight;
    if (repetition != null) data['repetition'] = repetition;
    if (duration != null) data['duration'] = duration;
    return data;
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (weight != null) "weight": weight,
      if (repetition != null) "repetition": repetition,
      if (duration != null) "duration": duration,
    };
  }
}
