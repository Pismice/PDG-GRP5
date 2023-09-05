import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_user.dart';

class DeleteAccountButton extends StatelessWidget {
  const DeleteAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(Colors.red.shade900),
        ),
        onPressed: () {
          String authIdToBeDeleted = FirebaseAuth.instance.currentUser!.uid;
          //FirebaseAuth.instance.signOut();
          deleteUser(authIdToBeDeleted);
          //FirebaseAuth.instance.userChanges();
          Navigator.pop(context);
        },
        child: const Text("Delete my account"));
  }
}
