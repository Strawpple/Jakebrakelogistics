import 'dart:async';
import 'dart:typed_data';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:glassycontainer/glassycontainer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:jb1/components/openDetails.dart';
import 'package:jb1/data/api.dart';
import 'package:jb1/pages/addTracker.dart';
import 'package:jb1/pages/confirm-loc.dart';
import 'package:jb1/pages/formalUpdate.dart';
import 'package:jb1/pages/information.dart';
import 'package:jb1/pages/trackerupdate.dart';
import 'package:location/location.dart';
// import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

class homepage2 extends StatefulWidget {
  const homepage2({super.key});

  @override
  State<homepage2> createState() => _homeState();
}

// Notes
// AllTrackerCollection = Global setState of account-trackers_collection db
// account-trackers_collection db
List AllTrackerCollection = [];

List Tracker_Collection = [];

List<Trackers> listTracker = [];
List TrackingId = [];

// UPDATE STATUS TRACKINGNUMBER
String? id;

// Live Tracking
List liveTracking = [];

class _homeState extends State<homepage2> {
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final CollectionReference lc =
      FirebaseFirestore.instance.collection('location_tracking');

  /// Controller to handle PageView and also handles initial page
  final _pageController = PageController(initialPage: 0);

  /// Controller to handle bottom nav bar and also handles initial page
  final _controller = NotchBottomBarController(index: 0);

  int maxCount = 5;
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
  void initState() {
    // TODO: implement initState
    super.initState();

    // print(id);
    List livetrackingnum = [];
    List idtrackingnum = [];

    // Fetch location tracking of the user
    db
        .collection('location_tracking')
        .where('trackeremail', isEqualTo: user.email.toString())
        .where('trackingstatus', isNotEqualTo: 'Delivered')
        // .orderBy("created_at", descending: true)
        .get()
        .then((querySnapshot) async {
      for (var docSnapshot in querySnapshot.docs) {
        livetrackingnum.add(docSnapshot.data()['trackingnum']);
        idtrackingnum.add(docSnapshot.id);

        setState(() {
          liveTracking = livetrackingnum;
          TrackingId = idtrackingnum;
        });
      }
    });

    Timer.periodic(Duration(minutes: 30), (timer) {
      _hourlyTask();
      // print('1');
    });
  }

  void _hourlyTask() async {
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

    // print(_currentLocation);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// widget list
  final List<Widget> bottomBarPages = [
    const Page1(),
    const Page2(),
    const Page3(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              /// Provide NotchBottomBarController
              notchBottomBarController: _controller,
              color: Colors.white,
              showLabel: false,
              notchColor: Colors.black87,

              /// restart app if you change removeMargins
              removeMargins: false,
              bottomBarWidth: 500,
              durationInMilliSeconds: 300,
              bottomBarItems: [
                const BottomBarItem(
                  inActiveItem: Icon(
                    Icons.home_filled,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.home_filled,
                    color: Colors.white,
                  ),
                  itemLabel: 'Page 1',
                ),
                const BottomBarItem(
                  inActiveItem: Icon(
                    Icons.add,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  itemLabel: 'Page 2',
                ),
                const BottomBarItem(
                  inActiveItem: Icon(
                    Icons.person,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  itemLabel: 'Page 3',
                ),
              ],
              onTap: (index) {
                /// perform action on tab change and to update pages you can update pages without pages
                print('current selected index $index');
                _pageController.jumpToPage(index);
              },
            )
          : null,
    );
  }
}

class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);
  @override
  State<Page1> createState() => _Page1State();
}

String idDetails = "";
List arrtrack = [];
String? ident;
String? statId;

List TempArr = [];

