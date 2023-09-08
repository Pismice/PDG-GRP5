import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_user.dart';

/// Bouton pour supprimer le compte utilisateur
class DeleteAccountButton extends StatelessWidget {
  const DeleteAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(Colors.red.shade900),
        ),
        onPressed: () async {
          String authIdToBeDeleted = FirebaseAuth.instance.currentUser!.uid;
          try {
            // Suppression de l'utilisateur connecté
            await FirebaseAuth.instance.currentUser!.delete();
            await deleteUser(authIdToBeDeleted);
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(e.toString())),
              );
            }
          }
          if (context.mounted) {
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        },
        child: const Text("Delete my account"));
  }
}
