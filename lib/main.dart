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

  // Lancer l'app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym2Golem',
      theme: ThemeData(
        // Le thème de l'application
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
        // Gestion de la page à afficher si l'utilsateur est connecté ou non
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          final user = snapshot.data;
          if (user == null) {
            // S'il n'est pas connecté, on le met sur la page de login
            return const AppPresentationScreen();
          } else {
            // sinon sur la page principale
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
