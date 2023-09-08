import 'package:flutter/material.dart';
import 'package:g2g/screens/user/settings/feedback_screen.dart';

/// Bouton pour ouvrir la page du feedback
class FeedbackButton extends StatelessWidget {
  const FeedbackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MyFeedbackForm(),
          ),
        );
      },
      child: const Text("Report a bug or give us a feedack"),
    );
  }
}
