import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppThemeModel extends ChangeNotifier {
  List<ThemeData> _appCurrentTheme = [
    ThemeData(
      primarySwatch: Colors.purple,
      fontFamily: "Determination",
      iconTheme: IconThemeData(
        color: Colors.blue,
        size: 24,
      ),
    ),
    ThemeData(
      primarySwatch: Colors.blue,
      fontFamily: "Weiruanyahei",
      iconTheme: IconThemeData(
        color: Colors.purple,
        size: 24,
      ),
      textTheme: TextTheme(
        body1: TextStyle(
          color: Colors.blueGrey[200]
        )
      ),

    ),
  ];
  int _currentThemeIndex = 0;

  int get currentThemeIndex => _currentThemeIndex;

  set currentThemeIndex(int newValue) {
    if (_currentThemeIndex == newValue) {
      return;
    }
    _currentThemeIndex = newValue;
    notifyListeners();
  }

  ThemeData get appTheme => _appCurrentTheme[currentThemeIndex];

  void changeTheme() {
    if (currentThemeIndex == 0) {
      currentThemeIndex = 1;
    } else {
      currentThemeIndex = 0;
    }
  }

  static AppThemeModel of(BuildContext context) {
    return Provider.of<AppThemeModel>(context, listen: false);
  }
}
