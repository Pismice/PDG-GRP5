import 'package:flutter/material.dart';

class FeedbackButton extends StatelessWidget {
  const FeedbackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {},
        child: const Text("Report a bug or give us a feedack"));
  }
}