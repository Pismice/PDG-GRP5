import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<UserCredential> signInWithGoogle() async {
  // Create a new provider
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
        title: Text('Google Sign-In'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () async {
            try {
              await signInWithGoogle();
              print('Google sign-in successful');
              // Navigate to another screen or perform desired action
            } catch (e) {
              print('Error signing in with Google: $e');
              // Handle the error as needed
            }
          },
          child: Text('Sign In with Google'),
        ),
      ),
    );
  }
}