class _Page1State extends State<Page1> {
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  void initState() {
    super.initState();

    List<Trackers> trackers = [];
    List userTrack = [];

    // Fetch Tracking number of the user
    db
        .collection('account-trackers_collection')
        .where('trackeremail', isEqualTo: user.email.toString())
        .orderBy("created_at", descending: true)
        .get()
        .then((querySnapshot) async {
      for (var docSnapshot in querySnapshot.docs) {
        accTracker data = accTracker(
          id: docSnapshot.id,
          email: docSnapshot.data()['trackeremail'],
          trackno: docSnapshot.data()['trackingnum'],
        );

        userTrack.add(docSnapshot.data()['trackingnum']);

        setState(() {
          arrtrack = userTrack;
        });
      }
    });

    // fetch all trackers

    List tracker_collection = [];
    db
        .collection('tracker_collection')
        .orderBy("created_at", descending: true)
        .get()
        .then((querySnapshot) async {
      for (var docSnapshot in querySnapshot.docs) {
        tracker_collection.add(docSnapshot.data()['trackingnum']);

        setState(() {
          Tracker_Collection = tracker_collection;
        });
      }
    });

    // LIVE PRODUCTION

    try {
      db
          .collection('tracker_collection')
          .where('trackingnum', whereIn: arrtrack)
          .orderBy("created_at", descending: true)
          .get()
          .then((querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          Trackers data = Trackers(
            id: docSnapshot.id,
            trackingnum: docSnapshot.data()['trackingnum'],
            pickuploc: docSnapshot.data()['pickuploc'],
            deliveryloc: docSnapshot.data()['deliveryloc'],
            pickupmon: docSnapshot.data()['pickupmonth'],
            pickupday: docSnapshot.data()['pickupdate'],
            pickupyr: docSnapshot.data()['pickupyear'],
            pickuptime: docSnapshot.data()['pickuptime'],
            delmon: docSnapshot.data()['deliverymonth'],
            delday: docSnapshot.data()['deliverydate'],
            delyr: docSnapshot.data()['deliveryyear'],
            deltime: docSnapshot.data()['deliverytime'],
            status: docSnapshot.data()['status'],
          );

          tracker_collection.add(docSnapshot.data()['trackingnum']);

          trackers.add(data);

          setState(() {
            Tracker_Collection = tracker_collection;
            listTracker = trackers;

            ident = docSnapshot.data()['trackingnum'];
          });
        }
      });
    } catch (e) {
      ident = 'false';
    }

    // LIVE

    List TrackerCollection = [];

    db
        .collection('account-trackers_collection')
        .orderBy("created_at", descending: true)
        .get()
        .then((querySnapshot) async {
      for (var docSnapshot in querySnapshot.docs) {
        accTracker data = accTracker(
          id: docSnapshot.id,
          trackno: docSnapshot.data()['trackingnum'],
          email: docSnapshot.data()['trackeremail'],
        );

        TrackerCollection.add(docSnapshot.data()['trackingnum']);
        // print(docSnapshot.data()['phonenumber']);

        setState(() {
          AllTrackerCollection = TrackerCollection;
        });
      }
    });

