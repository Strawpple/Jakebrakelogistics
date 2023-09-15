import 'package:flutter/material.dart';
import 'package:jb1/pages/detailsUpdate.dart';
import 'package:jb1/pages/trackerupdate.dart';

class updateStatus extends StatefulWidget {
  const updateStatus({super.key});

  @override
  State<updateStatus> createState() => _updateStatusState();
}

class _updateStatusState extends State<updateStatus> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      child: Column(children: [
        Container(
          child: SizedBox(height: 15),
        ),
        Container(
          child: Text(
            'Tracking Status',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          child: SizedBox(height: 30),
        ),
        Container(
          width: 200,
          child: ElevatedButton(
            child: Text(
              'Tracking',
              style: TextStyle(fontSize: 22, color: Colors.black),
            ),
            style: ElevatedButton.styleFrom(primary: Colors.blue),
            onPressed: () async {
              trackingStatus();
            },
          ),
        ),
        Container(
          child: SizedBox(height: 18),
        ),
        Container(
          width: 200,
          child: ElevatedButton(
            child: Text(
              'Current',
              style: TextStyle(fontSize: 22, color: Colors.black),
            ),
            onPressed: () async {
              currentStatus();
            },
          ),
        )
      ]),
    );
  }

  Future trackingStatus() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return formal();
            }),
          );
        }).then((value) => {setState(() {})});
  }

  Future currentStatus() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return trackerupdate();
            }),
          );
        }).then((value) => {setState(() {})});
  }
}
