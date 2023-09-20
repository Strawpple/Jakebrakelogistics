import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jb1/pages/home.dart';

class confirmLoc extends StatefulWidget {
  const confirmLoc({super.key});

  @override
  State<confirmLoc> createState() => _confirmLocState();
}

class _confirmLocState extends State<confirmLoc> {
  final CollectionReference lc =
      FirebaseFirestore.instance.collection('location_tracking');
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

                  _currentLocation = await _getCurrentLocation();
                  final updateStatus = <String, dynamic>{
                    'current_latitude': _currentLocation?.latitude,
                    'current_longitude': _currentLocation?.longitude,
                    'updated_at': now
                  };

                  for (var i = 0; i < TrackingId.length; i++) {
                    lc.doc(TrackingId[i].toString()).update(updateStatus);
                  }

                  ElegantNotification.success(
                    width: 360,
                    notificationPosition: NotificationPosition.topLeft,
                    animation: AnimationType.fromTop,
                    title: Text('Tracking Status'),
                    description: Text('Update Successful!'),
                    onDismiss: () {},
                  ).show(context);
                  Navigator.pop(context);
                },
              ),
            )
          ]),
        )
      ]),
    );
  }
}
