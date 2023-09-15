import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jb1/pages/confirm.dart';
import 'package:jb1/pages/trackerupdate.dart';

class formal extends StatefulWidget {
  const formal({super.key});

  @override
  State<formal> createState() => _formalState();
}

class _formalState extends State<formal> {
  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference logs =
      FirebaseFirestore.instance.collection('tracker_collection_logs');
  final CollectionReference tc =
      FirebaseFirestore.instance.collection('tracker_collection');
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: Column(children: [
        Container(
          child: Text(
            'Tracking Status',
            style: TextStyle(fontSize: 22),
          ),
        ),
        Container(
          child: SizedBox(height: 25),
        ),
        Container(
          child: Column(children: [
            Container(
              width: 200,
              child: ElevatedButton(
                child: Text(
                  "Pickup",
                  style: TextStyle(color: Colors.blue, fontSize: 22),
                ),
                onPressed: () async {
                  update();
                  setState(() {
                    statData = 'PICKUP';
                  });
                  // showDialog(
                  //     context: context,
                  //     barrierDismissible: false,
                  //     builder: (context) => Center(
                  //           child: CircularProgressIndicator(),
                  //         ));
                  // print(data);
                },
              ),
            )
          ]),
        ),
        Container(
          child: SizedBox(height: 15),
        ),
        Container(
          child: Column(children: [
            Container(
              width: 200,
              child: ElevatedButton(
                child: Text(
                  "On route",
                  style: TextStyle(color: Colors.blue, fontSize: 22),
                ),
                onPressed: () async {
                  update();
                  setState(() {
                    statData = 'ON ROUTE';
                  });
                  // showDialog(
                  //     context: context,
                  //     barrierDismissible: false,
                  //     builder: (context) => Center(
                  //           child: CircularProgressIndicator(),
                  //         ));
                  // print(data);
                },
              ),
            )
          ]),
        ),
        Container(
          child: SizedBox(height: 15),
        ),
        Container(
          child: Column(children: [
            Container(
              width: 200,
              child: ElevatedButton(
                child: Text(
                  "Delivered",
                  style: TextStyle(color: Colors.blue, fontSize: 22),
                ),
                onPressed: () async {
                  update();
                  setState(() {
                    statData = 'DELIVERED';
                  });
                  // showDialog(
                  //     context: context,
                  //     barrierDismissible: false,
                  //     builder: (context) => Center(
                  //           child: CircularProgressIndicator(),
                  //         ));
                  // print(data);
                },
              ),
            )
          ]),
        ),
        Container(
          child: SizedBox(height: 15),
        ),
      ]),
    );
  }

  Future update() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return confirmUpdate();
            }),
          );
        }).then((value) => {setState(() {})});
  }
}
