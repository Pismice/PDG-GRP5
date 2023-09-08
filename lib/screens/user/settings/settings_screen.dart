import 'package:flutter/material.dart';
import 'package:g2g/screens/user/settings/delete_account_button.dart';
import 'package:g2g/screens/user/settings/feedback_button.dart';
import 'package:g2g/screens/user/settings/sign_out_button.dart';

/// Page des paramètres
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: const Center(
        child: Column(
          children: [
            // Boutons des paramètres
            SignOutButton(),
            SizedBox(
              height: 10,
            ),
            DeleteAccountButton(),
            SizedBox(
              height: 10,
            ),
            FeedbackButton(),
            SizedBox(
              height: 10,
            ),
            Text("App version : 0.0.1"),
          ],
        ),
      ),
    );
  }
}
