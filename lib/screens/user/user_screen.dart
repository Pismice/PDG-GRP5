import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:g2g/screens/user/settings/settings_screen.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ici il faudra mettra son pseudo"),
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
            const Column(
              children: [
                Text("Séances terminées"),
                Text("0"),
              ],
            ),
            const Column(
              children: [
                Text("Poids total soulevé"),
                Text("0 kg"),
              ],
            ),
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(border: Border.all(color: Colors.purple)),
          child: const Text("Tous mes PR"),
        ),
        const Text("autres"),
      ]),
    );
  }
}
