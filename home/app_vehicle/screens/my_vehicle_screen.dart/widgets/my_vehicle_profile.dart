import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../../../../find_city/provider/data.dart';

class MyVehicleStatus extends StatefulWidget {
  const MyVehicleStatus({super.key});

  @override
  State<MyVehicleStatus> createState() => _MyVehicleStatusState();
}

class _MyVehicleStatusState extends State<MyVehicleStatus>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  void _onStatusSelected(CityModel model, int index) {
    model.isSelected = index;

    // setState(() {});
    var driverStatus = FirebaseFirestore.instance
        .collection("Place")
        .doc("manjeri")
        .collection("SubCity")
        .doc("elankur")
        .collection("vehicles")
        .doc("7907156601");
    if (index == 0) {
      driverStatus.update({
        "status_driver": _statusOptions[index]["text"],
        "status_time": FieldValue.serverTimestamp(),
      });
    } else {
      driverStatus.update({
        "status_driver": _statusOptions[index]["text"],
        "status_time": FieldValue.serverTimestamp(),
        "status_range": false
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  static const List<Map<String, dynamic>> _statusOptions = [
    {'text': '🚗 Vehicle Stand', 'icon': Icons.directions_car},
    {'text': '🤔 Busy', 'icon': Icons.hourglass_top},
    {'text': '🏠 Home', 'icon': Icons.home},
  ];

  Future<Position> getLocation(CityModel model, docLatLONG) async {
    // Test if location services are enabled.
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            Exception('Location permissions are permanently denied.'));
      }

      if (permission == LocationPermission.denied) {
        return Future.error(Exception('Location permissions are denied.'));
      }
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(
            Exception('Location permissions are permanently denied.'));
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    model.currentLatLong = {
      "lat": position.latitude,
      "long": position.longitude
    };
    var statusDriver = FirebaseFirestore.instance
        .collection("Place")
        .doc("manjeri")
        .collection("SubCity")
        .doc("elankur")
        .collection("vehicles")
        .doc("7907156601");
    var statusRange;
    statusDriver.snapshots().listen((snapshot) {
      var data = snapshot.data() as Map;
      statusRange = data["status_range"] ?? true;
      // Do something with the updated status here
    });
    await docLatLONG.then((documentSnapshot) {
      // Get the value of the "fieldName" field from the document
      var subCityLat = documentSnapshot.get("lat");
      var subCityLong = documentSnapshot.get("long");
      double distance = Geolocator.distanceBetween(
        model.currentLatLong["lat"],
        model.currentLatLong["long"],
        double.parse(subCityLat),
        double.parse(subCityLong),
      );
      print("distance");
      double distanceInKm = distance / 1000;
      print(distanceInKm.toStringAsFixed(3));
      if (distanceInKm <= 2.205) {
        model.distance = distance;
        print("${distance.toStringAsFixed(0)} meeter");
        statusDriver.update({"status_range": true});
      } else {
        statusDriver.update({"status_range": false});
      }

      print("Field value: $subCityLat");
      print("Field value: $subCityLong");
    }).catchError((error) {
      // Handle any errors that occurred while retrieving the document
      print("Error: $error");
    });

    print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');

    return position;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Provider.of<CityModel>(context, listen: true)
            .currentLatLong
            .toString()),
        Text(Provider.of<CityModel>(context, listen: true).distance.toString()),
        const SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(3, (index) {
            var model = Provider.of<CityModel>(context, listen: true);
            final selected = model.isSelected[index];
            // final selected = false;

            final icon = _statusOptions[index]['icon'];
            final text = _statusOptions[index]['text'];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  border: selected
                      ? Border.all(color: Colors.blue, width: 2.0)
                      : null,
                  borderRadius: BorderRadius.circular(8.0),
                  color: selected ? Colors.blue.withOpacity(0.1) : null,
                ),
                child: Stack(
                  children: [
                    TextButton(
                      onPressed: () {
                        var model =
                            Provider.of<CityModel>(context, listen: false);
                        var docLatLONG = FirebaseFirestore.instance
                            .collection("Place")
                            .doc("manjeri")
                            .collection("SubCity")
                            .doc("elankur")
                            .get();

                        getLocation(model, docLatLONG);
                        // getLocationInBackground(model, docLatLONG);
                        _onStatusSelected(model, index);
                        setState(() {});
                      },
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(Size(70, 140)),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 10,
                            right: 0,
                            left: 0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  icon,
                                  size: 50,
                                  color: selected ? Colors.blue : Colors.grey,
                                ),
                              ],
                            ),
                          ),
                          if (selected)
                            Positioned(
                              top: 30,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ScaleTransition(
                                    scale: _animationController,
                                    child: Icon(
                                      icon,
                                      size: 50,
                                      color: Colors.blue.withOpacity(0.3),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      right: 0,
                      left: 0,
                      child: Center(
                        child: Text(
                          text,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12.0,
                              color: selected ? Colors.blue : Colors.grey,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
