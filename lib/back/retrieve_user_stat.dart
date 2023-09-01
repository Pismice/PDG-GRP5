import 'package:cloud_firestore/cloud_firestore.dart';
//import 'dart:developer' as developer;

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
    List<dynamic> sess;
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;
    docs = await FirebaseFirestore.instance
            .collection('workout')
            .where('user', isEqualTo: userRef)
            .get()
            .then((value) => value.docs)
        /*.catchError((error) =>
            developer.log("Something went wrong : ${error.toString()}"))*/
        ;
    for (var doc in docs) {
      sess = doc.data()['sessions'];
      for (int i = 0; i < sess.length; ++i) {
        if (sess[i]['start'] != null && sess[i]['end'] != null) {
          totalMinutesSpent +=
              DateTime.fromMillisecondsSinceEpoch(sess[i]['end'].seconds * 1000)
                  .difference(DateTime.fromMillisecondsSinceEpoch(
                      sess[i]['start'].seconds * 1000))
                  .inMinutes;
        }
      }
    }

    if (totalMinutesSpent >= 60) {
      return "${(totalMinutesSpent / 60).floor()}h ${totalMinutesSpent % 60}";
    }
    return "${totalMinutesSpent}m";
  }

  Future<double> getTotalWeightPushed() async {
    double totalWeight = 0;
    List<dynamic> sess;
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;
    docs = await FirebaseFirestore.instance
            .collection('workout')
            .where('user', isEqualTo: userRef)
            .get()
            .then((value) => value.docs)
        /*.catchError((error) =>
            developer.log("Something went wrong : ${error.toString()}"))*/
        ;
    for (var doc in docs) {
      sess = doc.data()['sessions'];
      for (int i = 0; i < sess.length; ++i) {
        for (int j = 0; j < sess[i]['exercises'].length; ++j) {
          for (int k = 0; k < sess[i]['exercises'][j]['sets'].length; ++k) {
            if (sess[i]['exercises'][j]['sets'][k]['repetition'] != null &&
                sess[i]['exercises'][j]['sets'][k]['weight'] != null) {
              totalWeight += sess[i]['exercises'][j]['sets'][k]['repetition'] *
                  sess[i]['exercises'][j]['sets'][k]['weight'];
            }
          }
        }
      }
    }
    return totalWeight;
  }

  Future<int> getNumberSessionDone() async {
    int numbers = 0;
    List<dynamic> sess;
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;
    docs = await FirebaseFirestore.instance
            .collection('workout')
            .where('user', isEqualTo: userRef)
            .get()
            .then((value) => value.docs)
        /*.catchError((error) =>
            developer.log("Something went wrong : ${error.toString()}"),)*/
        ;

    for (var doc in docs) {
      sess = doc.data()['sessions'];
      for (int i = 0; i < sess.length; ++i) {
        if (sess[i]['start'] != null && sess[i]['end'] != null) {
          numbers++;
        }
      }
    }
    return numbers;
  }
}
