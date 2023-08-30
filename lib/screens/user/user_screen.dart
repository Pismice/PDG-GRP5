import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:g2g/screens/user/settings/settings_screen.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            FirebaseAuth.instance.currentUser?.displayName ?? "Random golem"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()));
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(children: [
        Row(
          children: [
            GestureDetector(
                onTap: () {
                  // il faudra peut etre changer la PP
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(FirebaseAuth
                          .instance.currentUser?.photoURL ??
                      'https://static.wikia.nocookie.net/clashofclans/images/4/44/Avatar_Golem.png'),
                )),
            const SizedBox(
              width: 10,
            ),
            const Column(
              children: [
                Text("Séances terminées"),
                Text("0"),
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            const Column(
              children: [
                Text("Poids total soulevé"),
                Text("0 kg"),
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            const Column(
              children: [
                Text("Temps passé à faire du sport"),
                Text("0 min"),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            ElevatedButton(onPressed: () {}, child: const Text("Edit Profile")),
            ElevatedButton(
                onPressed: () {}, child: const Text("Share Profile")),
            IconButton.filled(
                onPressed: () {}, icon: const Icon(Icons.person_add))
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: ElevatedButton(
            onPressed: () {},
            child: const Row(
              children: [
                Icon(Icons.workspace_premium),
                Text("Les PR de mes exercices"),
              ],
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: ElevatedButton(
            onPressed: () {/* https://pub.dev/packages/fl_chart*/},
            child: const Row(
              children: [
                Icon(Icons.trending_up),
                Text("Mon evolution"),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
