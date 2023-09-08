import 'package:flutter/material.dart';
import 'package:g2g/api/firebase_workout.dart';
import 'package:g2g/model/workout.dart';
import 'package:g2g/screens/gestion/affichage/affichage_workout.dart';
import 'package:g2g/screens/gestion/modification/editworkout.dart';
import 'package:g2g/screens/gestion/creation/create_workout.dart';

void main() => runApp(const MyWorkoutScreen());

class MyWorkoutScreen extends StatefulWidget {
  const MyWorkoutScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyWorkoutScreen createState() => _MyWorkoutScreen();
} /* oui */

class _MyWorkoutScreen extends State<MyWorkoutScreen> {
  TextEditingController editingController = TextEditingController();

  List<Workout>? workouts = [];
  var items = <Workout>[];
  bool queryEmpty = true;

  @override
  void initState() {
    items = workouts!;
    super.initState();
  }

  void filterSearchResults(String query) {
    queryEmpty = query.isEmpty;
    setState(() {
      items = workouts!
          .where(
              (item) => item.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  labelText: "Search",
                  hintText: "Workout name",
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
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyCreateWorkout()));
                    },
                  ))),
        ]),
        FutureBuilder(
            future: getAllWorkoutsFrom(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }

              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                workouts = snapshot.data;
                if (workouts!.isEmpty) {
                  return const Text("No created workout");
                }
                if (items.isEmpty && queryEmpty) {
                  items = workouts!;
                }
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyWorkoutInfoPage(
                                    workout: snapshot.data![index])),
                          );
                        },
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    items[index].name!,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MyEditWorkoutPage(
                                                  workout: items[index]),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 15),
                              child: Row(
                                children: <Widget>[
                                  const Icon(Icons.repeat),
                                  Expanded(
                                    child:
                                        Text('${items[index].duration}  weeks'),
                                  ),
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                        '${items[index].sessions!.length} training sessions'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }))
      ],
    );
  }
}
