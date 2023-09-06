import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_exercise.dart';
/*import 'package:g2g/api/firebase_user.dart';*/
import 'package:g2g/model/exercise.dart';
import 'package:g2g/screens/gestion/modification/editexo.dart';
import 'package:g2g/screens/gestion/creation/create_exercise.dart';

void main() => runApp(const MyExerciceScreen());

class MyExerciceScreen extends StatefulWidget {
  const MyExerciceScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyExerciceScreen createState() => _MyExerciceScreen();
}

class _MyExerciceScreen extends State<MyExerciceScreen> {
  TextEditingController editingController = TextEditingController();

  List<Exercise>? exercise = [];
  var itemsE = <Exercise>[];
  bool queryEmptyE = true;

  List<Exercise>? myExercise = [];
  var itemsM = <Exercise>[];
  bool queryEmptyM = true;

  @override
  void initState() {
    itemsE = exercise!;
    itemsM = myExercise!;
    super.initState();
  }

  void filterSearchResultsExercise(String query) {
    queryEmptyE = query.isEmpty;
    queryEmptyM = query.isEmpty;
    setState(() {
      exercise!
          .where(
              (item) => item.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      myExercise!
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
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextField(
              onChanged: (value) {
                filterSearchResultsExercise(value);
              },
              controller: editingController,
              decoration: const InputDecoration(
                  labelText: "Recherche",
                  hintText: "Mon Exercice",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
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
                              builder: (context) => const MyCreateExercice()));
                    },
                  ))),
        ]),
        const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(style: TextStyle(fontSize: 24), "Mes exercices"),
            )),
        FutureBuilder(
            future: getAllExercisesOf(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final myExercise = snapshot.data;
                if (myExercise!.isEmpty) {
                  return const Text("Aucun exercice disponible");
                }
                return Flexible(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: myExercise.length,
                        itemBuilder: (context, index) {
                          return ElevatedButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.black),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.grey.shade100)),
                              child: Column(children: <Widget>[
                                Row(children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Image.asset(
                                            myExercise[index].img!,
                                            height: 75,
                                            width: 75,
                                          ))),
                                  Expanded(
                                      child: Text(myExercise[index].name!)),
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: IconButton(
                                        icon: const Icon(Icons.edit),
                                        padding: const EdgeInsets.all(0),
                                        color: Colors.black,
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyEditExoPage(
                                                        exo:
                                                            myExercise[index])),
                                          );
                                        },
                                      )),
                                ]),
                              ]));
                        }));
              }
              return const Text("");
            }),
        const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(style: TextStyle(fontSize: 24), "Autres exercices"),
            )),
        FutureBuilder(
            future: getAllExercises(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final exercise = snapshot.data;
                if (exercise!.isEmpty) {
                  return const Text("Aucun exercice disponible");
                }
                return Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: exercise.length,
                        itemBuilder: (context, index) {
                          return ElevatedButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.black),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.grey.shade100)),
                              child: Column(children: <Widget>[
                                Row(children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Image.asset(
                                            exercise[index].img!,
                                            height: 75,
                                            width: 75,
                                          ))),
                                  Expanded(child: Text(exercise[index].name!)),
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
