import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../find_city/find_city_screen.dart';

class VehiclesStand extends StatefulWidget {
  VehiclesStand({Key? key}) : super(key: key);

  @override
  State<VehiclesStand> createState() => _VehiclesStandState();
}

class _VehiclesStandState extends State<VehiclesStand> {
  var tes;
  @override
  void initState() {

    // TODO: implement initState

    super.initState();
    getLocation();
    vehicaleStand();
    print("koooooi");
   
  }

  bool isVehicleInStand = false;
  double _distance = 0;

  double roundDistanceInKM = 0;

  List<double> lat = [
    50.08155798581401,
    50.08053216096673,
    50.08155798584600,
    50.08053216097966,
  ];

  List<double> long = [
    8.24199914932251,
    8.242063522338867,
    8.24199914937777,
    8.242063522336666,
  ];
  double? currentLat;
  double? currentLong;

// final listOfLatLngs = [
//     const LatLng(50.08155798581401, 8.24199914932251),
//     const LatLng(50.08053216096673, 8.242063522338867),
//     const LatLng(50.080614778545716, 8.243619203567505),
//     const LatLng(50.0816956787534, 8.243404626846313),
//     const LatLng(50.08155798581401, 8.24199914932251),
//   ];
  Future<Position> getLocation() async {
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
      return Future.error(Exception('Location permissions are permanently denied.'));
    } 

    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error(Exception('Location permissions are denied.'));
    }
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
  vehicaleStand() async {
    List<double> distanceInMeters = [];

    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var distanceInMeeter = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      11.1529333,
      76.1721999,
    );
    currentLat = currentPosition.latitude;
    currentLong = currentPosition.longitude;

    print(currentPosition.latitude);
    print(currentPosition.longitude);

    if (distanceInMeeter < 7000) {
      distanceInMeters.add(distanceInMeeter);
      setState(() {
        isVehicleInStand = true;
        _distance = distanceInMeeter;
      });
      print(_distance);
    }
  }

  @override
  Widget build(BuildContext context) {
    // getCurrentLocation();
    // meeterToKm();
    print("helllo");
    print("vehicle is on stand  '$isVehicleInStand'");
    ;
    return Scaffold(
      body: Center(
              child: Container(color: Colors.green, child: Text(currentLat.toString()))),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Future<Position> getLocation() async {
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
      return Future.error(Exception('Location permissions are permanently denied.'));
    } 

    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error(Exception('Location permissions are denied.'));
    }
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            //Get the current location
            getLocation();
          },
          child: Text('Get Location'),
        ),
      ),
    );
  }
}
