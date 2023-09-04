import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g2g/model/user.dart';
import 'package:g2g/api/firebase_user.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  User u = User(authId: "1234", name: "Test");
  var users = FirebaseFirestore.instance.collection('user');
  var session = FirebaseFirestore.instance.collection('session');
  var workout = FirebaseFirestore.instance.collection('workout');
  DocumentReference ref = users.add(u.toFirestore()) as DocumentReference;
  u.uid = ref.id;
  test('Test ajout utilisateur', () async {
    Map<String, dynamic> doc = users
        .where('authId', isEqualTo: u.authId)
        .limit(1)
        .get()
        .then((value) => value.docs[0].data()) as Map<String, dynamic>;

    expect(doc['name'], u.name);
  });

  test('Modification utilisateur', () async {
    u.profilepicture = "TEST2";
    updateUser(u);
    expect(
        users.doc(u.uid).get().then((value) => value.data()!['profilepicture']),
        "TEST2");
  });

  test('Test suppression utilisateur', () async {
    deleteUser(u.authId as String);

    expect(
        users
            .where('authId', isEqualTo: u.authId)
            .get()
            .then((value) => value.docs.length),
        0);
    expect(
        session
            .where('user', isEqualTo: ref)
            .get()
            .then((value) => value.docs.length),
        0);
    expect(
        workout
            .where('user', isEqualTo: ref)
            .get()
            .then((value) => value.docs.length),
        0);
  });
}
