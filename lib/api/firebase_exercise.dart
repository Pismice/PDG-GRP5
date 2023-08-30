// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class GetExercise extends StatelessWidget {
  final String documentId;

  const GetExercise(this.documentId, {super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference exercises =
        FirebaseFirestore.instance.collection('exercise');

    return FutureBuilder<DocumentSnapshot>(
      future: exercises.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Quelque chose n'a pas fonctionné");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Le document n'existe pas");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return Column(children: [
            image(data),
            Text("Nom de l'exercice: ${data['name']}")
          ]);
        }

        return const Text("Chargement");
      },
    );
  }

  Widget image(Map<String, dynamic> data) {
    return FutureBuilder(
      future: FirebaseStorage.instance
          .refFromURL('gs://hongym-4cb68.appspot.com')
          .child("img/exercises/${data['img']}")
          .getDownloadURL(),
      builder: (context, snapshot) {
        return Image.network(
          snapshot.data.toString(),
          height: 100,
          width: 100,
        );
      },
    );
  }
}

CollectionReference exercises =
    FirebaseFirestore.instance.collection('exercise');

Future<void> addExercise(String name) async {
  return exercises
      .add({'name': name, 'img': ''})
      .then((_) => print("exercice ajouté"))
      .catchError(
          (error) => print("L'exercice n'a pas pu être ajouté : $error"));
}

Future<void> updateExercise(String docId, String newName) async {
  return exercises
      .doc(docId)
      .update({'name': newName})
      .then((_) => print("modification effectuée"))
      .catchError((error) => print('Erreur : $error'));
}
