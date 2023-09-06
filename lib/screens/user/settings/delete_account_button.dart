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
        onPressed: () async {
          String authIdToBeDeleted = FirebaseAuth.instance.currentUser!.uid;
          await deleteUser(authIdToBeDeleted);
          try {
            await FirebaseAuth.instance.currentUser!.delete();
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        e.toString())),
              );
            }
          }
          //FirebaseAuth.instance.userChanges();
          if (context.mounted) {
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        },
        child: const Text("Delete my account"));
  }
}
