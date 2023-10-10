import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

// import 'package:near_mine/home/home_screen.dart';

import 'package:near_mine/utility/utility.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';

import 'authentication/phone_authentication_success/log_in_page.dart';
// import 'authentication/phone_authentication_success/otp_in_page.dart';
import 'average_location/average_location_logic.dart';
import 'package:camera/camera.dart';

import 'deep_linking/route_services.dart';
import 'find_city/find_city_screen.dart';
import 'find_city/provider/data.dart';
import 'home/app_bussiness/provider/provider_bussiness.dart';
import 'home/app_user/provider/provider_user.dart';

import 'ownership/ownership_screen.dart';

import 'dart:async';
import 'dart:math';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

//   final cameras = await availableCameras();
//   final cityModel = CityModel();

   await Firebase.initializeApp(
    // Replace with actual values
    options: FirebaseOptions(
      apiKey: "AIzaSyDFqW2I_WCNuWbrZJsYY6FGGKgLKdKRC_U",
      appId: "1:135429557144:web:25158f893d4a86460db9ed",
      messagingSenderId: "135429557144",
      projectId: "near-mine",
    ),
  );
  
  runApp(
    MyApp()
  );
}
// Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp();
//   final cameras = await availableCameras();
//   final cityModel = CityModel();

  //  await Firebase.initializeApp(
  //   // Replace with actual values
  //   options: FirebaseOptions(
  //     apiKey: "AIzaSyDFqW2I_WCNuWbrZJsYY6FGGKgLKdKRC_U",
  //     appId: "1:135429557144:web:25158f893d4a86460db9ed",
  //     messagingSenderId: "135429557144",
  //     projectId: "near-mine",
  //   ),
  // );

//   SharedPreferences pref = await SharedPreferences.getInstance();
//   var email = pref.get("email");

//   // var email = "dhi@gmail.com";

//   print("${email} : email id");

//   logic();

//   // getCurrentLocation();

//   final initialLink = await getInitialLink();
//   if (initialLink != null) {
//     initialLink.length > 10 ? print("great") : print("less");
//   }

//   print("initialLink");
//   print(initialLink);

//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => CityModel()),
//         ChangeNotifierProvider(create: (_) => ProviderBussiness()),
//         ChangeNotifierProvider(create: (_) => ProviderUser()),
//       ],
//       // child: MyApp(email: email),
//       // child: MyApps(),
//       child: MyApp(email: email, cameras: cameras),
//     ),
//   );
// }

class MyApp extends StatefulWidget {
  
  MyApp({Key? key, }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RouteServices.generateRoute,
         routes: {

           '/home': (context) => const OwnershipScreen(),
         
        //   // '/details': (context) => DetailsPage(),
         },
        theme: ThemeData(
          bottomSheetTheme: const BottomSheetThemeData(),
        ),
        home: LogPage());
  }
}
// class MyApp extends StatefulWidget {
  
//   MyApp({Key? key, required this.email, this.cameras}) : super(key: key);

//   var email;

//   var cameras;

//   @override
//   State<MyApp> createState() => _MyAppState();

// }

// class _MyAppState extends State<MyApp> {

//   @override
//   Widget build(BuildContext context) {
//     print("${widget.email} : email id");

//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         onGenerateRoute: RouteServices.generateRoute,
//         routes: {

//           '/home': (context) => const OwnershipScreen(),
         
//           // '/details': (context) => DetailsPage(),
//         },
//         theme: ThemeData(
//           bottomSheetTheme: const BottomSheetThemeData(),
//         ),
//         home: widget.email == null
//             ? const LogPage()

//             // ? const OwnershipScreen()
//             // ? ShirtMatch(cameras: widget.cameras)

//             : const LogPage());
//   }
// }

// c5:ad:ed:a8:b9:73:85:bb:7e:04:75:ba:6e:9c:7e:45:86:ca:3f:0d
// bb:f6:33:e7:32:c7:77:0e:65:97:f7:ac:13:b2:66:8d:08:14:8e:fa:b1:97:cd:21:da:8e:a1:8d:81:48:bb:3f

class SSs extends StatelessWidget {
  const SSs({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        color: Colors.red,
        width: 340,
        height: 500,
      ),
    );
  }
}

class ShirtMatch extends StatefulWidget {
  const ShirtMatch({super.key, required this.cameras, required this.shirt});
  final String shirt;
  final List<CameraDescription> cameras;
  @override
  _ShirtMatchState createState() => _ShirtMatchState();
}

