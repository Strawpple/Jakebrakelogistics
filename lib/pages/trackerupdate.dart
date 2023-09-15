import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jb1/pages/confirm-detailed.dart';
import 'package:jb1/pages/confirm.dart';
import 'package:jb1/pages/home.dart';

class trackerupdate extends StatefulWidget {
  const trackerupdate({super.key});

  @override
  State<trackerupdate> createState() => _trackerupdateState();
}

String? statData;

class _trackerupdateState extends State<trackerupdate> {
  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference logs =
      FirebaseFirestore.instance.collection('tracker_collection_logs');
  final CollectionReference tc =
      FirebaseFirestore.instance.collection('tracker_collection');

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
        child: Container(
      child: Center(
        child: Column(
          children: [
            Container(
              child: SizedBox(height: 25),
            ),
            Container(
              width: sw,
              decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
              child: Column(
                children: [
                  Container(
                    child: Text(
                      "What's the hold up? ",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Text(
                      "Update your broker how things are doing.",
                      style: TextStyle(color: Colors.blue, fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: SizedBox(height: 15),
            ),
            Container(
              width: sw / 1.2,
              child: Text(
                "Current Status: ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 22),
              ),
            ),
            Container(
              child: SizedBox(height: 8),
            ),
            Container(
              child: Column(children: [
                Container(
                  height: 80,
                  child: ElevatedButton(
                    child: Text(
                      "Picked up the load. Ready to roll!",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                    side: BorderSide(color: Colors.blue)))),
                    onPressed: () async {
                      update();
                      setState(() {
                        statData = 'Picked up the load. Ready to roll!';
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
              child: SizedBox(
                height: 5,
              ),
            ),
            Container(
              child: Column(children: [
                Container(
                  height: 80,
                  child: ElevatedButton(
                    child: Text(
                      "Made it to the halfway. No issues so far",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                    side: BorderSide(color: Colors.blue)))),
                    onPressed: () async {
                      update();
                      setState(() {
                        statData = 'Made it to the halfway. No issues so far';
                      });
                    },
                  ),
                )
              ]),
            ),
            Container(
              child: SizedBox(
                height: 8,
              ),
            ),
            Container(
              child: Column(children: [
                Container(
                  height: 80,
                  child: ElevatedButton(
                    child: Text(
                      "Stuck in traffic due to an accident ahead",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                    side: BorderSide(color: Colors.blue)))),
                    onPressed: () async {
                      update();
                      setState(() {
                        statData = 'Stuck in traffic due to an accident ahead';
                      });
                    },
                  ),
                )
              ]),
            ),
            Container(
              child: SizedBox(
                height: 8,
              ),
            ),
            Container(
              child: Column(children: [
                Container(
                  height: 80,
                  child: ElevatedButton(
                    child: Text(
                      "Waiting at the unloading dock instructions",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                    side: BorderSide(color: Colors.blue)))),
                    onPressed: () async {
                      update();
                      setState(() {
                        statData = 'Waiting at the unloading dock instructions';
                      });
                    },
                  ),
                )
              ]),
            ),
            Container(
              child: SizedBox(
                height: 8,
              ),
            ),
            Container(
              child: Column(children: [
                Container(
                  height: 80,
                  child: ElevatedButton(
                    child: Text(
                      "Weather problems, slowing me down.",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                    side: BorderSide(color: Colors.blue)))),
                    onPressed: () async {
                      update();
                      setState(() {
                        statData = 'Weather problems, slowing me down.';
                      });
                    },
                  ),
                )
              ]),
            ),
            Container(
              child: SizedBox(
                height: 8,
              ),
            ),
            Container(
              child: Column(children: [
                Container(
                  height: 80,
                  child: ElevatedButton(
                    child: Text(
                      "Encountered road closures. taking a detour.",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                    side: BorderSide(color: Colors.blue)))),
                    onPressed: () async {
                      update();
                      setState(() {
                        statData =
                            'Encountered road closures. taking a detour.';
                      });
                    },
                  ),
                )
              ]),
            ),
            Container(
              child: SizedBox(
                height: 8,
              ),
            ),
            Container(
              child: Column(children: [
                Container(
                  height: 80,
                  child: ElevatedButton(
                    child: Text(
                      "Facing a minor mechanical issue.",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                    side: BorderSide(color: Colors.blue)))),
                    onPressed: () async {
                      update();
                      setState(() {
                        statData = 'Facing a minor mechanical issue.';
                      });
                    },
                  ),
                )
              ]),
            ),
            Container(
              child: SizedBox(
                height: 8,
              ),
            ),
            Container(
              child: Column(children: [
                Container(
                  height: 80,
                  child: ElevatedButton(
                    child: Text(
                      "Delivery done! Getting paperwork signed.",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                    side: BorderSide(color: Colors.blue)))),
                    onPressed: () async {
                      update();
                      setState(() {
                        statData = 'Delivery done! Getting paperwork signed.';
                      });
                    },
                  ),
                )
              ]),
            ),
          ],
        ),
      ),
    ));
  }

  Future update() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return confirmDetailed();
            }),
          );
        }).then((value) => {setState(() {})});
  }
}
