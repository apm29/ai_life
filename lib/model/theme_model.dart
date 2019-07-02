import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppThemeModel extends ChangeNotifier {
  List<ThemeData> _appCurrentTheme = [
    ThemeData(
      primarySwatch: Colors.blue,
      fontFamily: "Weiruanyahei",
      iconTheme: IconThemeData(
        color: Colors.purple,
        size: 24,
      ),
      primaryColor: Colors.blue,
      colorScheme: ColorScheme(
        primary: Colors.blue,
        primaryVariant: Colors.blueAccent,
        secondary: Colors.purple,
        secondaryVariant: Colors.deepPurpleAccent,
        surface: Colors.grey[200],
        background: Colors.grey[300],
        error: Colors.red,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.blueGrey[600],
        onBackground: Colors.blueGrey[700],
        onError: Colors.grey[200],
        brightness: Brightness.dark,
      ),
      textTheme: TextTheme(
        body1: TextStyle(
          color: Colors.blueGrey[800],
        ),
        body2: TextStyle(
          color: Colors.blueGrey[600],
        ),
        headline: TextStyle(
          color: Colors.black,
        ),
        title: TextStyle(
          color: Colors.purple[200],
        ),
        subtitle: TextStyle(
          color: Colors.purple[300],
        ),
        subhead: TextStyle(
          color: Colors.purple[400],
        ),
        caption: TextStyle(
          color: Colors.grey[500],
        ),
        button: TextStyle(
          color: Colors.purple[600],
        ),
        overline: TextStyle(
          color: Colors.purple[700],
        ),
        display1: TextStyle(
          color: Colors.blueGrey[200],
        ),
        display2: TextStyle(
          color: Colors.blueGrey[300],
        ),
        display3: TextStyle(
          color: Colors.blueGrey[400],
        ),
        display4: TextStyle(
          color: Colors.blueGrey[600],
        ),
      ),
    ),
    ThemeData(
      primarySwatch: Colors.purple,
      fontFamily: "Determination",
      iconTheme: IconThemeData(
        color: Colors.blue,
        size: 24,
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
