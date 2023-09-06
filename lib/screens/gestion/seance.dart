import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_session.dart';
import 'package:g2g/model/session.dart';
import 'package:g2g/screens/gestion/affichage/affichage_seance.dart';
import 'package:g2g/screens/gestion/modification/editseance.dart';
import 'package:g2g/screens/gestion/creation/create_seance.dart';

void main() => runApp(const MySessionScreen());

class MySessionScreen extends StatefulWidget {
  const MySessionScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MySessionPageState createState() => _MySessionPageState();
}

class _MySessionPageState extends State<MySessionScreen> {
  TextEditingController editingController = TextEditingController();

  List<Session>? sessions = [];
  var items = <Session>[];
  bool queryEmpty = true;

  @override
  void initState() {
    items = sessions!;
    super.initState();
  }

  void filterSearchResults(String query) {
    queryEmpty = query.isEmpty;
    setState(() {
      items = sessions!
          .where(
              (item) => item.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getAllSessionsFrom(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            sessions = snapshot.data;
            if (sessions!.isEmpty) {
              return const Text("Aucune session crée");
            }
            if (items.isEmpty && queryEmpty) {
              items = sessions!;
            }
            return Column(
              children: <Widget>[
                Row(children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextField(
                      onChanged: (value) {
                        filterSearchResults(value);
                      },
                      controller: editingController,
                      decoration: const InputDecoration(
                          labelText: "Recherche",
                          hintText: "Mon Workout",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)))),
                    ),
                  )),
                  Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: IconButton(
                            icon: const Icon(Icons.add),
                            color: Colors.black,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MyCreateSeance()));
                            },
                          ))),
                ]),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final Session session = items[index];
                      return ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MySeanceInfoPage(session)),
                          );
                        },
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all(Colors.black),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            overlayColor: MaterialStateProperty.all(
                                Colors.grey.shade100)),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(child: Text(items[index].name!)),
                                Expanded(
                                    child: Text(
                                        '${items[index].exercises!.length} exercices')),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    icon: const Icon(Icons.edit),
                                    padding: const EdgeInsets.all(0),
                                    color: Colors.black,
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MyEditSeancePage(session),
                                          maintainState: false,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const Text("");
        });
  }
}
