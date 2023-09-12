import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jb1/data/api.dart';
import 'package:jb1/pages/home.dart';
import 'package:jb1/pages/tracking.dart';

class viewDetails extends StatefulWidget {
  const viewDetails({super.key});

  @override
  State<viewDetails> createState() => _viewDetailsState();
}

List<Trackers> listtrack = [];

class _viewDetailsState extends State<viewDetails> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  void initState() {
    super.initState();

    List<Trackers> trackers = [];

    db
        .collection('tracker_collection')
        .where('trackingnum', isEqualTo: idDetails)
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
          listtrack = trackers;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    return Container(
        height: 350,
        child: Column(
          children: [
            Container(
              child: Text(
                'Tracking Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 280,
              child: ListView.builder(
                  itemCount: listtrack.length,
                  itemBuilder: (context, index) {
                    if (listtrack.length == 0) {
                      return Container(
                        child: Text('No Details Found!'),
                      );
                    } else {
                      return Container(
                        child: Column(children: [
                          Container(
                            child: SizedBox(height: 10),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 35),
                            child: Row(
                              children: [
                                Container(
                                  child: Text('Tracking Number:'),
                                ),
                                Container(
                                  child: SizedBox(width: 10),
                                ),
                                Container(
                                  child: Text(listtrack[index].trackingnum),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 35),
                            child: Row(children: [
                              Container(
                                child: Text('Pick up'),
                              ),
                              Container(
                                child: Text(listtrack[index].pickuploc),
                              )
                            ]),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 35),
                            child: Row(children: [
                              Container(
                                child: Text('Delivery'),
                              )
                            ]),
                          )
                        ]),
                      );
                    }
                  }),
            )
          ],
        ));
  }
}
