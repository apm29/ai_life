import 'package:flutter/material.dart';

class LoginPageModel extends ChangeNotifier {
  bool _checkedService = true;
  bool _userSmsLogin = false;

  bool get checkedService => _checkedService;

  set checkedService(bool value) {
    if (value == _checkedService) {
      return;
    }
    _checkedService = value;
    notifyListeners();
  }

  bool get userSmsLogin => _userSmsLogin;

  set userSmsLogin(bool value) {
    if (value == _userSmsLogin) {
      return;
    }
    _userSmsLogin = value;
    notifyListeners();
  }
}
