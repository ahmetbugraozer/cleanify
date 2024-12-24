import 'dart:async';
import 'package:cleanify/elements/project_elements.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PostMapView extends StatefulWidget {
  final double latitude;
  final double longtitude;
  const PostMapView(
      {super.key, required this.latitude, required this.longtitude});
  @override
  State<PostMapView> createState() => _PostMapViewState();
}

//aim to view one marker(defined by user)
class _PostMapViewState extends State<PostMapView> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  late LatLng userPollutionLocation;
  late CameraPosition firstPosition;
  late Marker userPollutionMarker;
  @override
  void initState() {
    super.initState();
    userPollutionLocation = LatLng(
        widget.latitude,
        widget
            .longtitude); //marker location that selected by user while posting (need instance from firebase)

    firstPosition = CameraPosition(
        target: userPollutionLocation,
        zoom:
            15); // firstPosition coordinations must match with userPollutionLocation coordinations

    userPollutionMarker = Marker(
        markerId: const MarkerId("pollution"),
        position:
            userPollutionLocation, //marker that selected by user while posting (need instance from firebase)
        infoWindow: const InfoWindow(title: "Pollution"));
  }

  //might add author username here

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5),
        child: Scaffold(
            appBar: const CommonAppbar(preference: "back"),
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
                    markers: {userPollutionMarker}))));
  }
}
