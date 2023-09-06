import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:g2g/api/firebase_user.dart';
import 'package:g2g/screens/introduction/user_connection/email_sign_in_screen.dart';
import 'package:g2g/screens/introduction/user_connection/email_sign_up_screen.dart';

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
          {await addNewGoogleUserToFirestore(value)}
      });
  return out;
}

class ConnectionChoicesScreen extends StatelessWidget {
  const ConnectionChoicesScreen({super.key});
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
                  Text(
                      'Sign In with Google (only working on web platforms for now)'),
                ],
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EmailSignUpScreen()));
              },
              child: const Row(
                children: [
                  Image(
                    image: AssetImage("ressources/email.png"),
                    height: 20,
                    width: 20,
                  ),
                  SizedBox(
                    height: 10,
                    width: 10,
                  ),
                  Text('Sign Up with Email'),
                ],
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EmailSignInScreen()));
              },
              child: const Row(
                children: [
                  Image(
                    image: AssetImage("ressources/email.png"),
                    height: 20,
                    width: 20,
                  ),
                  SizedBox(
                    height: 10,
                    width: 10,
                  ),
                  Text('Sign In with Email'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
