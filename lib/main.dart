import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'navigation_bar.dart';
import 'screens/user_connection/google_sign_in_screen.dart';

void main() async {
  // Initialisation de Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web,
  );

  // Vérification que l'utilisateur est toujours connecté
  FirebaseAuth.instance.authStateChanges().listen((User? u) {
    if (u == null) {
      //print('User is currently signed out!');
    } else {
      //print('User is signed in!');
    }
  });

  // Lancer l'app
  //final db = FirebaseFirestore.instance;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.purple,
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          final user = snapshot.data;
          if (user == null) {
            return const GoogleSignInScreen();
          } else {
            return const MyNavigationBar();
          }
        },
      ),
    );
  }
}
