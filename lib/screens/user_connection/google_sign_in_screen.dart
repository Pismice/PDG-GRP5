import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<UserCredential> signInWithGoogle() async {
  // Create a new provider
  GoogleAuthProvider googleProvider = GoogleAuthProvider();

  googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
  googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

  // Once signed in, return the UserCredential
  Future<UserCredential> out =
      FirebaseAuth.instance.signInWithPopup(googleProvider);
  out.then((value) => {
        if (value.additionalUserInfo!.isNewUser) {addNewUserToFirestore(value)}
      });
  return out;
}

void addNewUserToFirestore(UserCredential user) {
  FirebaseFirestore db = FirebaseFirestore.instance;

  db.collection('user').add({
    "UID": user.user!.uid,
    "name": user.user!.displayName,
    "profilepicture": user.user!.photoURL,
    "username": user.additionalUserInfo!.username
  });
}

class GoogleSignInScreen extends StatelessWidget {
  const GoogleSignInScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Sign-In'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () async {
            try {
              await signInWithGoogle();
              // Google connection success: Navigate to another screen or perform desired action
            } catch (e) {
              // Error: Handle the error as needed
            }
          },
          child: const Text('Sign In with Google'),
        ),
      ),
    );
  }
}
