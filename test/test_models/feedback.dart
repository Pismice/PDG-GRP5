import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

final instance = FakeFirebaseFirestore();

class Feedback {
  String? uid;
  String? user;
  String? email;
  String? title;
  String? comment;

  Feedback({this.uid, this.user, this.email, this.title, this.comment});

  Feedback.fromJson(Map<String, dynamic> json) {
    if (user != null) user = json['user'].id;
    email = json['email'];
    title = json['title'];
    comment = json['comment'];
  }

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = instance.doc("user/$user");
    }
    if (email != null) data['email'] = email;
    if (title != null) data['title'] = title;
    if (comment != null) data['comment'] = comment;
    return data;
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (user != null) "user": instance.doc("user/$user"),
      if (email != null) "email": email,
      if (title != null) "title": title,
      if (comment != null) "comment": comment,
    };
  }
}
