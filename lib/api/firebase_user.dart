import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:g2g/model/user.dart';

final users = FirebaseFirestore.instance.collection('user');
final exercise = FirebaseFirestore.instance.collection('exercise');
final session = FirebaseFirestore.instance.collection('session');
final workout = FirebaseFirestore.instance.collection('workout');

Future<User> getUser(String authid) async {
  final snapshot =
      await users.where('authid', isEqualTo: authid).limit(1).get();

  final data = snapshot.docs.map((e) => e.data()).first;
  return User.fromJson(data);
}

Future<void> deleteUser(String authid) async {
  DocumentReference ref = await users
      .where('authid', isEqualTo: authid)
      .get()
      .then((value) => users.doc(value.docs[0].id));
  List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = await exercise
      .where('user', isEqualTo: ref)
      .get()
      .then((value) => value.docs);

  docs.addAll(await session
      .where('user', isEqualTo: ref)
      .get()
      .then((value) => value.docs));

  docs.addAll(await workout
      .where('user', isEqualTo: ref)
      .get()
      .then((value) => value.docs));

  for (var doc in docs) {
    doc.reference.delete();
  }
  ref.delete();
}

void updateUser(User user) async {
  User storeUser = User.fromFirestore(
      await users
              .doc(user.uid)
              .get()
              .then((DocumentSnapshot snapshot) => snapshot)
          as DocumentSnapshot<Map<String, dynamic>>,
      null);
  if (user.profilepicture != storeUser.profilepicture) {
    users.doc(user.uid).set(user.toFirestore());
  }
}
