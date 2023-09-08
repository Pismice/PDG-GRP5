import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_user.dart';
import 'package:g2g/model/user.dart';

/// Page pour éditer le profil utilisateur
class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modify user informations"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              // Champ pour modifier le nom utilisateur
              // --------------------------------------
              controller: _username,
              decoration: const InputDecoration(
                  hintText: "My new username", labelText: "Username"),
              maxLength: 30,
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 4) {
                  return "Username must be at least 4 characters";
                }
                return null;
              },
            ),
            ElevatedButton(
              // Bouton pour valider la modification
              // -----------------------------------
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    User currentUser =
                        await getUser(FirebaseAuth.instance.currentUser!.uid);
                    currentUser.name = _username.text;
                    await updateUser(currentUser);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  }
                }
              },
              child: const Text("Update profile infos"),
            )
          ],
        ),
      ),
    );
  }
}
