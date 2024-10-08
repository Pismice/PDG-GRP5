import 'package:flutter/material.dart';
import 'package:g2g/screens/gestion/workout.dart';
import 'package:g2g/screens/gestion/seance.dart';
import 'package:g2g/screens/gestion/exercice.dart';

void main() => runApp(const GestionScreen());

class GestionScreen extends StatelessWidget {
  const GestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyHomePage(title: 'My entities');
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  // ignore: library_private_types_in_public_api
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
    const MyWorkoutScreen(),
    const MySessionScreen(),
    const MyExerciceScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.playlist_add_check_sharp), label: 'Workouts'),
          NavigationDestination(
              icon: Icon(Icons.align_horizontal_left), label: 'Sessions'),
          NavigationDestination(
              icon: Icon(Icons.fitness_center), label: 'Exercises')
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
      ),
    );
  }
}