class _ShirtMatchState extends State<ShirtMatch>
    with SingleTickerProviderStateMixin {
  late String _headImageUrl;
  late String _shirtImageUrl;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late List<CameraDescription> cameras;
  int currentCameraIndex = 0;
  late TabController _tabController;
  final TransformationController _headController = TransformationController();
  final TransformationController _shirtController = TransformationController();
  final TransformationController _camController = TransformationController();

  @override
  void initState() {
    super.initState();
    _headImageUrl =
        'https://www.filmibeat.com/img/2018/06/dulquersalmaan1-1528374179.jpg';
    _shirtImageUrl = widget.shirt;
    _tabController = TabController(length: 2, vsync: this);
    initialZoom();
    _initializeCamera();
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController.dispose();
    _headController.dispose();
    super.dispose();
  }

  initialZoom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenSize = MediaQuery.of(context).size;
      final imageSize =
          Size(ScreenSize.size.width, ScreenSize.size.height / 2.7);
      final centerPoint = Offset(imageSize.width / 2, imageSize.height / 2);
      final matrixHead = Matrix4.identity()
        ..translate(screenSize.width / 2 + 100, screenSize.height / 2 - 100)
        ..scale(3.0)
        ..translate(-centerPoint.dx, -centerPoint.dy);

      final matrixShirt = Matrix4.identity()
        ..translate(screenSize.width / 2 + 240, screenSize.height / 2 - 100)
        ..scale(5.0)
        ..translate(-centerPoint.dx, -centerPoint.dy);
      final matrixCam = Matrix4.identity()
        ..translate(screenSize.width / 2 + 50, screenSize.height / 2 - 100)
        ..scale(3.0)
        ..translate(-centerPoint.dx, -centerPoint.dy);
      _headController.value = matrixHead;
      _shirtController.value = matrixShirt;
      _camController.value = matrixCam;
    });
  }

  Future<void> _initializeCamera() async {
    cameras = widget.cameras;
    setState(() {
      _controller = CameraController(
        cameras[currentCameraIndex],
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _controller.initialize();
    });
  }

  void _toggleCamera() {
    setState(() {
      currentCameraIndex = (currentCameraIndex + 1) % cameras.length;
      _controller = CameraController(
        cameras[currentCameraIndex],
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _controller.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Fun Shirt Match',
        ),
      ),
      body: Column(
        children: [
          TabBar(
            isScrollable: false,
            controller: _tabController,
            labelColor: Colors.white,
            indicatorColor: Colors.grey,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'Shirt Image'),
              Tab(text: 'Camera Preview'),
            ],
          ),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      // left: 30.0,
                      // right: 30,
                      ),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 30.0, left: 30.0, top: 30.0),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                              child: InteractiveViewer(
                                constrained: true,
                                transformationController: _headController,
                                child:  Image.asset(
                                  'assets/aa.jpeg',
                                  fit: BoxFit.contain,
                                  height: ScreenSize.size.height / 2.7,
                                  width: double.infinity,
                                ),
                                // child: Image.network(
                                //   _headImageUrl,
                                //   // fit: BoxFit.contain,
                                //   height: ScreenSize.size.height / 2.7,
                                //   width: double.infinity,
                                // ),
                                minScale: 0.1,
                                maxScale: 5.0,
                                // boundaryMargin: EdgeInsets.all(10),
                                scaleEnabled: true, // enable scaling
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(
                              11,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 30.0, right: 30, top: 30),
                              child: InteractiveViewer(
                                constrained: true,
                                transformationController: _shirtController,
                                child: Image.network(
                                  _shirtImageUrl,
                                  // "https://rukminim1.flixcart.com/image/832/832/xif0q/shirt/u/o/y/m-bhmls22023-being-human-original-imagktyvzvrvfdmz.jpeg?q=70",
                                  width: double.infinity,
                                ),
                                minScale: 0.1,
                                maxScale: 5.0,
                                // boundaryMargin: EdgeInsets.all(10),
                                scaleEnabled: true, // enable scaling
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      shadowStick(
                          height: 12.6, width: 1, right: 0.0, left: 0.0),
                      shadowStick(height: 1, width: 9, left: 0.0, right: null),
                      shadowStick(height: 1, width: 9, left: null, right: 0.0)
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Stack(
                    // alignment: Alignment.bottomCenter,
                    children: [
                      Center(
                        child: cameras == null || _controller == null
                            ? const CircularProgressIndicator()
                            : FutureBuilder<void>(
                                future: _initializeControllerFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Switch(
                                          value: currentCameraIndex == 0,
                                          onChanged: (value) {
                                            _toggleCamera();
                                          },
                                          activeColor: Colors
                                              .white, // set the color of the switch when it is turned on
                                          inactiveThumbColor: Colors
                                              .white, // set the color of the switch when it is turned off
                                          inactiveTrackColor: Colors
                                              .grey, // set the background color of the switch when it is turned off
                                        ),
                                        InteractiveViewer(
                                          constrained: true,
                                          transformationController:
                                              _camController,

                                          child: CameraPreview(
                                            _controller,
                                          ),

                                          minScale: 0.1,
                                          maxScale: 5.0,
                                          boundaryMargin:
                                              const EdgeInsets.all(10),
                                          scaleEnabled: true, // enable scaling
                                        ),
                                      ],
                                    );
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Container(
                          color: Colors.black,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: ScreenSize.size.height / 2.5,
                                width: ScreenSize.size.width,
                                child: InteractiveViewer(
                                  constrained: true,
                                  transformationController: _shirtController,
                                  child: Image.network(
                                    _shirtImageUrl,
                                    fit: BoxFit.contain,
                                  ),
                                  minScale: 0.1,
                                  maxScale: 5.0,
                                  scaleEnabled: true, // enable scaling
                                ),
                              ),
                              Positioned(
                                right: 0,
                                left: 0,
                                top: 0,
                                child: Container(
                                  height: 40,
                                  width: double.infinity,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  shadowStick({double? height, double? width, dynamic left, dynamic right}) {
    return Positioned(
      top: 50,
      right: right,
      left: left,
      bottom: 0,
      child: Align(
          alignment: Alignment.center,
          child: Container(
            width: ScreenSize.size.width / width!,
            height: ScreenSize.size.height / height!,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          )),
    );
  }
}

class MyApps extends StatefulWidget {
  const MyApps({super.key});

  @override
  _MyAppsState createState() => _MyAppsState();
}

class _MyAppsState extends State<MyApps> {
  StreamSubscription<Position>? _positionStream;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();

    // Check the device's connectivity status
    _checkConnectivity();

    // Start tracking the user's location
    _startTracking();
  }

  @override
  void dispose() {
    // Stop tracking the user's location
    _stopTracking();

    super.dispose();
  }

  Future<void> _startTracking() async {
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
        return Future.error(Exception('permenently permissions are denied.'));
      }
    }

    // Get the user's current location
    Position currentPosition = await Geolocator.getCurrentPosition();

    // Add the current location to Firestore
    await _updateFirestore(currentPosition);

    // Listen for location updates
    // Add the current location to Firestore
    await _updateFirestore(currentPosition);

    // Listen for location updates
    _positionStream =
        Geolocator.getPositionStream().listen((Position position) async {
      // Check if the device is offline
      if (_isOffline) {
        // Save the update to a local database
        await _saveToDatabase(position);
      } else {
        // Check if the user has moved more than 1km from their starting location
        final double distance = _calculateDistance(
          currentPosition.latitude,
          currentPosition.longitude,
          position.latitude,
          position.longitude,
        );
        print(distance);

        if (distance >= 1000) {
          // Update Firestore with the new location
          await _updateFirestore(position);

          // Update the current position
          setState(() {
            currentPosition = position;
          });
        }
      }
    });
  }

  void _stopTracking() {
    _positionStream?.cancel();
  }

  Future<void> _updateFirestore(Position position) async {
    final CollectionReference locations =
        FirebaseFirestore.instance.collection('locations');
    await locations.doc('current').set({
      'latitude': position.latitude,
      'longitude': position.longitude,
    });
  }

  Future<void> _saveToDatabase(Position position) async {
    // Implement local database storage here
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double p = 0.017453292519943295;
    double c = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(c));
  }

  Future<void> _checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          _isOffline = false;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        _isOffline = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Tracker',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Location Tracker'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Current Location:',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 16),
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('locations')
                    .doc('current')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  final data = snapshot.data?.data() as Map;
                  final latitude = data['latitude'];
                  final longitude = data['longitude'];

                  return Column(
                    children: <Widget>[
                      Text(
                        'Latitude: $latitude',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Longitude: $longitude',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
