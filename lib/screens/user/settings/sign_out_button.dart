import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Bouton pour se déconnecter
class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          FirebaseAuth.instance.userChanges();
          if (context.mounted) {
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        },
        child: const Text("Sign out"));
  }
}
