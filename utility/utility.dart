import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'dart:ui';
class Utility extends StatefulWidget {
  const Utility({Key? key}) : super(key: key);

  @override
  State<Utility> createState() => _UtilityState();
}

class _UtilityState extends State<Utility> {
  // Display display = Display();
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return const SizedBox();
  }
}

class Display with ChangeNotifier {
  double _width = 0;
  double _height = 0;

  String _city = "manjeri";
  String _subCity = "elankur";
  String _ownership = "User";
  String _shopName = "x";

  String get shopName => _shopName;

  String get city => _city;
  String get subCity => _subCity;
  String get ownership => _ownership;
  double get width => _width;
  double get height => _height;
  addWidthHieght(width, height) {
    _width = width;
    _height = height;

    notifyListeners();
  }
}

class Business {
  static const headline6 = const TextStyle(
    fontSize: 24,
  );

  static final headline5 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black.withOpacity(0.3),
  );
}


class ScreenSize {
  static Size get size {
    return window.physicalSize / window.devicePixelRatio;
  }
}