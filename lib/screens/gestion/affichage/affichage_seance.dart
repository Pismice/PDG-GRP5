import 'package:flutter/material.dart';
import 'package:g2g/screens/gestion/modification/editseance.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Workout Info',
    //theme: ThemeData(primarySwatch: Colors.blue),
    home: MySeanceInfoPage(),
  ));
}

class MySeanceInfoPage extends StatefulWidget {
  const MySeanceInfoPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MySeanceInfoPage createState() => _MySeanceInfoPage();
}

class _MySeanceInfoPage extends State<MySeanceInfoPage> {
  final items = List<String>.generate(4, (i) => "Exo $i");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Séance X"),
        ),
        body: Column(children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      overlayColor:
                          MaterialStateProperty.all(Colors.grey.shade100)),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(children: [
                      Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Image.asset(
                                'assets/images/cervin.jpg',
                                height: 75,
                                width: 75,
                              ))),
                      Expanded(child: Text(items[index])),
                      Text('${4 - index} x ${(index + 1) * 3}'),
                    ]),
                  ));
            },
          ),
          Row(children: [
            Expanded(
                child:
                    IconButton(onPressed: () {}, icon: const Icon(Icons.add))),
            Expanded(
                child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyEditSeancePage()));
                    },
                    icon: const Icon(Icons.edit))),
            Expanded(
                child: IconButton(
                    onPressed: () {}, icon: const Icon(Icons.delete)))
          ])
        ]));
  }
}