    // GEOLOCATION
  }

  String trackingnum = "";
  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
        child: Container(
            color: Colors.white,
            child: Center(
                child: Column(
              children: [
                Container(
                  child: SizedBox(
                    height: 50,
                  ),
                ),
                Container(
                  child: Text(
                    "Jakebrake Logistics Load Management",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                ),
                Container(
                  child: SizedBox(height: 10),
                ),
                Container(
                  margin: EdgeInsets.only(left: 13),
                  width: sw,
                  child: Text(
                    "Trackers",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  child: SizedBox(height: 10),
                ),
                Container(
                    child: Divider(
                  color: Colors.black,
                )),
                Container(
                  child: SizedBox(height: 5),
                ),
                Container(
                  height: 55,
                  width: sw / 1.1,
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(0)))),
                    onChanged: (val) {
                      setState(() {
                        print(val);
                        trackingnum = val;
                      });
                    },
                  ),
                ),
                // Container(
                //   child: ElevatedButton(
                //     child: Text('Test'),
                //     onPressed: () async {
                //       test();
                //     },
                //   ),
                // ),

                if (ident == 'false')
                  Container(
                    child: Text('Tracking is Empty'),
                  ),
                if (ident != null)
                  Container(
                    height: sh,
                    child: ListView.builder(
                        itemCount: listTracker.length,
                        itemBuilder: ((context, index) {
                          if (trackingnum.isEmpty) {
                            return Container(
                              height: 300,
                              width: sw,
                              child: Card(
                                color: Colors.white,
                                child: Column(children: [
                                  Container(
                                    child: SizedBox(height: 15),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 48),
                                    child: Row(children: [
                                      Container(
                                        child: Text(
                                          '#',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          listTracker[index].trackingnum,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22),
                                        ),
                                      ),
                                      Container(
                                        child: SizedBox(width: 50),
                                      ),
                                      Container(
                                        child: InkWell(
                                          child: Text(
                                            'Update Status',
                                            style: TextStyle(
                                                fontSize: 22,
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                          onTap: () async {
                                            setState(() {
                                              statId = listTracker[index].id;
                                              id = listTracker[index]
                                                  .trackingnum;
                                            });
                                            openStatus();
                                          },
                                        ),
                                      )
                                    ]),
                                  ),

                                  Container(
                                    child: SizedBox(height: 15),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 48),
                                    child: Row(children: [
                                      Container(
                                        child: Column(children: [
                                          Container(
                                            child: Text(
                                              "1. Pick up",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 20),
                                            child: Text(
                                              listTracker[index].pickuploc,
                                              style: TextStyle(fontSize: 22),
                                            ),
                                          )
                                        ]),
                                      ),
                                      Container(
                                        child: SizedBox(width: 60),
                                      ),
                                      Container(
                                        child: Column(children: [
                                          Container(
                                            child: Text(
                                              listTracker[index].pickupmon +
                                                  '/' +
                                                  listTracker[index].pickupday,
                                              style: TextStyle(fontSize: 22),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              listTracker[index].pickuptime,
                                              style: TextStyle(fontSize: 22),
                                            ),
                                          )
                                        ]),
                                      ),
                                    ]),
                                  ),
                                  Container(
                                    child: SizedBox(
                                      height: 15,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 48),
                                    child: Row(children: [
                                      Container(
                                        child: Column(children: [
                                          Container(
                                            child: Text(
                                              "2. Delivery",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 20),
                                            child: Text(
                                              listTracker[index].deliveryloc,
                                              style: TextStyle(fontSize: 22),
                                            ),
                                          )
                                        ]),
                                      ),
                                      Container(
                                        child: SizedBox(width: 60),
                                      ),
                                      Container(
                                        child: Column(children: [
                                          Container(
                                            child: Text(
                                              listTracker[index].delmon +
                                                  '/' +
                                                  listTracker[index].delday,
                                              style: TextStyle(fontSize: 22),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              listTracker[index].deltime,
                                              style: TextStyle(fontSize: 22),
                                            ),
                                          )
                                        ]),
                                      ),
                                    ]),
                                  ),
                                  Container(
                                    child: SizedBox(height: 15),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 55),
                                    child: Row(children: [
                                      Container(
                                        child: Text(
                                          'Tracking Status: ',
                                          style: TextStyle(fontSize: 22),
                                        ),
                                      ),
                                      if (listTracker[index].status ==
                                          'NOT STARTED')
                                        Container(
                                          child: Text(
                                            listTracker[index].status,
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 22),
                                          ),
                                        ),
                                      if (listTracker[index].status !=
                                          'NOT STARTED')
                                        Container(
                                          child: Text(
                                            listTracker[index].status,
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 22),
                                          ),
                                        ),
                                    ]),
                                  ),
                                  Container(
                                    child: SizedBox(height: 20),
                                  ),
                                  // Container(
                                  //     width: sw,
                                  //     margin: EdgeInsets.only(left: 25),
                                  //     child: InkWell(
                                  //       child: Text(
                                  //         'View Details',
                                  //         style: TextStyle(
                                  //             decoration:
                                  //                 TextDecoration.underline),
                                  //       ),
                                  //       onTap: () async {
                                  //         openDetails();
                                  //         setState(() {
                                  //           idDetails = listTracker[index].trackingnum;
                                  //         });
                                  //       },
                                  //     ))
                                ]),
                              ),
                            );
                          }
                          if (listTracker[index]
                              .trackingnum
                              .toLowerCase()
                              .startsWith(trackingnum.toLowerCase())) {
                            return Container(
                              height: 300,
                              width: sw,
                              child: Card(
                                color: Colors.white,
                                child: Column(children: [
                                  Container(
                                    child: SizedBox(height: 25),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 48),
                                    child: Row(children: [
                                      Container(
                                        child: Text(
                                          '#',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          listTracker[index].trackingnum,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22),
                                        ),
                                      ),
                                      Container(
                                        child: SizedBox(width: 50),
                                      ),
                                      Container(
                                        child: InkWell(
                                          child: Text(
                                            'Update Status',
                                            style: TextStyle(
                                                fontSize: 22,
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                          onTap: () async {
                                            setState(() {
                                              statId = listTracker[index].id;
                                            });
                                            openStatus();
                                          },
                                        ),
                                      )
                                    ]),
                                  ),

                                  Container(
                                    child: SizedBox(height: 15),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 48),
                                    child: Row(children: [
                                      Container(
                                        child: Column(children: [
                                          Container(
                                            child: Text(
                                              "1. Pick up",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 20),
                                            child: Text(
                                              listTracker[index].pickuploc,
                                              style: TextStyle(fontSize: 22),
                                            ),
                                          )
                                        ]),
                                      ),
                                      Container(
                                        child: SizedBox(width: 60),
                                      ),
                                      Container(
                                        child: Column(children: [
                                          Container(
                                            child: Text(
                                              listTracker[index].pickupmon +
                                                  '/' +
                                                  listTracker[index].pickupday,
                                              style: TextStyle(fontSize: 22),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              listTracker[index].pickuptime,
                                              style: TextStyle(fontSize: 22),
                                            ),
                                          )
                                        ]),
                                      ),
                                    ]),
                                  ),
                                  Container(
                                    child: SizedBox(
                                      height: 15,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 48),
                                    child: Row(children: [
                                      Container(
                                        child: Column(children: [
                                          Container(
                                            child: Text(
                                              "2. Delivery",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 20),
                                            child: Text(
                                              listTracker[index].deliveryloc,
                                              style: TextStyle(fontSize: 22),
                                            ),
                                          )
                                        ]),
                                      ),
                                      Container(
                                        child: SizedBox(width: 60),
                                      ),
                                      Container(
                                        child: Column(children: [
                                          Container(
                                            child: Text(
                                              listTracker[index].delmon +
                                                  '/' +
                                                  listTracker[index].delday,
                                              style: TextStyle(fontSize: 22),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              listTracker[index].deltime,
                                              style: TextStyle(fontSize: 22),
                                            ),
                                          )
                                        ]),
                                      ),
                                    ]),
                                  ),
                                  Container(
                                    child: SizedBox(height: 15),
                                  ),

                                  Container(
                                    margin: EdgeInsets.only(left: 55),
                                    child: Row(children: [
                                      Container(
                                        child: Text(
                                          'Tracking Status: ',
                                          style: TextStyle(fontSize: 22),
                                        ),
                                      ),
                                      if (listTracker[index].status ==
                                          'NOT STARTED')
                                        Container(
                                          child: Text(
                                            listTracker[index].status,
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 22),
                                          ),
                                        ),
                                      if (listTracker[index].status ==
                                          'NOT STARTED')
                                        Container(
                                          child: Text(
                                            listTracker[index].status,
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 22),
                                          ),
                                        ),
                                    ]),
                                  ),
                                  Container(
                                    child: SizedBox(height: 20),
                                  ),
                                  // Container(
                                  //     width: sw,
                                  //     margin: EdgeInsets.only(left: 25),
                                  //     child: InkWell(
                                  //       child: Text(
                                  //         'View Details',
                                  //         style: TextStyle(
                                  //             decoration:
                                  //                 TextDecoration.underline),
                                  //       ),
                                  //       onTap: () async {
                                  //         openDetails();
                                  //         setState(() {
                                  //           idDetails = listTracker[index].trackingnum;
                                  //         });
                                  //       },
                                  //     ))
                                ]),
                              ),
                            );
                          }
                        })),
                  )
              ],
            ))));
  }

  Future openDetails() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return viewDetails();
            }),
          );
        }).then((value) => {setState(() {})});
  }

  Future openStatus() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return updateStatus();
            }),
          );
        }).then((value) => {setState(() {})});
  }
}

