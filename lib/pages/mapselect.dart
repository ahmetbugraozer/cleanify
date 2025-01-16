import 'package:cleanify/elements/project_elements.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSelect extends StatefulWidget {
  const MapSelect({super.key});

  @override
  State<MapSelect> createState() => _MapSelectState();
}

class _MapSelectState extends State<MapSelect> {
  Set<Marker> markers = {};
  static const CameraPosition _kMain =
      CameraPosition(target: LatLng(39.93327778, 32.85980556), zoom: 14);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CommonAppbar(preference: "back"),
        body: GoogleMap(
            initialCameraPosition: _kMain,
            onTap: (location) {
              setState(() {
                markers
                    .add(createMarker("newPollution", location, "Pollution"));
              });
            },
            markers: markers),
        floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 130),
            child: FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: ProjectColors.projectPrimaryWidgetColor),
                onPressed: () {
                  markers.isNotEmpty
                      ? Navigator.of(context).pop(markers.elementAt(0).position)
                      : ();
                },
                child: const Text('Select Map',
                    style: ProjectTextStyles.styleDrawerTextLine))));
  }

  Marker createMarker(String id, LatLng position, String title) {
    return Marker(
        draggable: true,
        markerId: MarkerId(id),
        position: position,
        infoWindow: InfoWindow(title: title),
        onDragEnd: ((LatLng newPosition) {
          debugPrint(newPosition.latitude.toString());
          debugPrint(newPosition.longitude.toString());
        }));
  }

  // void deneme(String id, LatLng position, String title) {
  //   markers.add(Marker(
  //       markerId: MarkerId(id), // adding multiple markers in one selectio
  //       position: position,
  //       infoWindow: InfoWindow(title: title)));
  // }
}
