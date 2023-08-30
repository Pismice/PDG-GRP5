import 'package:flutter/material.dart';
import 'package:g2g/screens/gestion/workout.dart';
import 'package:g2g/screens/gestion/seance.dart';
import 'package:g2g/screens/gestion/exercice.dart';

void main() => runApp(GestionScreen());

class GestionScreen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Entrainements'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    MyWorkoutScreen(),
    MySessionScreen(),
    MyExerciceScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: NavigationBar(
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.playlist_add_check_sharp), label: 'Workout'),
            NavigationDestination(
                icon: Icon(Icons.align_horizontal_left), label: 'Seance'),
            NavigationDestination(
                icon: Icon(Icons.fitness_center), label: 'Exercice')
          ],
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
        ),
      ),
    );
  }
}
