import 'package:cloud_firestore/cloud_firestore.dart';

class Feedback {
  String? uid;
  String? user;
  String? email;
  String? title;
  String? comment;

  Feedback({this.uid, this.user, this.email, this.title, this.comment});

  Feedback.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    email = json['email'];
    title = json['title'];
    comment = json['comment'];
  }

  factory Feedback.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Feedback(
      user: data?['name'],
      email: data?['email'],
      title: data?['title'],
      comment: data?['comment'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) data['user'] = user;
    if (email != null) data['email'] = email;
    if (title != null) data['title'] = title;
    if (comment != null) data['comment'] = comment;
    return data;
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (user != null) "user": user,
      if (email != null) "email": email,
      if (title != null) "title": title,
      if (comment != null) "comment": comment,
    };
  }
}
