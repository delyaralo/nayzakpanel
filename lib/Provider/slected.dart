import 'package:flutter/material.dart';

class PageSelectionProvider extends ChangeNotifier {
  String _selectedPage = 'إضافة إعلان';

  String get selectedPage => _selectedPage;

  void selectPage(String page) {
    _selectedPage = page;
    notifyListeners();
  }
}
