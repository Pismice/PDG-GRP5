import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_user.dart';
import 'package:g2g/api/firebase_workout.dart';
import 'package:g2g/model/user.dart';

class AvailableWorkouts extends StatefulWidget {
  const AvailableWorkouts({super.key});

  @override
  State<AvailableWorkouts> createState() => _AvailableWorkoutsState();
}

class _AvailableWorkoutsState extends State<AvailableWorkouts> {
  User user = User();

  @override
  void initState() {
    super.initState();
    getUser(FirebaseAuth.instance.currentUser!.uid)
        .then((value) => user = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Choose a new workout to begin"),
        ),
        body: FutureBuilder(
          future: getAllWorkoutsFrom(uid: user.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ElevatedButton(
                      onPressed: () {
                        snapshot.data![index].week = weekNumber(DateTime.now());
                        updateWorkout(snapshot.data![index]);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("New active workout !")),
                        );
                        Navigator.pop(context);
                      },
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  snapshot.data![index].name!,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Row(
                              children: <Widget>[
                                const Icon(Icons.repeat),
                                Expanded(
                                  child: Text(
                                      '${snapshot.data![index].duration} weeks'),
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                      '${snapshot.data![index].sessions!.length} sessions a week'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
              return const Text(
                  "You dont have any workout available, create a new one");
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return const CircularProgressIndicator();
            }
          },
        ));
  }
}
