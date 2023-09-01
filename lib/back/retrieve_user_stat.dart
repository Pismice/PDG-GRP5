import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;

class UserStatistics {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String uid;
  late DocumentReference userRef;
  UserStatistics(this.uid) {
    FirebaseFirestore.instance
        .collection('user')
        .where('authid', isEqualTo: uid)
        .limit(1)
        .get()
        .then((value) =>
            userRef = db.collection('user').doc(value.docs[0].id.toString()));
  }

  Future<String> getHoursSpentInGym() async {
    int totalMinutesSpent = 0;
    developer.log('start total hours');
    Map<String, dynamic> sess;
    await FirebaseFirestore.instance
            .collection('workout')
            .where('user', isEqualTo: userRef)
            .get()
            .then((value) => value.docs.forEach((element) {
                  sess = element.data()['sessions'];
                  for (int i = 0; i < sess.length; ++i) {
                    developer.log('.');
                    if (sess[i]['start'] != null && sess[i]['end'] != null) {
                      totalMinutesSpent += DateTime.fromMillisecondsSinceEpoch(
                              sess[i]['end'].seconds * 1000)
                          .difference(DateTime.fromMillisecondsSinceEpoch(
                              sess[i]['start'].seconds * 1000))
                          .inMinutes;
                    }
                  }
                }))
        /*.catchError((error) =>
            developer.log("Something went wrong : ${error.toString()}"))*/
        ;
    developer.log('f total hours');

    if (totalMinutesSpent >= 60) {
      return "${(totalMinutesSpent / 60).floor()}h ${totalMinutesSpent % 60}";
    }
    return "${totalMinutesSpent}m";
  }

  Future<double> getTotalWeightPushed() async {
    double totalWeight = 0;
    developer.log('start total weight');
    Map<String, dynamic> sess;
    await FirebaseFirestore.instance
            .collection('workout')
            .where('user', isEqualTo: userRef)
            .get()
            .then((snapshot) => {
                  snapshot.docs.forEach((element) {
                    sess = element.data()['sessions'];
                    for (int i = 0; i < sess.length; ++i) {
                      for (int j = 0; j < sess[i]['exercises'].length; ++j) {
                        for (int k = 0;
                            k <
                                element
                                    .data()['sessions'][i]['exercises'][j]
                                        ['sets']
                                    .length;
                            ++k) {
                          developer.log('!');
                          if (sess[i]['exercises'][j]['sets'][k]
                                      ['repetition'] !=
                                  null &&
                              sess[i]['exercises'][j]['sets'][k]['weight'] !=
                                  null) {
                            totalWeight += sess[i]['exercises'][j]['sets'][k]
                                    ['repetition'] *
                                sess[i]['exercises'][j]['sets'][k]['weight'];
                          }
                        }
                      }
                    }
                  })
                })
        /*.catchError((error) =>
            developer.log("Something went wrong : ${error.toString()}"))*/
        ;
    developer.log('end total weight');
    return totalWeight;
  }

  Future<int> getNumberSessionDone() async {
    int numbers = 0;
    Map<String, dynamic> sess;
    await FirebaseFirestore.instance
            .collection('workout')
            .where('user', isEqualTo: userRef)
            .get()
            .then((value) => value.docs.forEach((element) {
                  sess = element.data()['sessions'];
                  for (int i = 0; i < sess.length; ++i) {
                    if (sess[i]['start'] != null && sess[i]['end'] != null) {
                      numbers++;
                    }
                  }
                }))
        /*.catchError((error) =>
            developer.log("Something went wrong : ${error.toString()}"),)*/
        ;
    return numbers;
  }
}
