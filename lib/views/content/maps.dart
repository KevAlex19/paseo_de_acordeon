import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';

class MapScreen extends StatefulWidget {
  //MapScreen({Key key}) : super(key: key);
  String title;
  MapScreen(this.title);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Map<String, List<dynamic>> places = new Map<String, List<dynamic>>();
  List<double> latitude = new List<double>(), longitude = new List<double>();
  var tmp = Set<Marker>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Firestore.instance
        .collection("likes")
        .document(widget.title)
        .get()
        .then((value) {
      if (value.data != null) {
        latitude = places
            .putIfAbsent(widget.title, () => value.data["latitude"])
            .cast<double>();
        places = Map<String, List<dynamic>>();
        longitude = places
            .putIfAbsent(widget.title, () => value.data["longitude"])
            .cast<double>();
      } else {}

      for (var i = 0; i < latitude.length; i++) {
        setState(() {
          tmp.add(Marker(
              markerId: MarkerId("id" + i.toString()),
              position: LatLng(latitude[i], longitude[i])));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: Colors.blue,
          brightness: Brightness.light,
        ),
        preferredSize: Size.fromHeight(0.9),
      ),
      body: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: LatLng(10.460642, -73.239397), zoom: 12),
        markers: tmp,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
