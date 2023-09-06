import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_exercise.dart';
import 'package:g2g/api/firebase_session.dart';
import 'package:g2g/api/firebase_workout.dart';
import 'package:g2g/screens/gestion/affichage/affichage_workout.dart';
import 'package:g2g/back/retrieve_user_stat.dart';

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final workouts = getAllActiveWorkoutFrom();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: FutureBuilder(
        future: getWeightEvolution("6Rl2uzhZnOnHyODT26KR"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return Text(snapshot.data!.toString());
          }
          return const Center(child: CircularProgressIndicator());
        },
      )),
    );
  }
}
