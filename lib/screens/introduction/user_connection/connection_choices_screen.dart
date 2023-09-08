import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:g2g/api/firebase_user.dart';
import 'package:g2g/screens/introduction/user_connection/email_sign_in_screen.dart';
import 'package:g2g/screens/introduction/user_connection/email_sign_up_screen.dart';

/// Connexion à l'app avec Google
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

/// Page pour choisir quel mode de connexion utiliser
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
              // Connexion avec Google
              // ---------------------
              onPressed: () async {
                await signInWithGoogle();
                // Google connection success: Navigate to another screen or perform desired action
                if (context.mounted) {
                  Navigator.pop(context);
                }
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
                  Text('Sign In with Google (web only)'),
                ],
              ),
            ),
            TextButton(
              // Création d'un compte et connexion par e-mail
              // --------------------------------------------
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
              // Connexion par e-mail
              // --------------------
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
