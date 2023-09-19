import 'package:flutter/material.dart';

class confirmLoc extends StatefulWidget {
  const confirmLoc({super.key});

  @override
  State<confirmLoc> createState() => _confirmLocState();
}

class _confirmLocState extends State<confirmLoc> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: 300,
      child: Column(children: [
        Container(
          child: SizedBox(height: 20),
        ),
        Container(
          child: Text(
            'Confirm?',
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
                },
              ),
            )
          ]),
        )
      ]),
    );
  }
}
