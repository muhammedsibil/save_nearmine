import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:near_mine/home/app_user/models/product_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderUser extends ChangeNotifier {
  List<Map<String, dynamic>> _product = [
    {
      'name': "pp",
      'image': "https://picsum.photos/250?image=9",
      "weight": "",
      "weightUnit": "",
      "itemCount": "",
      "price": "0.0",
      'shopName': "0000aaaabbbbcccc",
      'number': "number",
    }
  ];
  List<Map<String, dynamic>> get product => _product;

  List<List<ProductModel>> _cart = [
    [ProductModel()]
  ];
  List<ProductModel> rowlist = [];
  double _shopTotalBill = 0.0;
  double _singleBasketBill = 0.0;
  double get singleBasketBill => _singleBasketBill;
  double get shopTotalBill => _shopTotalBill;
  // List<Map<String, dynamic>> get cart => _cart;
  List<List<ProductModel>> get cart => _cart;
  List<Widget> _weightKatta = [];
  List<Widget> get weightKatta => _weightKatta;
  List<Map<String, dynamic>> _testKatta = [];
  List<Map<String, dynamic>> get testKatta => _testKatta;

  bool _selected = true;
  bool get selected => _selected;
  bool _cartSelected = true;
  bool get cartSelected => _cartSelected;
  double _turns = 0;
  double get turns => _turns;
  double _cartTurns = 0;
  double get cartTurns => _cartTurns;
  double scale = 1.0;
  String _selectionCountWeight = "weightMachine";
  String get selectionCountWeight => _selectionCountWeight;
  addSelectionCountWeight(value) {
    _selectionCountWeight = value;
    notifyListeners();
  }

  bool _isLoadingOrderPlace = true;
  bool get isLoadingOrderPlace => _isLoadingOrderPlace;
  addLoadingOrderPlace(bool value) {
    _isLoadingOrderPlace = value;
    notifyListeners();
  }

  void testKattaMethod(Map<String, dynamic> t) {
    _testKatta.add(t);
    print(t);
    notifyListeners();
  }

  double _totalWeightt = 0.0;
  double get totalWeightt => _totalWeightt;
  // testKattaTotal(totalWeightt) {
  //   _totalWeightt += totalWeightt;
  //   notifyListeners();
  // }

  addTestKattaTotalDup(totalWeightt, context) {
    double f = double.parse(Provider.of<ProviderUser>(context, listen: false)
        .testKatta
        .last["weightOfProduct"]
        .toString());
    _totalWeightt += f;
    notifyListeners();
  }

  removeTestKattaTotalDup(index, totalWeightt, context) {
    double f = double.parse(Provider.of<ProviderUser>(context, listen: false)
        .testKatta[index]["weightOfProduct"]
        // .last["weightConverted"]
        .toString());

    _totalWeightt -= f;
    notifyListeners();
  }

  void testKattaRemove(int index) {
    _testKatta.removeAt(index);
    notifyListeners();
  }

  void changeScale() {
    scale = scale == 1.0 ? 3.0 : 1.0;
    notifyListeners();
  }

  double _totalWeight = 0.0;
  double get totalWeight => _totalWeight;

  Map _orderdSuccess = {
    // "shopName":'shop name',
    // "price":'0'
  };
  Map get orderdSuccess => _orderdSuccess;
  Map _productSelected = {
    'index': 0,
    'isProductSelected': false,
  };
  Map get productSelected => _productSelected;
  addProductSelected(productSelected) {
    _productSelected = productSelected;
    notifyListeners();
  }

  addOrderedSuccess({required String shopName, required String price}) {
    Map d = {"shopName": shopName, "price": price};
    _orderdSuccess.addAll(d);
    notifyListeners();
  }

  addSingleBasketTotal(value) {
    _singleBasketBill = value;
    notifyListeners();
  }

  addShopTotalBill(value) {
    _shopTotalBill = value;
    notifyListeners();
  }

  deleteCartItem(
      { // String name,
      var data,
      String? number}) {
    if (number!=null) {
      rowlist.removeWhere((element) => element.number == number);
    }
    {}
    if (data!=null) {
      rowlist.removeWhere((element) => element == data);
    }
    {}

    // rowlist.removeWhere((element) => element.shopName == name);
    _cart = rowlist.groupListsBy((cart) => cart.number).values.toList();
    // _product.clear();
    // print(_cart);
    notifyListeners();
  }

  addCart(acart) async {
    // .add(acart);
    rowlist.insert(0, acart);
    _cart = rowlist.groupListsBy((cart) => cart.number).values.toList();

    // _cart.add(acart);
    notifyListeners();
  }

  addWeightKatta(value) {
    _weightKatta.add(value);
    notifyListeners();
  }

  addTotalWeight(totalWeight) {
    _totalWeight += totalWeight;
    notifyListeners();
  }

  deleteTotalWeight() {
    _totalWeight = 0;

    notifyListeners();
  }

  addWeight(product) {
    _product.add(product);
    notifyListeners();
  }

  removeProduct(name) {
    _product.removeWhere((element) => element["name"] == name);

    notifyListeners();
  }

  removeProductOn() {
    _product.removeRange(1, _product.length);
    notifyListeners();
  }

  addSelect() {
    // _changeRotation();
    _selected = !selected;
    notifyListeners();
  }

  addSelectCartFalse() {
    _cartSelected = false;

    notifyListeners();
  }

  addSelectCartTrue() {
    _cartSelected = true;

    notifyListeners();
  }

  // void _changeRotation() {
  //   if (selected) {
  //     _turns -= 1 / 16;
  //     notifyListeners();
  //   } else {
  //     _turns += 1 / 16;
  //     notifyListeners();
  //   }
  // }

  void _changeRotationCartAnimation() {
    if (cartSelected) {
      _cartTurns -= 1 / 16;
      notifyListeners();
    } else {
      _cartTurns += 1 / 16;
      notifyListeners();
    }
  }

  addToBalancer() {
    // _changeRotation();
    _selected = !selected;
    notifyListeners();
    Future.delayed(Duration(milliseconds: 500), () {
      // _changeRotation();
      _selected = !selected;
      notifyListeners();
    });
  }

  bool _selectedTwo = true;
  bool get selectedTwo => _selectedTwo;
  addToBalancerTwo() {
    // _changeRotation();
    _selected = true;
    notifyListeners();
    // Future.delayed(Duration(milliseconds: 500), () {
    //   // _changeRotation();
    //   _selected = !selected;
    //   notifyListeners();
    // });
  }

  addToBalancerTwoFalse() {
    // _changeRotation();
    _selected = false;
    notifyListeners();
    // Future.delayed(Duration(milliseconds: 500), () {
    //   // _changeRotation();
    //   _selected = !selected;
    //   notifyListeners();
    // });
  }

  addToCartAnimation() {
    _changeRotationCartAnimation();
    _cartSelected = !cartSelected;
    notifyListeners();
    Future.delayed(Duration(milliseconds: 100), () {
      _changeRotationCartAnimation();
      _cartSelected = !cartSelected;
    });
  }

  bool _isProductDetails = false;
  bool get isProductDetails => _isProductDetails;
  boolIsProductDetails(value) {
    _isProductDetails = value;
    notifyListeners();
  }
}
