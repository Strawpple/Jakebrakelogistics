import 'package:flutter/material.dart';
import 'package:jb1/main.dart';
import 'package:jb1/pages/login.dart';
import 'package:jb1/pages/trackers.dart';

class tracking extends StatefulWidget {
  const tracking({super.key});

  @override
  State<tracking> createState() => _trackingState();
}

class _trackingState extends State<tracking> {
  // Text Controller
  final trackingnum = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: const SizedBox(height: 110),
            ),
            Container(
              child: Image.asset("lib/assets/jb1.png"),
            ),
            Container(
              child: const SizedBox(
                height: 20,
              ),
            ),
            Container(
                child: const Center(
              child: Text(
                "Jakebrake Logistics",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            )),
            Container(
              child: Text(
                "Tracker",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: sw / 1.5,
              child: TextFormField(
                controller: trackingnum,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: "Tracking Number"),
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ),
            Container(
              child: SizedBox(height: 15),
            ),
            Container(
              width: sw / 1.8,
              child: ElevatedButton(
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(primary: Colors.blue),
                onPressed: () async {
                  validation();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future validation() async {
    if (trackingnum.text == "PLZSTC8H23BXC46") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                    title: '',
                  )));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => trackers()));
    }
  }
}
