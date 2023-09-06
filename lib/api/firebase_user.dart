import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:g2g/model/user.dart';

final users = FirebaseFirestore.instance.collection('user');
final exercise = FirebaseFirestore.instance.collection('exercise');
final session = FirebaseFirestore.instance.collection('session');
final workout = FirebaseFirestore.instance.collection('workout');

/// Fonction qui retourne l'utilisateur avec [authid]
/// comme identifiant d'authentification
Future<User> getUser(String authid) async {
  final snapshot =
      await users.where('authid', isEqualTo: authid).limit(1).get();

  final data = snapshot.docs.map((e) => e.data()).first;
  User user = User.fromJson(data);
  user.uid = snapshot.docs.first.id;
  return user;
}

/// Fonction qui supprime l'utilisateur avec [authid]
/// comme identifiant d'authentification
Future<void> deleteUser(String authid) async {
  DocumentReference ref = await users
      .where('authid', isEqualTo: authid)
      .get()
      .then((value) => users.doc(value.docs[0].id));
  // recupère les document exercice qui ont été crée par l'utilisateur
  List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = await exercise
      .where('user', isEqualTo: ref)
      .get()
      .then((value) => value.docs);
  // récupère les document séance qui ont été crée par l'utilisateur
  docs.addAll(await session
      .where('user', isEqualTo: ref)
      .get()
      .then((value) => value.docs));
  // récupère les document qui ont été crée par l'utilisateur
  docs.addAll(await workout
      .where('user', isEqualTo: ref)
      .get()
      .then((value) => value.docs));
  // supprime tous les doc qui ont été crée par l'utilisateur
  for (var doc in docs) {
    doc.reference.delete();
  }
  // supprime l'utilisateur
  ref.delete();
}

/// Fonction qui mets à jour un [user]
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

/// Fonction qui ajout un nouveau utilisateur venant de google
Future<void> addNewGoogleUserToFirestore(UserCredential user) {
  return FirebaseFirestore.instance.collection('user').add(<String, String>{
    'authid': user.user!.uid,
    'name': user.user!.displayName.toString(),
    'profilepicture': user.user!.photoURL.toString(),
  });
}

/// Fonction qui ajoute un nouveau user depuis un mail
Future<void> addNewEmailUserToFirestore(UserCredential user,
    [String? username]) {
  return FirebaseFirestore.instance.collection('user').add(<String, String>{
    'authid': user.user!.uid,
    'name': username ?? 'null',
  });
}
