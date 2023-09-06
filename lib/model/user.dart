import 'package:cloud_firestore/cloud_firestore.dart';

/// Classe qui représente un utilisateur
class User {
  // id du document de la bdd
  String? uid;
  String? authId;
  String? name;
  String? profilepicture;

  User({this.uid, this.authId, this.name, this.profilepicture});

  /// Fonction qui crée un user à partir du documentSnapshot
  factory User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();

    return User(
        uid: snapshot.id,
        authId: data?['authId'],
        name: data?['name'],
        profilepicture: data?['profilepicture']);
  }

  /// Constructeur à partir d'un json
  User.fromJson(Map<String, dynamic> json) {
    authId = json['authid'];
    name = json['name'];
    profilepicture = json['profilepicture'];
  }

  /// Fonction qui retourne l'utilisateur format de la bdd
  Map<String, dynamic> toFirestore() {
    return {
      "authid": authId,
      "name": name,
      "profilepicture": profilepicture,
    };
  }
}
