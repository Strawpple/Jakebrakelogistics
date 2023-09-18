import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jb1/pages/home.dart';

class addAccounTracker extends StatefulWidget {
  const addAccounTracker({super.key});

  @override
  State<addAccounTracker> createState() => _addAccounTrackerState();
}

class _addAccounTrackerState extends State<addAccounTracker> {
  final CollectionReference lc =
      FirebaseFirestore.instance.collection('location_tracking');
  final user = FirebaseAuth.instance.currentUser!;
  // Firebase firestore
  final CollectionReference addTrack =
      FirebaseFirestore.instance.collection('account-trackers_collection');

  // Text Controller
  final trackingnum = TextEditingController();

  // GEOLOCATION
  Position? _currentLocation;
  late bool servicePermission = false;
  late LocationPermission permission;

  String _currentAddress = "";

  Future<Position> _getCurrentLocation() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      print("service disabled");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        children: [
          Container(
            child: SizedBox(height: 15),
          ),
          Container(
            child: Text(
              'Trackers Form',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            child: SizedBox(
              height: 30,
            ),
          ),
          Container(
            height: 80,
            child: TextFormField(
              controller: trackingnum,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: "Tracking Number"),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: TextStyle(fontSize: 22),
            ),
          ),
          Container(
            child: SizedBox(height: 25),
          ),
          Container(
            height: 50,
            width: 300,
            child: ElevatedButton(
              child: Text(
                'Submit',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(primary: Colors.blue),
              onPressed: () async {
                submit();
              },
            ),
          ),
          Container(
            child: SizedBox(height: 10),
          ),
          Container(
            height: 50,
            width: 300,
            child: ElevatedButton(
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }

  Future submit() async {
    _currentLocation = await _getCurrentLocation();
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);

    try {
      bool result = AllTrackerCollection.contains(trackingnum.text);
      if (result == true) {
        Map<String, dynamic> data = {
          'trackingnum': trackingnum.text,
          'trackeremail': user.email,
          // 'password': password.text,
          'trackingstatus': 'validated',
          'created_at': now,
        };

        addTrack.add(data);

        Map<String, dynamic> data2 = {
          'trackingnum': trackingnum.text,
          'current_logitude': _currentLocation?.longitude,
          'current_latitude': _currentLocation?.latitude,
          'trackeremail': user.email,
          'created_at': now,
        };
        lc.add(data2);

        // tc.doc(statId).update(updateStatus);

        ElegantNotification.success(
          width: 360,
          notificationPosition: NotificationPosition.topLeft,
          animation: AnimationType.fromTop,
          title: Text('Tracking Number'),
          description: Text('Added Successful!'),
          onDismiss: () {},
        ).show(context);
        Navigator.pop(context);
      } else {
        ElegantNotification.error(
          width: 360,
          notificationPosition: NotificationPosition.topLeft,
          animation: AnimationType.fromTop,
          title: Text('Tracking Number not Found'),
          description: Text('Enter valid tracking number!'),
          onDismiss: () {},
        ).show(context);
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
  }
}
