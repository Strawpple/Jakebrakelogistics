import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jb1/pages/home.dart';
import 'package:jb1/pages/trackerupdate.dart';

class confirmUpdate extends StatefulWidget {
  const confirmUpdate({super.key});

  @override
  State<confirmUpdate> createState() => _confirmUpdateState();
}

List LocID = [];
String? locid;

class _confirmUpdateState extends State<confirmUpdate> {
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final CollectionReference logs =
      FirebaseFirestore.instance.collection('tracker_collection_logs');
  final CollectionReference tc =
      FirebaseFirestore.instance.collection('tracker_collection');
  final CollectionReference lt =
      FirebaseFirestore.instance.collection('location_tracking');
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: Column(children: [
        Container(
          child: SizedBox(height: 20),
        ),
        Container(
          child: Text(
            'Confirm Status?',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          child: SizedBox(height: 20),
        ),
        Container(
          child: Row(children: [
            Container(
              child: ElevatedButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ),
            Container(
              child: SizedBox(width: 25),
            ),
            Container(
              child: ElevatedButton(
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(primary: Colors.blue),
                onPressed: () async {
                  DateTime now = new DateTime.now();
                  DateTime date = new DateTime(now.year, now.month, now.day);

                  final updateStatus = <String, dynamic>{
                    'status': statData.toString(),
                    'email': user.email,
                    'updated_at': now
                  };

                  logs.add(updateStatus);

                  final data = <String, dynamic>{
                    'trackingstatus': 'Delivered',
                    'datetime_del': now
                  };

                  db
                      .collection('location_tracking')
                      .where('trackingnum', isEqualTo: id.toString())
                      // .orderBy("created_at", descending: true)
                      .get()
                      .then((querySnapshot) async {
                    for (var docSnapshot in querySnapshot.docs) {
                      locid = docSnapshot.id;
                      // print(docSnapshot.id);
                    }
                  });

                  lt.doc(locid).update(data);
                  tc.doc(statId).update(updateStatus);

                  ElegantNotification.success(
                    width: 360,
                    notificationPosition: NotificationPosition.topLeft,
                    animation: AnimationType.fromTop,
                    title: Text('Tracking Status'),
                    description: Text('Update Successful!'),
                    onDismiss: () {},
                  ).show(context);

                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => home()));
                },
              ),
            )
          ]),
        )
      ]),
    );
  }
}
