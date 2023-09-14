import 'dart:async';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:jb1/components/openDetails.dart';
import 'package:jb1/data/api.dart';
import 'package:jb1/pages/addTracker.dart';
import 'package:jb1/pages/information.dart';
import 'package:jb1/pages/trackerupdate.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

List<Trackers> listTracker = [];

class _homeState extends State<home> {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  /// Controller to handle PageView and also handles initial page
  final _pageController = PageController(initialPage: 0);

  /// Controller to handle bottom nav bar and also handles initial page
  final _controller = NotchBottomBarController(index: 0);

  int maxCount = 5;

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
    const Page4(),
  ];
  void initState() {
    super.initState();

    List<Trackers> trackers = [];

    db
        .collection('tracker_collection')
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

        trackers.add(data);

        setState(() {
          listTracker = trackers;
        });
      }
    });
  }

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
                    Icons.map,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.map,
                    color: Colors.white,
                  ),
                  itemLabel: 'Page 2',
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
                  itemLabel: 'Page 3',
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
                  itemLabel: 'Page 4',
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

class _Page1State extends State<Page1> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  void initState() {
    super.initState();

    List<Trackers> trackers = [];

    db
        .collection('tracker_collection')
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

        trackers.add(data);

        setState(() {
          listTracker = trackers;
        });
      }
    });
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
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
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                Container(
                  height: sh,
                  child: ListView.builder(
                      itemCount: listTracker.length,
                      itemBuilder: ((context, index) {
                        if (trackingnum.isEmpty) {
                          return Container(
                            height: 265,
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
                                  margin: EdgeInsets.only(left: 48),
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
                                              color: Colors.red, fontSize: 22),
                                        ),
                                      ),
                                    if (listTracker[index].status == 'STARTED')
                                      Container(
                                        child: Text(
                                          listTracker[index].status,
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 22),
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
                                  margin: EdgeInsets.only(left: 48),
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
                                              color: Colors.red, fontSize: 22),
                                        ),
                                      ),
                                    if (listTracker[index].status == 'STARTED')
                                      Container(
                                        child: Text(
                                          listTracker[index].status,
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 22),
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
              return trackerupdate();
            }),
          );
        }).then((value) => {setState(() {})});
  }
}

class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);
  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    return Container(
        color: Colors.white,
        child: const Center(
          // child: GoogleMap(
          //     initialCameraPosition:
          //         CameraPosition(target: sourceLocation))
          child: Text("Page 2"),
        ));
  }
}

class Page3 extends StatefulWidget {
  const Page3({Key? key}) : super(key: key);
  @override
  State<Page3> createState() => _Page3State();
}

List<accTracker> accTrack = [];

class _Page3State extends State<Page3> {
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
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
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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

class Page4 extends StatefulWidget {
  const Page4({Key? key}) : super(key: key);
  @override
  State<Page4> createState() => _Page4State();
}

String? uid;
int? findPhone;
List fetchPhone = [];
List<Users> userAcc = [];
String? newnum;

class _Page4State extends State<Page4> {
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
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child: SizedBox(
                height: 25,
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
                    child: SizedBox(height: 15),
                  ),
                  Container(
                      height: 200,
                      child: ListView.builder(
                          itemCount: userAcc.length,
                          itemBuilder: (context, index) {
                            if (userAcc.length == 1) {
                              return Container(
                                child: Column(children: [
                                  Container(
                                    child: Text(
                                      userAcc[index].firsname +
                                          ' ' +
                                          userAcc[index].lastname,
                                      style: TextStyle(fontSize: 22),
                                    ),
                                  ),
                                  Container(
                                    child: SizedBox(height: 15),
                                  ),
                                  Container(
                                    child: Text(
                                      userAcc[index].phone,
                                      style: TextStyle(fontSize: 22),
                                    ),
                                  ),
                                  Container(
                                    child: SizedBox(height: 15),
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
              child: SizedBox(height: 30),
            ),
            Container(
              height: 50,
              width: 200,
              child: ElevatedButton(
                child: Text(
                  "Sign Out",
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
