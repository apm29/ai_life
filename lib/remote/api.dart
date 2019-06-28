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

  static Future<BaseResp<List<AnnouncementType>>> getAnnounceTypes() async {
    return DioUtil().post("/business/noticeDict/getAllType", processor: (s) {
      if (s is List) {
        return s.map((map) {
          return AnnouncementType.fromJson(map);
        }).toList();
      }
      return [];
    });
  }

  static Future<BaseResp<List<Announcement>>> getAnnouncements(
      String types) async {
    return DioUtil().post("/business/notice/getAllNewNotice",
        formData: {"noticeType": types}, processor: (s) {
      if (s is List) {
        return s.map((map) {
          return Announcement.fromJson(map);
        }).toList();
      }
      return [];
    });
  }

  static Future<BaseResp<List<DistrictDetail>>> getCurrentDistricts() async {
    return DioUtil().post("/business/district/findDistrictInfo",
        processor: (s) {
      if (s is List) {
        return s.map((map) {
          return DistrictDetail.fromJson(map);
        }).toList();
      }
      return [];
    });
  }
}
