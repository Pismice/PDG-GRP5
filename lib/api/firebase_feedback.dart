import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:g2g/model/feedback.dart';

final feedbacks = FirebaseFirestore.instance.collection("feedback");

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
        .doc()
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
