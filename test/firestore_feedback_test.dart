import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_models/feedback.dart';

final instance = FakeFirebaseFirestore();

final feedbacks = instance.collection("feedback");
final users = instance.collection("user");

Future<DocumentReference<Map<String, dynamic>>> getUserReference(
    String authid) async {
  return await users
      .where('authid', isEqualTo: authid)
      .limit(1)
      .get()
      .then((value) => users.doc(value.docs[0].id));
}

Future<Feedback> getFeedback(String documentId) async {
  final snapshot = await feedbacks.doc(documentId).get();
  if (snapshot.data() == null) {
    throw Exception("Feedback non trouvé");
  }
  Feedback feedback = Feedback.fromJson(snapshot.data()!);
  feedback.uid = documentId;
  return feedback;
}

Future<void> addFeedback(Feedback feedback) async {
  try {
    await feedbacks
        .withConverter(
            fromFirestore: Feedback.fromFirestore,
            toFirestore: (Feedback exercise, options) => exercise.toFirestore())
        .doc(feedback.uid)
        .set(feedback);
  } on Exception catch (e) {
    throw Exception("Erreur lors de l'ajout : $e");
  }
}

Future<void> updateFeedback(Feedback feedback) async {
  try {
    await feedbacks.doc(feedback.uid).update(feedback.toFirestore());
  } on Exception catch (e) {
    throw Exception("Erreur lors de la modification : $e");
  }
}

Future<void> deleteFeedback(String docId) async {
  try {
    await feedbacks.doc(docId).delete();
  } on Exception catch (e) {
    throw Exception("Erreur lors de la suppressions : $e");
  }
}

Future<void> addUser() async {
  await users.add({
    'authid': 'hihihihihhi',
    'name': 'Bob',
  });
}

void main() async {
  await addUser();

  Feedback feedback = Feedback(
    uid: "salut",
    user: (await getUserReference("hihihihihhi")).id,
    title: "mon feedback",
    comment: "je suis pas content >:(",
  );

  test("addFeedback", () async {
    await addFeedback(feedback);

    final doc = await getFeedback(feedback.uid!);

    expect(doc.title, feedback.title);
    expect(doc.comment, feedback.comment);
  });

  test("updateFeedback", () async {
    await addFeedback(feedback);

    feedback.comment = "en fait si je suis content :)";

    await updateFeedback(feedback);
    final doc = await getFeedback(feedback.uid!);

    expect(doc.comment, "en fait si je suis content :)");
  });

  test("deleteFeedback", () async {
    await addFeedback(feedback);

    var doc = await feedbacks.doc(feedback.uid).get();
    expect(true, doc.exists);

    deleteFeedback(feedback.uid!);

    doc = await feedbacks.doc(feedback.uid!).get();
    expect(false, doc.exists);
  });
}
