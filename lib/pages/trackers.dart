import 'package:flutter/material.dart';
import 'package:jb1/pages/trackerupdate.dart';

class trackers extends StatefulWidget {
  const trackers({super.key});

  @override
  State<trackers> createState() => _trackersState();
}

class _trackersState extends State<trackers> {
  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
          child: Center(
        child: Column(children: [
          Container(
            child: SizedBox(
              height: 100,
            ),
          ),
          Container(
            width: sw / 1.7,
            child: ElevatedButton(
              child: Text(
                "Tracking has started",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(primary: Colors.blue),
              onPressed: () async {},
            ),
          ),
          Container(
            child: SizedBox(height: 15),
          ),
          Container(
            width: sw / 1.7,
            child: ElevatedButton(
              child: Text(
                "Complete Delivery",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(primary: Colors.blue),
              onPressed: () async {},
            ),
          ),
          Container(
            child: SizedBox(height: 15),
          ),
          Container(
            width: sw / 1.7,
            child: ElevatedButton(
              child: Text(
                "Delivery Update",
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  side: const BorderSide(
                    width: 1,
                    color: Colors.black,
                  )),
              onPressed: () {
                deliveryUpdate();
              },
            ),
          )
        ]),
      )),
    );
  }

  Future deliveryUpdate() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => trackerupdate()));
  }
}
