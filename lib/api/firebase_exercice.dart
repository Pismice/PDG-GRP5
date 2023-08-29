import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class GetExercice extends StatelessWidget {
  final String documentId;

  const GetExercice(this.documentId, {super.key});

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
            Image.network(
              data['img'],
              height: 100,
              width: 100,
            ),
            Text("Nom de l'exercice: ${data['name']}")
          ]);
        }

        return const Text("Chargement");
      },
    );
  }
}
