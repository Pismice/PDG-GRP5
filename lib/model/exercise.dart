import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise {
  String? uid;
  String? name;
  String? img;

  Exercise({this.uid, this.name, this.img});

  Exercise.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    img = json['img'];
  }

  factory Exercise.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();

    return Exercise(name: data?['name'], img: data?['img']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (img != null) data['img'] = img;

    return data;
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (img != null) "img": img,
    };
  }
}
