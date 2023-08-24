import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'front/user_connection/google_sign_in_screen.dart';

void main() async {
  // Initialisation de Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web,
  );

  if (kDebugMode) {
    // Utilisation des émulateurs pour éviter les couts innatendus
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 9098);
  }

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
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
            return Text(
                'pr: Bienvenue sur Gym on ${FirebaseAuth.instance.currentUser?.displayName ?? "Guest"} :)');
          }
        },
      ),
    );
  }
}