// class Page2 extends StatefulWidget {
//   const Page2({Key? key}) : super(key: key);
//   @override
//   State<Page2> createState() => _Page2State();
// }

// String? longi;
// String? latit;

// class _Page2State extends State<Page2> {
//   Location _locationController = new Location();

//   static const LatLng _pGooglePlex = LatLng(7.178821, 125.597496);
//   static const LatLng _pApplePark =
//       LatLng(7.078791936610768, 125.60789753165476);

//   LatLng? _currentP = null;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getLocationUpdates();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final sw = MediaQuery.of(context).size.width;
//     final sh = MediaQuery.of(context).size.height;
//     return Stack(
//       children: [
//         Container(
//           child: _currentP == null
//               ? const Center(
//                   child: Text("Loading..."),
//                 )
//               : GoogleMap(
//                   initialCameraPosition:
//                       CameraPosition(target: _pGooglePlex, zoom: 13),
//                   markers: {
//                     Marker(
//                         markerId: MarkerId("_currentLocation"),
//                         icon: BitmapDescriptor.defaultMarkerWithHue(
//                             BitmapDescriptor.hueBlue),
//                         position: _currentP!),
//                     Marker(
//                         markerId: MarkerId("sourceLocation"),
//                         icon: BitmapDescriptor.defaultMarker,
//                         position: _pGooglePlex),
//                     Marker(
//                         markerId: MarkerId("destinationLocation"),
//                         icon: BitmapDescriptor.defaultMarker,
//                         position: _pApplePark)
//                   },
//                 ),
//         )
//       ],
//     );
//   }

