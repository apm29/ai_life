import 'package:ai_life/model/base_response.dart';
import 'package:flutter/material.dart';
import 'dio_utils.dart';

class Api {
  static Future<BaseResp<UserInfoWrapper>> login() async {
    return DioUtil().post("/permission/login",
        formData: {"userName": "apm", "password": "123456"},
        onSendProgress: (count, total) {},
        onReceiveProgress: (count, total) {}, processor: (s) {
      return UserInfoWrapper.fromJson(s);
    });
  }
}
