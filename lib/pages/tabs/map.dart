// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:async';
import 'dart:math';
import 'package:cleanify/elements/project_elements.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Set<Marker> pollutionMarkers = {};

  Future<void> _fetchAndSetPollutionLocations() async {
    List<LatLng> pollutionLocations = [];
    List<String> fullName = [];
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("posts").get();
    snapshot.docs.forEach((DocumentSnapshot document) {
      Map<String, dynamic>? data = document.data() as Map<String, dynamic>;
      double latitude = data['altitude'];
      double longitude = data['longtitude'];
      fullName.add(data["fullName"]);
      pollutionLocations.add(LatLng(latitude, longitude));
    });

    List<LatLng> pollutions = pollutionLocations;

    Set<Marker> markers = {};
    for (int i = 0; i < pollutions.length; i++) {
      markers.add(Marker(
        markerId: MarkerId('pollution$i'),
        position: pollutions[i],
        infoWindow: InfoWindow(title: fullName[i]),
      ));
    }

    setState(() {
      pollutionMarkers = markers;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchAndSetPollutionLocations();
  }

  static const CameraPosition firstPosition = CameraPosition(
      target: LatLng(39.93327778, 32.85980556),
      zoom: 14); //might be any of markers(randomly)

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5),
        child: Scaffold(
            body: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                        width: 3, color: ProjectColors.imageBorderColor)),
                child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: firstPosition,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    markers: pollutionMarkers)),
            bottomNavigationBar: FloatingActionButton.extended(
                backgroundColor: ProjectColors.projectPrimaryWidgetColor,
                onPressed: _goToThePollution,
                label: const Text('Navigate between pollutions'),
                icon: const Icon(Icons.map_outlined))));
  }

  Future<void> _goToThePollution() async {
    final GoogleMapController controller = await _controller.future;
    var randomPollution = Random().nextInt(pollutionMarkers
        .length); //to navigate between camerapositions on the map
    CameraPosition kPollution = CameraPosition(
        target: pollutionMarkers.elementAt(randomPollution).position, zoom: 16);
    await controller.animateCamera(CameraUpdate.newCameraPosition(kPollution));
  }

  Future<List<LatLng>> getPollutionLocationsFromFirestore() async {
    List<LatLng> pollutionLocations = [];
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("posts").get();
    snapshot.docs.forEach((DocumentSnapshot document) {
      Map<String, dynamic>? data = document.data() as Map<String, dynamic>;
      double latitude = data['altitude'];
      double longitude = data['longtitude'];
      pollutionLocations.add(LatLng(latitude, longitude));
    });

    return pollutionLocations;
  }
}
