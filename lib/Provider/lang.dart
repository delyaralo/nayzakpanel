import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;
  String _fontFamily = 'CustomArabic';

  Locale? get locale => _locale;
  String get fontFamily => _fontFamily;

  void setLocale(Locale locale) {
    _locale = locale;

   _fontFamily = 'CustomArabic';

    notifyListeners();
  }
}
