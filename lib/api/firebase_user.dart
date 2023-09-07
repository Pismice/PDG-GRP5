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
Future<void> updateUser(User user) async {
  try {
    await users.doc(user.uid).update(user.toFirestore());
  } on Exception catch (e) {
    throw Exception("Erreur lors de la modification : $e");
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

/// retourne le nombre d'heure passé à la salle
Future<String> getHoursSpentInGym(String authid) async {
  DocumentReference ref = await users
      .where('authid', isEqualTo: authid)
      .get()
      .then((value) => users.doc(value.docs[0].id));
  int totalMinutesSpent = 0;
  List<dynamic> sess;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;
  // recupère les workouts du user
  docs = await FirebaseFirestore.instance
          .collection('workout')
          .where('user', isEqualTo: ref)
          .get()
          .then((value) => value.docs)
      /*.catchError((error) =>
            developer.log("Something went wrong : ${error.toString()}"))*/
      ;
  // pour chaque séance de workout on calcul la durée
  for (var doc in docs) {
    sess = doc.data()['sessions'];
    for (int i = 0; i < sess.length; ++i) {
      if (sess[i]['start'] != null && sess[i]['end'] != null) {
        totalMinutesSpent +=
            DateTime.fromMillisecondsSinceEpoch(sess[i]['end'].seconds * 1000)
                .difference(DateTime.fromMillisecondsSinceEpoch(
                    sess[i]['start'].seconds * 1000))
                .inMinutes;
      }
    }
  }

  // si il a passé plus d'une heure
  if (totalMinutesSpent >= 60) {
    // retourne l'affichange avec heure et minute
    return "${(totalMinutesSpent / 60).floor()}h ${totalMinutesSpent % 60}";
  }
  // sinon on retourne l'affichage avec les minutes
  return "${totalMinutesSpent}m";
}

/// Fonction qui retourne le poids total
Future<double> getTotalWeightPushed(String authid) async {
  DocumentReference ref = await users
      .where('authid', isEqualTo: authid)
      .get()
      .then((value) => users.doc(value.docs[0].id));
  double totalWeight = 0;
  List<dynamic> sess;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;
  // recup les workouts de l'utilisateur
  docs = await FirebaseFirestore.instance
          .collection('workout')
          .where('user', isEqualTo: ref)
          .get()
          .then((value) => value.docs)
      /*.catchError((error) =>
            developer.log("Something went wrong : ${error.toString()}"))*/
      ;
  // pour chaque exercice fait dans les séance des workout on cumul le poids poussé
  for (var doc in docs) {
    sess = doc.data()['sessions'];
    for (int i = 0; i < sess.length; ++i) {
      for (int j = 0; j < sess[i]['exercises'].length; ++j) {
        for (int k = 0; k < sess[i]['exercises'][j]['sets'].length; ++k) {
          if (sess[i]['exercises'][j]['sets'][k]['repetition'] != null &&
              sess[i]['exercises'][j]['sets'][k]['weight'] != null) {
            totalWeight += sess[i]['exercises'][j]['sets'][k]['repetition'] *
                sess[i]['exercises'][j]['sets'][k]['weight'];
          }
        }
      }
    }
  }
  return totalWeight;
}

 /// Fonction qui retourne le nombre de séance finie
  Future<int> getNumberSessionDone(String authid) async {
    DocumentReference ref = await users
      .where('authid', isEqualTo: authid)
      .get()
      .then((value) => users.doc(value.docs[0].id));
    int numbers = 0;
    List<dynamic> sess;
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;
    docs = await FirebaseFirestore.instance
            .collection('workout')
            .where('user', isEqualTo: ref)
            .get()
            .then((value) => value.docs)
        /*.catchError((error) =>
            developer.log("Something went wrong : ${error.toString()}"),)*/
        ;

    for (var doc in docs) {
      sess = doc.data()['sessions'];
      for (int i = 0; i < sess.length; ++i) {
        if (sess[i]['start'] != null && sess[i]['end'] != null) {
          numbers++;
        }
      }
    }
    return numbers;
  }
