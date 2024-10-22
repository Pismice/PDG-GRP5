import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide Feedback;
import 'package:g2g/api/firebase_feedback.dart';
import 'package:g2g/api/firebase_user.dart';
import 'package:g2g/model/feedback.dart';

/// Formulaire pour remplir un feedback sur l'application
class MyFeedbackForm extends StatefulWidget {
  const MyFeedbackForm({super.key});

  @override
  MyFeedbackFormState createState() {
    return MyFeedbackFormState();
  }
}

/// State du formulaire
class MyFeedbackFormState extends State<MyFeedbackForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _comment = TextEditingController();
  final TextEditingController _title = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Submit a feedback or a bug"),
      ),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  // Champ pour donner le titre du feedback
                  // --------------------------------------
                  decoration: const InputDecoration(
                      hintText: "Title of my feedback", labelText: "Title"),
                  controller: _title,
                  maxLength: 30,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a title";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  // Champ pour remplir le corps du feedback
                  // ---------------------------------------
                  decoration: const InputDecoration(
                    hintText: "Content of my feedback ...",
                    labelText: "Content",
                  ),
                  controller: _comment,
                  maxLength: 300,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter some text";
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                    // Bouton pour envoyer le feedback
                    // -------------------------------
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Feedback feedback = Feedback(
                            comment: _comment.value.text,
                            title: _title.value.text,
                            user: await getUser(
                                    // L'utlisateur qui a posté le feedback
                                    FirebaseAuth.instance.currentUser!.uid)
                                .then((value) => value.uid));
                        await addFeedback(feedback);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                // Message de validation
                                content: Text(
                                    "Feedback ${feedback.title} submited. Thank you ! :)")),
                          );
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: const Text("Submit feedback or bug"))
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          const Text(
              "Writing a nice and productive feedback is going to help us change the app in order to best fit your needs :)"),
          const SizedBox(
            height: 300,
            child: Image(image: AssetImage("ressources/feedback.png")),
          )
        ],
      ),
    );
  }
}
