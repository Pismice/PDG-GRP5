import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<UserCredential> signInWithGoogle() async {
  // Create a new provider
  // get: FirebaseAuth.instance.currentUser?.displayName
  GoogleAuthProvider googleProvider = GoogleAuthProvider();

  googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
  googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithPopup(googleProvider);
}

class GoogleSignInScreen extends StatelessWidget {
  const GoogleSignInScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In/Up'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text("Available sign-in/up methods:"),
            TextButton(
              onPressed: () async {
                await signInWithGoogle();
                // Google connection success: Navigate to another screen or perform desired action
              },
              child: const Row(
                children: [
                  Image(
                    image: AssetImage("ressources/google.png"),
                    height: 20,
                    width: 20,
                  ),
                  SizedBox(
                    height: 10,
                    width: 10,
                  ),
                  Text('Sign In with Google'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
