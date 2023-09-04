import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g2g/model/user.dart';

final instance = FakeFirebaseFirestore();
final users = instance.collection('user');
final exercise = instance.collection('exercise');
final session = instance.collection('session');
final workout = instance.collection('workout');

Future<DocumentReference<Map<String, dynamic>>> getReference(User u) async {
  return await users
      .where('authid', isEqualTo: u.authId)
      .limit(1)
      .get()
      .then((value) => users.doc(value.docs[0].id));
}

void deleteUser(String authid) async {
  DocumentReference ref = await users
      .where('authid', isEqualTo: authid)
      .get()
      .then((value) => users.doc(value.docs[0].id));
  List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = await exercise
      .where('user', isEqualTo: ref.id)
      .get()
      .then((value) => value.docs);
  docs.addAll(await session
      .where('user', isEqualTo: ref.id)
      .get()
      .then((value) => value.docs));

  docs.addAll(await workout
      .where('user', isEqualTo: ref.id)
      .get()
      .then((value) => value.docs));

  for (var doc in docs) {
    doc.reference.delete();
  }
  ref.delete();
}

void updateUser(User user) async {
  User storeUser = User.fromFirestore(
      await users.doc(user.uid).get().then((DocumentSnapshot snapshot) =>
          snapshot as DocumentSnapshot<Map<String, dynamic>>),
      null);
  if (user.profilepicture != storeUser.profilepicture) {
    users.doc(user.uid).set(user.toFirestore());
  }
}

void main() async {
  User u = User(authId: "1234", name: "Test");
  test('Test ajout utilisateur', () async {
    await users.add(u.toFirestore());
    Map<String, dynamic> doc = await users
        .where('authid', isEqualTo: u.authId)
        .limit(1)
        .get()
        .then((value) => value.docs[0].data());

    expect(doc['name'], u.name);
    expect(doc['authid'], u.authId);
  });

  test('Modification utilisateur', () async {
    u.uid = (await users.add(u.toFirestore())).id;
    u.profilepicture = "TEST2";
    updateUser(u);
    var data = await users
        .doc((await getReference(u)).id)
        .get()
        .then((value) => value.data());
    expect(data!['profilepicture'], "TEST2");
  });

  /*test('Test suppression utilisateur', () async {
    u.uid = (await users.add(u.toFirestore())).id;
    exercise.add(Exercice(name: "Exo1", user: u.uid).toFirestore());
    exercise.add(Exercice(name: "Exo2", user: u.uid).toFirestore());
    var temp = Session(name: "Sess1").toJson();
    temp.addEntries({MapEntry("user", u.uid)});
    session.add(temp);
    temp = Workout(name: "Work1").toJson();
    temp.addEntries({MapEntry('user', u.uid)});
    workout.add(temp);
    deleteUser(u.authId as String);
    expect(
        await users
            .where('authid', isEqualTo: u.authId)
            .get()
            .then((value) => value.docs.length),
        0);
    expect(
        await session
            .where('user', isEqualTo: await getReference(u))
            .get()
            .then((value) => value.docs.length),
        0);
    expect(
        await workout
            .where('user', isEqualTo: await getReference(u))
            .get()
            .then((value) => value.docs.length),
        0);
  });*/
}
