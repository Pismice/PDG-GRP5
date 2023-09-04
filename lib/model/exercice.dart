import 'package:cloud_firestore/cloud_firestore.dart';

class Exercice {
  String? uid;
  String? name;
  String? img;
  String? user;

  Exercice({this.uid, this.name, this.img, this.user});

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (img != null) "img": img,
      if (user != null) "user": user,
    };
  }
}
