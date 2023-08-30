import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        },
        child: const Text("sign out"));
  }
}
