import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:g2g/model/feedback.dart';

final feedbacks = FirebaseFirestore.instance.collection("feedback");

/// Fonction qui retourne un feedback selon son [documentId]
Future<Feedback> getFeedback(String documentId) async {
  final snapshot = await feedbacks.doc(documentId).get();
  // verif si le doc exsite
  if (snapshot.data() == null) {
    throw Exception("Feedback non trouvé");
  }
  // retourne le feedback
  Feedback feedback = Feedback.fromJson(snapshot.data()!);
  feedback.uid = documentId;
  return feedback;
}

/// Fonction qui ajoute un feedback à la bdd
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

/// Fonction qui met à jour un feedback
Future<void> updateFeedback(Feedback feedback) async {
  try {
    await feedbacks.doc(feedback.uid).update(feedback.toFirestore());
  } on Exception catch (e) {
    throw Exception("Erreur lors de la modification : $e");
  }
}

/// Fonction qui supprime un feedback
Future<void> deleteFeedback(String docId) async {
  try {
    await feedbacks.doc(docId).delete();
  } on Exception catch (e) {
    throw Exception("Erreur lors de la suppressions : $e");
  }
}
