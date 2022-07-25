import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps extends StatefulWidget {
  final LatLng target;
  const Maps({Key? key, required this.target}) : super(key: key);

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  CameraPosition? initialCameraPosition;
  LatLng? _currentMarker;

  Set<Marker> latlngSet = <Marker>{};

  @override
  void initState() {
    super.initState();
    // initialCameraPosition = CameraPosition(target: widget.target);
    initialCameraPosition = CameraPosition(
      target: widget.target,
      zoom: 15,
    );
  }

  final Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void dispose() {
    super.dispose();
    _controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        title: const Text(
          "Feedback Location",
          // style: TextStyle(color: Colors.black),
        ),
      ),
      body: GoogleMap(
        circles: <Circle>{
          Circle(
            circleId: const CircleId("center"),
            center: widget.target,
            fillColor: Colors.lightBlue.withOpacity(0.3),
            radius: 80,
            strokeWidth: 1,
            strokeColor: Colors.blue,
            visible: true,
          ),
        },
        onMapCreated: _onMapCreated,
        initialCameraPosition: initialCameraPosition!,
        markers: <Marker>{
          Marker(
            markerId: const MarkerId('main'),
            position: widget.target,
          ),
          _currentMarker != null
              ? Marker(
                  markerId: const MarkerId('current_tap_position'),
                  position: _currentMarker!,
                )
              : const Marker(markerId: MarkerId('current_tap_position')),
        },
        buildingsEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapToolbarEnabled: true,
        compassEnabled: true,
        onTap: (_currentTapPosition) {
          setState(() {
            _currentMarker = _currentTapPosition;
          });
        },
        // onLongPress: (_currentTapPosition){
        //   if(_currentTapPosition == _currentMarker) {}
        // },
      ),
    );
  }

  // void addMarkerInSet() {
  //   latlngSet.add(value);
  // }
}
