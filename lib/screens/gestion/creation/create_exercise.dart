import 'package:flutter/material.dart';

class MyCreateExercice extends StatefulWidget {
  const MyCreateExercice({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyCreateExercice createState() => _MyCreateExercice();
}

class _MyCreateExercice extends State<MyCreateExercice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ElevatedButton(
                    onPressed: () {},
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.grey)),
                    child: const Text("change photo")),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Nom exercise',
                    ),
                  ),
                )
              ],
            )));
  }
}
