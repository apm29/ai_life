import 'dart:convert';

import 'package:ai_life/remote/api.dart';
import 'package:flutter/foundation.dart';

import 'base_response.dart';
import 'package:ai_life/persistence/const.dart';

class UserModel extends ChangeNotifier {
  UserInfo _userInfo;
  String _token;

  String get userId => _userInfo?.userId;

  String get token => _token;

  bool get isLogin => userId != null && token != null;

  void login(UserInfo info, String token) {
    _userInfo = info;
    _token = token;
    sp.setString(KEY_USER_INFO, info.toString());
    sp.setString(KEY_TOKEN, token);
    notifyListeners();
  }

  void logout() {
    _userInfo = null;
    _token = null;
    sp.setString(KEY_USER_INFO, null);
    sp.setString(KEY_TOKEN, null);
    notifyListeners();
  }

  UserModel() {
    _tryLogin();
  }

  void _tryLogin() {
    var userInfoStr = sp.getString(KEY_USER_INFO);
    var token = sp.getString(KEY_TOKEN);
    Map<String, dynamic> map =
        userInfoStr == null ? null : json.decode(userInfoStr);
    UserInfo userInfo = map == null ? null : UserInfo.fromJson(map);
    login(userInfo, token);
  }

  @override
  String toString() {
    return 'UserModel{_userInfo: $_userInfo, _token: $_token}';
  }
}
