import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g2g/api/firebase_workout.dart';
import 'package:g2g/firebase_options.dart';
import 'package:g2g/model/workout.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  test("Create and get Workout", () async {
    Workout myWorkout = Workout(
        name: "Mon workout firebase", user: "", duration: 5, sessions: []);
    Workout addedWorkout = await addWorkout(myWorkout);
    expect(addedWorkout.name, myWorkout.name);
  });
}
