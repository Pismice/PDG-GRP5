import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? uid;
  String? authId;
  String? name;
  String? profilepicture;

  User({this.uid, this.authId, this.name, this.profilepicture});

  factory User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();

    return User(
        uid: snapshot.id,
        authId: data?['authId'],
        name: data?['name'],
        profilepicture: data?['profilepicture']);
  }

  User.fromJson(Map<String, dynamic> json) {
    authId = json['authid'];
    name = json['name'];
    profilepicture = json['profilepicture'];
  }

  Map<String, dynamic> toFirestore() {
    return {
      "authid": authId,
      "name": name,
      "profilepicture": profilepicture,
    };
  }
}
