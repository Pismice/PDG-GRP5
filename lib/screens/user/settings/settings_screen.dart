import 'package:flutter/material.dart';
import 'package:g2g/screens/user/settings/sign_out_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: const Column(
        children: [
          Text("bla bla mes options"),
          SignOutButton(),
        ],
      ),
    );
  }
}
