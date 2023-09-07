import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_user.dart';
import 'package:g2g/model/user.dart';
import 'package:g2g/screens/user/edit_profile_screen.dart';
import 'package:g2g/screens/user/other_stats/exercices_pr.dart';
import 'package:g2g/screens/user/settings/settings_screen.dart';
import 'package:g2g/back/retrieve_user_stat.dart';

class UserScreen extends StatelessWidget {
  final UserStatistics userStat =
      UserStatistics(FirebaseAuth.instance.currentUser!.uid);

  UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUser(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('user')
                        .doc(userSnapshot.data!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      const String defaultName = "Random golem";
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.hasData) {
                          var userData =
                              snapshot.data!.data() as Map<String, dynamic>;
                          User currentUser = User.fromJson(userData);
                          return Text(currentUser.name ?? defaultName);
                        }
                        return const Text(defaultName);
                      } else if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }),
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
                    const SizedBox(
                      width: 10,
                    ),
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
                    Wrap(
                      children: [
                        Column(
                          children: [
                            const Text("Finished sessions",
                                style: TextStyle(fontSize: 10)),
                            FutureBuilder(
                                future: userStat.getNumberSessionDone(),
                                builder: ((context, snapshot) {
                                  int value = 0;
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasData) {
                                      value = snapshot.data!;
                                    }
                                    return Text(value.toString());
                                  } else {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                })),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: [
                            const Text("Total lifted weight",
                                style: TextStyle(fontSize: 10)),
                            FutureBuilder(
                                future: userStat.getTotalWeightPushed(),
                                builder: ((context, snapshot) {
                                  double value = 0;
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasData) {
                                      value = snapshot.data!;
                                    }
                                    return Text("$value kg");
                                  } else {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                })),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: [
                            const Text("Time spent doing sport",
                                style: TextStyle(fontSize: 10)),
                            FutureBuilder(
                                future: userStat.getHoursSpentInGym(),
                                builder: ((context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (!snapshot.hasData) {
                                      return const Text("-");
                                    }
                                    return Text(snapshot.data as String);
                                  } else {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                }))
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const EditProfile();
                            },
                          ));
                        },
                        child: const Text("Edit Profile")),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ExercicesPr()));
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
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
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
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
