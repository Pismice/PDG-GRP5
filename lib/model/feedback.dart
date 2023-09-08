import 'package:cloud_firestore/cloud_firestore.dart';

/// Classe qui représente un feedback
class Feedback {
  // id du document
  String? uid;
  String? user;
  String? email;
  String? title;
  String? comment;

  Feedback({this.uid, this.user, this.email, this.title, this.comment});

  /// constructeur à partir d'un json
  Feedback.fromJson(Map<String, dynamic> json) {
    if (user != null) user = json['user'].id;
    email = json['email'];
    title = json['title'];
    comment = json['comment'];
  }

  /// Fonction qui crée un feedback à partir d'un DocumentSnapshot
  factory Feedback.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Feedback(
      user: (data?['user'] != null) ? data!['user'].id : null,
      email: data?['email'],
      title: data?['title'],
      comment: data?['comment'],
    );
  }

  /// Fonction qui retourne le feedback au format json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = FirebaseFirestore.instance.doc("user/$user");
    }
    if (email != null) data['email'] = email;
    if (title != null) data['title'] = title;
    if (comment != null) data['comment'] = comment;
    return data;
  }

  /// Fonction qui retourne le feedback au format de la bdd
  Map<String, dynamic> toFirestore() {
    return {
      if (user != null) "user": FirebaseFirestore.instance.doc("user/$user"),
      if (email != null) "email": email,
      if (title != null) "title": title,
      if (comment != null) "comment": comment,
    };
  }
}
