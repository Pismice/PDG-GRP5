import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Page de connexion du compte par e-mail
class EmailSignInScreen extends StatefulWidget {
  const EmailSignInScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EmailSignInScreenState createState() => _EmailSignInScreenState();
}

class _EmailSignInScreenState extends State<EmailSignInScreen> {
  final _formKey = GlobalKey<FormState>();
  // Contrôleurs pour le formulaire
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool creationOk = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// Gère la connexion au compte avec l'[email] et le [password]
  Future<void> signInAndContinue(String email, String password) async {
    try {
      // Effectue la connexion à l'app
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseAuth.instance.authStateChanges();
    } on FirebaseAuthException catch (e) {
      creationOk = false;
      // Affichage des erreurs de connexion
      if (e.code == 'user-not-found') {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No user found for that email")),
          );
        }
      } else if (e.code == 'wrong-password') {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Wrong password provided for that user.")),
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
              // Email de l'utilisateur
              // ----------------------
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
              // Mot de passe de l'utilisateur
              // -----------------------------
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
              // Validation du formulaire
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final email = emailController.text;
                  final password = passwordController.text;
                  await signInAndContinue(email, password);
                  if (context.mounted && creationOk) {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }
                }
              },
              child: const Text('Sign in'),
            ),
          ],
        ),
      ),
    );
  }
}
