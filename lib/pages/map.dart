import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

class googleMap extends StatefulWidget {
  const googleMap({super.key});

  @override
  State<googleMap> createState() => _googleMapState();
}

class _googleMapState extends State<googleMap> {
  // Completer<GoogleMapController> _googleMapController = Completer();

  // CameraPosition? _cameraPosition;

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() {
    // _cameraPosition =
    //     CameraPosition(target: LatLng(11.576262, 104.92222), zoom: 15);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: _buildBody(),
    );
  }

  // Widget _buildBody() {
  //   return _getMap();
  // }

  // Widget _getMap() {
    // return GoogleMap(
    //   initialCameraPosition: _cameraPosition!,
    //   mapType: MapType.normal,
    //   onMapCreated: (GoogleMapController controller) {
        // if (!_googleMapController.isCompleted) {
        //   _googleMapController.complete(controller);
        // }
    //   },
    // );
  // }
}
