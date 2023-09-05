import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          FirebaseAuth.instance.userChanges();
          if (context.mounted) {
            Navigator.pop(context);
          }
        },
        child: const Text("Sign out"));
  }
}
