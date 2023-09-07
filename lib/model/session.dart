import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:g2g/model/workout.dart';

/// classe qui représente une séance
class Session {
  String? uid;
  String? name;
  String? user;
  int? duration;
  List<SessionExercises>? exercises;

  Session({this.uid, this.name, this.user, this.duration, this.exercises});

  bool isFinished(WorkoutSessions workoutSessions) {
    // Si la séance ne contient pas d'exercices template
    if (exercises == null) {
      return true;
    }
    if (exercises!.isEmpty) {
      return true;
    }

    // Si aucun n exercice n a ete effectue
    if (workoutSessions.exercises == null) {
      return false;
    }
    if (workoutSessions.exercises!.isEmpty) {
      return false;
    }

    List<int> setNumbers = [];
    for (var exercise in exercises!) {
      if (exercise.set == null) return false;
      setNumbers.add(exercise.set!);
    }

    int i = 0;
    // Verifier que tous les sets soient non null
    for (var exercice in workoutSessions.exercises!) {
      if (exercice.sets == null) return false;
      if (exercice.sets!.length != setNumbers[i++]) return false;
    }

    return true;
  }

  /// Constructeur à partir d'un json
  Session.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (user != null) user = json['user'].id;
    duration = json['duration'];
    if (json['exercises'] != null) {
      exercises = <SessionExercises>[];
      for (Map<String, dynamic> exercise in json['exercises']) {
        exercises!.add(SessionExercises.fromJson(exercise));
      }
    }
  }

  /// Fonction qui crée une séance à partir d'un documentSnapshot
  factory Session.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();

    return Session(
        uid: snapshot.id,
        name: data?['name'],
        user: (data?['user'] != null) ? data!['user'].id : null,
        duration: data?['duration'],
        exercises:
            data?['exercises'].map<SessionExercises>((e) => {}).toList());
  }

  /// Fonction qui retourne la séance au format JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (name != null) data['name'] = name;

    if (user != null) {
      data['user'] = FirebaseFirestore.instance.doc("user/$user");
    }

    if (duration != null) data['duration'] = duration;
    if (exercises != null) {
      data['exercises'] = exercises!.map((e) => e.toJson()).toList();
    }
    return data;
  }

  /// Fonction qui retourne la session au format de la bdd
  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (user != null) "user": FirebaseFirestore.instance.doc("user/$user"),
      if (duration != null) "duration": duration,
      if (exercises != null)
        "exercises": exercises!.map((e) => e.toFirestore()).toList(),
    };
  }
}

/// Classe qui représente les exercices des séances
class SessionExercises {
  String? id;
  int? positionId;
  int? repetition;
  int? set;
  int? weight;
  int? duration;
  String? sessionId;

  SessionExercises({
    this.id,
    this.positionId,
    this.repetition,
    this.set,
    this.weight,
    this.duration,
    this.sessionId,
  });

  /// Constructeur à partir d'un json
  SessionExercises.fromJson(Map<String, dynamic> json) {
    if (json['id'] != null) id = json['id'].id;
    repetition = json['repetition'];
    set = json['set'];
    weight = json['weight'];
    duration = json['duration'];
  }

  /// Fonction qui crée un exo de séance à partir d'un documentSnapshot
  factory SessionExercises.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return SessionExercises(
      id: data?['id'] != null ? data!['id'].id : null,
      repetition: data?['repetition'],
      set: data?['set'],
      weight: data?['weight'],
    );
  }

  /// Fonction qui retourne l'exerice au format json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = FirebaseFirestore.instance.doc("exercise/$id");
    if (repetition != null) data['repetition'] = repetition;
    if (set != null) data['set'] = set;
    if (weight != null) data['weight'] = weight;
    if (duration != null) data['duration'] = duration;
    return data;
  }

  /// Fonction qui retourne l'exercice au format de la bdd
  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": FirebaseFirestore.instance.doc("exercise/$id"),
      if (repetition != null) "repetition": repetition,
      if (set != null) "set": set,
      if (weight != null) "weight": weight,
      if (duration != null) "duration": duration,
    };
  }
}
