import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CityModel with ChangeNotifier {
  int _count = 0;
  String _nameShop = "super market";

  String _city = "manjeri";
  String _subCity = "elankur";
  String _ownership = "User";

  String _numberShop = "9995498550";
  String get nameShop => _nameShop;
  String get numberShop => _numberShop;

  String get city => _city;
  String get subCity => _subCity;
  String get ownership => _ownership;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  addNameShop(String nameShop) {
    _nameShop = nameShop;
    notifyListeners();
  }

  addCity(String city, String subCity) {
    _city = city; // Set the _city variable to the given city value
    _subCity = subCity; // Set the _subCity variable to the given subCity value
    notifyListeners(); // Notify listeners that the state has changed
  }

  addNumber(String numberShop) {
    _numberShop = numberShop;
    notifyListeners();
  }

  addOwnership(String ownership) {
    _ownership = ownership;
    notifyListeners();
  }

  String _kProductpageLink =
      "/productpage?id=,manjeri,elankur,9995498550,biriyani,212";
  get kProductpageLink => _kProductpageLink;

  addDeepLinkId(value) {
    _kProductpageLink = value;
    notifyListeners();
  }

  var cameras = [];

  setCameras(var newCameras) {
    cameras = newCameras;
    notifyListeners();
  }

  final List<XFile> _selectedFiles = [];
  get selectedFiles => _selectedFiles;
  addSelectedFiles(value) {
    _selectedFiles.addAll(value);

    notifyListeners();
  }

  void clearSelectedFiles() {
    _selectedFiles.clear();
    notifyListeners();
  }

  final List<String> _downloadUrls = [];
  List<String> get downloadUrls => _downloadUrls;

  addDownloadUrls(value) {
    _downloadUrls.add(value);

    notifyListeners();
  }

  void clearDownloadUrls() {
    _downloadUrls.clear();
    notifyListeners();
  }

  String _productId = "";
  get productId => _productId;
  addNameProduct(value) {
    _productId = value;

    notifyListeners();
  }

  String _category = "";
  get category => _category;
  addCategory(value) {
    _category = value;
    notifyListeners();
  }

  TextEditingController _pro_price = TextEditingController();
  TextEditingController _pro_name = TextEditingController();
  TextEditingController _pro_description = TextEditingController();

  // getter methods for the controllers
  TextEditingController get proPriceController => _pro_price;
  TextEditingController get proNameController => _pro_name;
  TextEditingController get proDescriptionController => _pro_description;

  set proPriceController(TextEditingController value) {
    _pro_price = value;
    notifyListeners();
  }

  set proNameController(TextEditingController value) {
    _pro_name = value;
    notifyListeners();
  }

  set proDescriptionController(TextEditingController value) {
    _pro_description = value;
    notifyListeners();
  }

  bool _isUploading = false;

  bool get isUploading => _isUploading;

  void set isUploading(bool value) {
    _isUploading = value;
    notifyListeners();
  }

  double _progress = 0.0;

  double get progress => _progress;

  void set progress(double value) {
    _progress = value;
    notifyListeners();
  }

  Map _currentlatlong = {};

  Map get currentLatLong => _currentlatlong;

  set currentLatLong(value) {
    _currentlatlong = value;
    notifyListeners();
  }

  double _distance = 0.0;

  double get distance => _distance;

  set distance(value) {
    _distance = value;
    notifyListeners();
  }

  List<bool> _isSelected = [true, false, false];

  get isSelected => _isSelected;

  set isSelected(index) {
    for (int i = 0; i < _isSelected.length; i++) {
      if (i == index) {
        _isSelected[i] = true;
      } else {
        _isSelected[i] = false;
      }
    }
    notifyListeners();
  }
}