//   Future<void> getLocationUpdates() async {
//     bool _serviceEnabled;
//     PermissionStatus _permissionGranted;

//     _serviceEnabled = await _locationController.serviceEnabled();
//     if (_serviceEnabled) {
//       _serviceEnabled = await _locationController.requestService();
//     } else {
//       return;
//     }

//     _permissionGranted = await _locationController.hasPermission();
//     if (_permissionGranted == PermissionStatus.denied) {
//       _permissionGranted = await _locationController.requestPermission();
//       if (_permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }

//     _locationController.onLocationChanged
//         .listen((LocationData currentLocation) {
//       if (currentLocation.latitude != null &&
//           currentLocation.longitude != null) {
//         setState(() {
//           _currentP =
//               LatLng(currentLocation.latitude!, currentLocation.longitude!);
//           print(_currentP);
//         });
//       }
//     });
//   }

// Widget _getMarker() {
//   return Container(
//     width: 40,
//     height: 40,
//     decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(100),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.grey,
//               offset: Offset(0, 3),
//               spreadRadius: 4,
//               blurRadius: 6)
//         ]),
//     child: ClipOval(child: Image.asset('lib/assets/pic.png')),
//   );
// }

// Widget _getMap() {
//   return Stack(
//     children: [
//       Container(
//           child: GoogleMap(
//         initialCameraPosition: _cameraPosition!,
//         mapType: MapType.normal,
//         onMapCreated: (GoogleMapController controller) {
//           if (!_googleMapController.isCompleted) {
//             _googleMapController.complete(controller);
//           }
//         },
//       )),
//       Positioned.fill(
//           child: Align(
//         alignment: Alignment.center,
//         child: _getMarker(),
//       ))
//     ],
//   );
// }

