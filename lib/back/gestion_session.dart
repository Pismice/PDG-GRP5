import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:g2g/model/user.dart';
import 'package:g2g/model/session.dart';

final session = FirebaseFirestore.instance.collection('session');
final users = FirebaseFirestore.instance.collection('user');

Future<List<Session>> getAllSessionsFor(User user) async {
  List<Session> sessions = List.empty();
  var docs = await session
      .where('user', isEqualTo: users.doc(user.uid))
      .get()
      .then((value) => value.docs);
  for (var doc in docs) {
    Session temp = Session.fromJson(doc.data());
    temp.uid = doc.id;
    sessions.add(temp);
  }
  return sessions;
}
