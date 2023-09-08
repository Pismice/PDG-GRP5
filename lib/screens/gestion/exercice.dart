import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_exercise.dart';
/*import 'package:g2g/api/firebase_user.dart';*/
import 'package:g2g/model/exercise.dart';
import 'package:g2g/screens/gestion/modification/editexo.dart';
import 'package:g2g/screens/gestion/creation/create_exercise.dart';

void main() => runApp(const MyExerciceScreen());

/// Widget qui affiche les exercices
class MyExerciceScreen extends StatefulWidget {
  const MyExerciceScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyExerciceScreen createState() => _MyExerciceScreen();
}

class _MyExerciceScreen extends State<MyExerciceScreen> {
  TextEditingController editingController = TextEditingController();

  List<Exercise>? customExercises = [];
  var customItems = <Exercise>[];
  bool customQueryEmpty = true;

  List<Exercise>? defaultExercises = [];
  var defaultItems = <Exercise>[];
  bool defaultQueryEmpty = true;

  @override
  void initState() {
    customItems = customExercises!;
    defaultItems = defaultExercises!;
    super.initState();
  }

  // methode pour la bar de recherche
  void filterSearchResultsExercise(String query) {
    customQueryEmpty = query.isEmpty;
    defaultQueryEmpty = query.isEmpty;
    setState(() {
      customItems = customExercises!
          .where(
              (item) => item.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      defaultItems = defaultExercises!
          .where(
              (item) => item.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: <Widget>[
          // bar de recherche
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextField(
              onChanged: (value) {
                filterSearchResultsExercise(value);
              },
              controller: editingController,
              decoration: const InputDecoration(
                  labelText: "Search",
                  hintText: "My exercise",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
            ),
          )),
          // bouton de création
          Padding(
              padding: const EdgeInsets.only(right: 0),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyCreateExercice()));
                    },
                  ))),
        ]),
        const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(style: TextStyle(fontSize: 24), "My exercises"),
            )),
        // liste des exercices
        FutureBuilder(
            future: getAllExercisesOf(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                customExercises = snapshot.data;
                if (customExercises!.isEmpty) {
                  return const Text("No available exercise");
                }
                if (customItems.isEmpty && customQueryEmpty) {
                  customItems = customExercises!;
                }
                return Flexible(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: customItems.length,
                        itemBuilder: (context, index) {
                          return ElevatedButton(
                            onPressed: () {},
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: FutureBuilder(
                                          future: FirebaseStorage.instance
                                              .refFromURL(
                                                  'gs://hongym-4cb68.appspot.com')
                                              .child(
                                                  "img/exercises/${customItems[index].img}")
                                              .getDownloadURL(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Container();
                                            }
                                            return Image.network(
                                              snapshot.data.toString(),
                                              height: 75,
                                              width: 75,
                                            );
                                          },
                                        )),
                                    Expanded(
                                        child: Text(customItems[index].name!)),
                                    // bouton de modif d'un exercice
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: IconButton(
                                        icon: const Icon(Icons.edit),
                                        padding: const EdgeInsets.all(0),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MyEditExoPage(
                                                exo: customItems[index],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    // bouton de suppression d'un exercice
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: IconButton(
                                        icon: const Icon(Icons.delete),
                                        padding: const EdgeInsets.all(0),
                                        onPressed: () {
                                          showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              title:
                                                  const Text('Delete exercise'),
                                              content: const Text(
                                                  'Are you sure that you want to delete this exercise ?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'Cancel'),
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    deleteExercise(
                                                        customItems[index]
                                                            .uid!);
                                                    Navigator.pop(
                                                        context, 'OK');
                                                  },
                                                  child: const Text('Delete'),
                                                ),
                                              ],
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
                        }));
              }
              return const Text("");
            }),
        const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(style: TextStyle(fontSize: 24), "Other exercises"),
            )),
        FutureBuilder(
            future: getAllExercises(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                defaultExercises = snapshot.data;
                if (defaultExercises!.isEmpty) {
                  return const Text("No available exercise");
                }
                if (defaultItems.isEmpty && defaultQueryEmpty) {
                  defaultItems = defaultExercises!;
                }
                return Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: defaultItems.length,
                        itemBuilder: (context, index) {
                          return ElevatedButton(
                              onPressed: () {},
                              child: Column(children: <Widget>[
                                Row(children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: FutureBuilder(
                                        future: FirebaseStorage.instance
                                            .refFromURL(
                                                'gs://hongym-4cb68.appspot.com')
                                            .child(
                                                "img/exercises/${defaultItems[index].img}")
                                            .getDownloadURL(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Container();
                                          }
                                          return Image.network(
                                            snapshot.data.toString(),
                                            height: 75,
                                            width: 75,
                                          );
                                        },
                                      )),
                                  Expanded(
                                      child: Text(defaultItems[index].name!)),
                                ]),
                              ]));
                        }));
              }
              return const Text("");
            }),
      ],
    );
  }
}