//   Future confirmUpdate() async {
//     return showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             content: StatefulBuilder(
//                 builder: (BuildContext context, StateSetter setState) {
//               return confirmLoc();
//             }),
//           );
//         }).then((value) => {setState(() {})});
//   }
// }

class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);
  @override
  State<Page2> createState() => _Page3State();
}

List<accTracker> accTrack = [];

class _Page3State extends State<Page2> {
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    List<accTracker> acctrack = [];

    db
        .collection('account-trackers_collection')
        .where('trackeremail', isEqualTo: user.email.toString())
        .orderBy("created_at", descending: true)
        .get()
        .then((querySnapshot) async {
      for (var docSnapshot in querySnapshot.docs) {
        accTracker data = accTracker(
          id: docSnapshot.id,
          email: docSnapshot.data()['trackeremail'],
          trackno: docSnapshot.data()['trackingnum'],
        );

        acctrack.add(data);

        setState(() {
          accTrack = acctrack;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
        child: Container(
            color: Colors.white,
            child: Center(
                child: Column(
              children: [
                Container(
                  child: SizedBox(
                    height: 50,
                  ),
                ),
                Container(
                  child: Text(
                    "Jakebrake Logistics Load Management",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                ),
                Container(
                  child: SizedBox(height: 15),
                ),
                Container(
                  width: sw,
                  margin: EdgeInsets.only(left: 15),
                  child: Text(
                    "Tracking Number",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  child: SizedBox(height: 10),
                ),
                Container(
                    child: Divider(
                  color: Colors.black,
                )),
                Container(
                  child: SizedBox(
                    height: 15,
                  ),
                ),
                Container(
                  width: 300,
                  child: ElevatedButton(
                    child: Text(
                      'Add Tracker ID',
                      style: TextStyle(fontSize: 22, color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(primary: Colors.blue),
                    onPressed: () async {
                      addTracker();
                    },
                  ),
                ),
                Container(
                  child: SizedBox(
                    height: 10,
                  ),
                ),
                Container(
                  height: sh,
                  child: ListView.builder(
                      itemCount: accTrack.length,
                      itemBuilder: (context, index) {
                        if (accTrack.length != 0) {
                          return Container(
                            child: Column(children: [
                              Container(
                                  child: Text(
                                accTrack[index].trackno,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              )),
                              Container(
                                width: 300,
                                child: Divider(color: Colors.black),
                              )
                            ]),
                          );
                        }
                      }),
                )
              ],
            ))));
  }

  Future addTracker() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return addAccounTracker();
            }),
          );
        }).then((value) => {setState(() {})});
  }
}

class Page3 extends StatefulWidget {
  const Page3({Key? key}) : super(key: key);
  @override
  State<Page3> createState() => _Page4State();
}

String? uid;
int? findPhone;
List fetchPhone = [];
List<Users> userAcc = [];
String? newnum;

String? selectname;
Uint8List? addimg;

class _Page4State extends State<Page3> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    // TODO: implement initState
    super.initState();

    List phone = [];
    List<Users> uAcc = [];

    db
        .collection('user_accounts')
        .where('email', isEqualTo: user.email.toString())
        .orderBy("created_at", descending: true)
        .get()
        .then((querySnapshot) async {
      for (var docSnapshot in querySnapshot.docs) {
        Users data = Users(
            id: docSnapshot.id,
            firsname: docSnapshot.data()['firstname'],
            lastname: docSnapshot.data()['lastname'],
            email: docSnapshot.data()['email'],
            phone: docSnapshot.data()['phonenumber'],
            auth: docSnapshot.data()['authphone_uid']);

        uAcc.add(data);
        phone.add(docSnapshot.data()['phonenumber']);

        setState(() {
          fetchPhone = phone;
          userAcc = uAcc;
        });
      }
    });

