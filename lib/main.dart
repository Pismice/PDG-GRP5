import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:g2g/screens/introduction/presentation.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/navigation_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialisation de Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /*if (kDebugMode) {
    // Utilisation des émulateurs pour éviter les couts innatendus
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  }*/

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
      title: 'Gym2Golem',
      theme: ThemeData(
        textTheme: const TextTheme(
          displayLarge:
              TextStyle(fontSize: 24, fontWeight: FontWeight.bold), 
        ),
        brightness: Brightness.dark,
        primaryColor: const Color.fromARGB(255, 7, 3, 58),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
           const EdgeInsets.all(16), // Add this line for padding
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              side: const BorderSide(color: Colors.black, width: 1),
              borderRadius:
                  BorderRadius.circular(0), // Set radius to 0 for sharp corners
            ),
          ),
        )),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final user = snapshot.data;
          if (user == null) {
            return const AppPresentationScreen();
          } else {
            return const MyNavigationBar();
          }
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gym de Golem'),
      ),
    );
  }
}
