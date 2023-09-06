import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise {
  String? uid;
  String? name;
  String? img;
  String? type;
  String? user;

  Exercise({this.uid, this.name, this.img, this.type, this.user});

  Exercise.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    img = json['img'];
    type = json['type'];
    if (json['user'] != null) user = json['user'].id;
  }

  factory Exercise.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();

    return Exercise(
      name: data?['name'],
      img: data?['img'],
      type: data?['type'],
      user: (data?['user'] != null) ? data!['user'].id : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (img != null) data['img'] = img;
    if (type != null) data['type'] = type;
    if (user != null) {
      data['user'] = FirebaseFirestore.instance.doc("user/$user");
    }

    return data;
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (img != null) "img": img,
      if (type != null) "type": type,
      if (user != null) "user": FirebaseFirestore.instance.doc("user/$user"),
    };
  }
}
