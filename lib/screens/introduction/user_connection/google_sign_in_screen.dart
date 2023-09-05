import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<UserCredential> signInWithGoogle() async {
  // Create a new provider
  GoogleAuthProvider googleProvider = GoogleAuthProvider();

  googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
  googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

  // Once signed in, return the UserCredential
  Future<UserCredential> out =
      FirebaseAuth.instance.signInWithPopup(googleProvider);
  out.then((value) async => {
        if (await FirebaseFirestore.instance
                .collection('user')
                .where('authid', isEqualTo: value.user!.uid)
                .limit(1)
                .get()
                .then((value) => value.docs.length) ==
            0)
          {await addNewUserToFirestore(value)}
      });
  return out;
}

Future<void> addNewUserToFirestore(UserCredential user) {
  return FirebaseFirestore.instance.collection('user').add(<String, String>{
    'authid': user.user!.uid,
    'name': user.user!.displayName.toString(),
    'profilepicture': user.user!.photoURL.toString(),
  });
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
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
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
