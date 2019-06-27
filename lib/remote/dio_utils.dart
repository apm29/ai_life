import 'dart:convert';

import 'package:ai_life/configs/configs.dart';
import 'package:ai_life/model/base_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ai_life/persistence/const.dart';
import 'package:flutter/material.dart';

typedef JsonProcessor<T> = T Function(dynamic json);

class DioUtil {
  DioUtil._() {
    init();
  }

  static DioUtil _instance;

  static DioUtil getInstance() {
    if (_instance == null) {
      _instance = DioUtil._();
    }
    return _instance;
  }

  factory DioUtil() {
    return getInstance();
  }

  Dio _dio;

  void init() {
    _dio = Dio(BaseOptions(
      method: "POST",
      connectTimeout: 10000,
      receiveTimeout: 20000,
      baseUrl: BaseUrl,
    ));
  }

  Future<BaseResp<T>> post<T>(
    String path, {
    JsonProcessor<T> processor,
    Map<String, dynamic> formData,
    CancelToken cancelToken,
    ProgressCallback onReceiveProgress,
    ProgressCallback onSendProgress,
  }) async {
    processor = processor ?? (dynamic raw) => null;
    formData = formData ?? {};
    cancelToken = cancelToken ?? CancelToken();
    onReceiveProgress = onReceiveProgress ??
        (count, total) {
          ///默认接收进度
        };
    onSendProgress = onSendProgress ??
        (count, total) {
          ///默认发送进度
        };
    return _dio
        .post(
      path,
      data: FormData.from(formData),
      options: RequestOptions(
        responseType: ResponseType.json,
        headers: {AuthorizationHeader: sp.getString(Key_Token)},
      ),
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    )
        .then((resp) {
      return resp.data;
    }).then((map) {
      String status = map["status"];
      String text = map["text"];
      String token = map["token"];
      dynamic _rawData = map["data"];
      T data = processor(_rawData);
      return BaseResp<T>(status, data, token, text);
    }).catchError((e, StackTrace s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      return BaseResp.error(message: e.toString()) as BaseResp<T>;
    });

  }
}
