import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:g2g/screens/user/other_stats/exercices_pr.dart';
import 'package:g2g/screens/user/other_stats/user_stats.dart';
import 'package:g2g/screens/user/settings/settings_screen.dart';
import 'package:g2g/back/retrieve_user_stat.dart';

class UserScreen extends StatelessWidget {
  final UserStatistics userStat =
      UserStatistics(FirebaseAuth.instance.currentUser!.uid);
  UserScreen({super.key});

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
            Column(
              children: [
                const Text("Séances terminées"),
                FutureBuilder(
                    future: userStat.getNumberSessionDone(),
                    builder: ((context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return Text(snapshot.data.toString());
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    })),
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              children: [
                const Text("Poids total soulevé"),
                FutureBuilder(
                    future: userStat.getTotalWeightPushed(),
                    builder: ((context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return Text("${snapshot.data}kg");
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    })),
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              children: [
                const Text("Temps passé à faire du sport"),
                FutureBuilder(
                    future: userStat.getHoursSpentInGym(),
                    builder: ((context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return Text(snapshot.data as String);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }))
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
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ExercicesPr()));
            },
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
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LineChartSample1()));
            },
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
