import 'package:ai_life/remote/api.dart';
import 'package:flutter/foundation.dart';

import 'base_response.dart';
import 'package:ai_life/persistence/sp.dart';

class UserModel extends ChangeNotifier {
  UserInfo _userInfo;
  String _token;

  String get userId => _userInfo?.userId;
  String get token => _token;
  bool get isLogin => userId != null && token!=null;

  void login(UserInfo info, String token) {
    _userInfo = info;
    _token = token;
    sp.setString(Key_User_Info, info.toString());
    sp.setString(Key_Token, token);
    notifyListeners();
  }

  void logout() {
    _userInfo = null;
    _token = null;
    sp.setString(Key_User_Info, null);
    sp.setString(Key_Token, null);
    notifyListeners();
  }

  UserModel() {
    _tryLogin();
  }

  void _tryLogin() {
    Api.login().then((resp) {
      print(resp.token);
      login(resp.data?.userInfo, resp.token);
    });
  }

  @override
  String toString() {
    return 'UserModel{_userInfo: $_userInfo, _token: $_token}';
  }


}
