import 'package:flutter/material.dart';

class MyEditExoPage extends StatefulWidget {
  const MyEditExoPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyEditExoPage createState() => _MyEditExoPage();
}

class _MyEditExoPage extends State<MyEditExoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'assets/images/cervin.jpg',
                      height: 75,
                      width: 75,
                    )),
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
                      hintText: 'Enter a search term',
                    ),
                  ),
                )
              ],
            )));
  }
}