    // print(user.email.toString());

    // int index = fetchPhone
    //     .indexWhere((element) => element == user.phoneNumber.toString());
    // print(index);

    setState(() {
      // findPhone = index;
    });
  }

  Future selectphoto() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.media, allowMultiple: false, withData: true);
      setState(() {
        selectname = result!.files.first.name;
        addimg = result!.files.first.bytes;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    return Container(
        color: Colors.white,
        child: Center(
            child: Column(
          children: [
            Container(
              child: SizedBox(height: 100),
            ),
            Container(
              child: Text(
                "Personal Information",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child: SizedBox(
                height: 10,
              ),
            ),
            if (user.email == null)
              Container(
                child: Column(children: [
                  Container(
                    child: Text(
                      'No Records Found!',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                  Container(
                    child: SizedBox(height: 15),
                  ),
                  Container(
                    child: InkWell(
                      child: Text(
                        'Verify now',
                        style: TextStyle(
                            fontSize: 22, decoration: TextDecoration.underline),
                      ),
                      onTap: () async {
                        setState(() {
                          uid = user.uid;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => information()));
                      },
                    ),
                  ),
                ]),
              ),
            if (user.email != null)
              Container(
                  child: Column(
                children: [
                  Container(
                    child: SizedBox(height: 10),
                  ),
                  Container(
                      height: 350,
                      child: ListView.builder(
                          itemCount: userAcc.length,
                          itemBuilder: (context, index) {
                            if (userAcc.length == 1) {
                              return Container(
                                child: Column(children: [
                                  if (addimg == null)
                                    Container(
                                      child: Stack(
                                        children: [
                                          CircleAvatar(
                                            radius: 100,
                                            backgroundImage: AssetImage(
                                                'lib/assets/profile.jpg'),
                                          ),
                                          Positioned(
                                              bottom: 20,
                                              right: 15,
                                              child: IconButton(
                                                onPressed: () async {
                                                  selectphoto();
                                                },
                                                icon: Icon(Icons.edit),
                                              ))
                                        ],
                                      ),
                                    ),
                                  if (addimg != null)
                                    Container(
                                      child: Stack(
                                        children: [
                                          CircleAvatar(
                                              radius: 100,
                                              backgroundImage: MemoryImage(
                                                Uint8List.fromList(addimg!),
                                              )),
                                          Positioned(
                                              bottom: 20,
                                              right: 15,
                                              child: IconButton(
                                                onPressed: () async {
                                                  selectphoto();
                                                },
                                                icon: Icon(Icons.edit),
                                              ))
                                        ],
                                      ),
                                    ),
                                  Container(
                                    child: SizedBox(height: 15),
                                  ),
                                  Container(
                                    child: Text(
                                      userAcc[index].firsname +
                                          ' ' +
                                          userAcc[index].lastname,
                                      style: TextStyle(fontSize: 22),
                                    ),
                                  ),
                                  Container(
                                    child: SizedBox(height: 10),
                                  ),
                                  Container(
                                    child: Text(
                                      userAcc[index].phone,
                                      style: TextStyle(fontSize: 22),
                                    ),
                                  ),
                                  Container(
                                    child: SizedBox(height: 10),
                                  ),
                                  Container(
                                    child: Text(
                                      userAcc[index].email,
                                      style: TextStyle(fontSize: 22),
                                    ),
                                  ),
                                ]),
                              );
                            }
                          })),
                ],
              )),
            Container(
              child: SizedBox(height: 5),
            ),
            Container(
              height: 50,
              width: 200,
              child: ElevatedButton(
                child: Text(
                  "Log out",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: () async {
                  FirebaseAuth.instance.signOut();
                },
              ),
            )
          ],
        )));
  }
}
