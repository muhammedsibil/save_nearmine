import 'package:flutter/material.dart';

class ProviderBussiness extends ChangeNotifier {
  List<String> _categories = [];
  Set<String> _categoryLocal = {};
  Set<String> get categoryLocal => _categoryLocal;

  List<String> get categories => _categories;
  String _uploadCategory = "Add category";
  String get uploadCategory => _uploadCategory;

  String _weightUnit = "";
  String get weightUnit => _weightUnit;

  addWeightUnit(value) {
    _weightUnit = value;
    notifyListeners();
  }

  addCategories(categories) {
    _categories = categories;
    notifyListeners();
  }

  addCategoryLocal(value) {
    _categoryLocal.add(value);
    notifyListeners();
  }

  deleteCategoryLocal(value) {
    _categoryLocal.remove(value);
    notifyListeners();
  }

  addCategory(uploadCategory) {
    _uploadCategory = uploadCategory;
    notifyListeners();
  }

  
}
