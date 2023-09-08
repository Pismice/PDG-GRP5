import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_user.dart';

// Page pour se connecter par e-mail
class EmailSignUpScreen extends StatefulWidget {
  const EmailSignUpScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EmailSignUpScreenState createState() => _EmailSignUpScreenState();
}

class _EmailSignUpScreenState extends State<EmailSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool creationOk = true;
  // Contrôleurs pour le formulaire
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// Gère la création du compte avec l'[email] et le [password]
  Future<void> signUpAndContinue(String email, String password,
      [String? username]) async {
    try {
      // Création du compte utilisateur
      Future<UserCredential> credential =
          FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.then((value) async => {
            // Si l'utilisateur lié à ce Firebase Auth User
            // n'existe pas dans la BD Firestore il faut le créer
            if (await FirebaseFirestore.instance
                    .collection('user')
                    .where('authid', isEqualTo: value.user!.uid)
                    .limit(1)
                    .get()
                    .then((value) => value.docs.length) ==
                0)
              {
                await addNewEmailUserToFirestore(value, username),
              }
          });
    } on FirebaseAuthException catch (e) {
      creationOk = false;
      // Affichage des erreurs lors de la création du compte
      if (e.code == 'weak-password') {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Password is too weak")),
          );
        }
      } else if (e.code == 'email-already-in-use') {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("The account already exists for that email.")),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              // Champ pour donner le nom d'utilisateur
              // --------------------------------------
              controller: usernameController,
              validator: (value) {
                if (value!.length < 3) {
                  return "Username must be at least 3 characters long";
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Username',
                icon: Icon(Icons.person),
              ),
            ),
            TextFormField(
              // Champ pour donner l'email
              // -------------------------
              controller: emailController,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please type an email address";
                } else if (!EmailValidator.validate(value)) {
                  return "Please enter a valid email address";
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Email address',
                icon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            TextFormField(
              // Champ pour donner le mot de passe
              // ---------------------------------
              controller: passwordController,
              validator: (value) {
                if (value!.length < 4) {
                  return "Password must be at least 4 characters long";
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Password',
                icon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            ElevatedButton(
              // Bouton de validation du formulaire
              // ----------------------------------
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final username = usernameController.text;
                  final email = emailController.text;
                  final password = passwordController.text;
                  await signUpAndContinue(email, password, username);
                  if (context.mounted && creationOk) {
                    FirebaseAuth.instance.authStateChanges();
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }
                }
              },
              child: const Text('Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
