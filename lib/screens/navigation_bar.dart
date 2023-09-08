import 'package:flutter/material.dart';
import 'package:g2g/screens/home_screen/home_screen.dart';
import 'package:g2g/screens/user/user_screen.dart';
import 'gestion/gestion_screen.dart';

/// Barre de navigation de l'application
class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({super.key});

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  int _selectedIndex = 0;
  // Liste des trois page à amener en utilisant le menu
  static final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    const GestionScreen(),
    const UserScreen(),
  ];

  // Gestion lorsque l'on appuie sur un élément du menu
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // Mise en palce de la barre de navigation
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Organize',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
