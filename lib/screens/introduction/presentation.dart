import 'package:flutter/material.dart';
import 'package:g2g/screens/introduction/user_connection/connection_choices_screen.dart';
import 'package:introduction_screen/introduction_screen.dart';

class AppPresentationScreen extends StatelessWidget {
  const AppPresentationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      showBackButton: true,
      skip: const Text("Skip"),
      done: const Text("Start my journey to become a GOLEM"),
      back: const Icon(Icons.arrow_circle_left_outlined),
      next: const Icon(Icons.arrow_circle_right_outlined),
      onDone: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ConnectionChoicesScreen()));
      },
      pages: [
        PageViewModel(
            title: "Welcome on Gym2Golem",
            body:
                "Our app fix issues BEFORE, DURING and AFTER your sport sessions ...",
            image: const Center(
              child: Image(image: AssetImage("ressources/large.jpg")),
            )),
        PageViewModel(
            title: "BEFORE",
            body:
                "- You have issues organzing the way you work ?\n- You can't remember what you have already done ? \n - You want to have something planned and ready to work !?",
            image: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                      width: 180,
                      height: 180,
                      image: AssetImage("ressources/planning.png")),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Plan and organize your sports sessions with us !",
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            )),
        PageViewModel(
            title: "DURING",
            body:
                "- You have issues keeping tracks of your sessions ?\n- You can't remember your PRs ? \n -You are annoyed of taking your stylo and your notepad everytime ?",
            image: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                      width: 180,
                      height: 180,
                      image: AssetImage("ressources/541553.png")),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Keep your results in the rock ! (our cloud)",
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            )),
        PageViewModel(
            title: "AFTER",
            body:
                "- You want to see how much you have evolved ? \n- You want to have somewhere you can instantly see your PRs ?\n- You want to see other intersting stats about yourself and your gym activities ?",
            image: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                      width: 180,
                      height: 180,
                      image: AssetImage("ressources/progression.jpg")),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "With YOUR activites stored in our cloud you can see that anytime anywhere",
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            )),
        PageViewModel(
            title: "Become a GOLEM now !!!",
            body: "",
            image: const Center(
              child: Image(image: AssetImage("ressources/golem_cr.png")),
            )),
      ],
    );
  }
}
