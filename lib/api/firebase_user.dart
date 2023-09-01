import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:g2g/model/user.dart';

final users = FirebaseFirestore.instance.collection('user');

Future<User> getUser(String authid) async {
  final snapshot =
      await users.where('authid', isEqualTo: authid).limit(1).get();

  final data = snapshot.docs.map((e) => e.data()).first;
  return User.fromJson(data);
}
