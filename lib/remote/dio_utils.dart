import 'package:ai_life/configs/configs.dart';
import 'package:ai_life/model/base_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ai_life/persistence/const.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

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
    @required JsonProcessor<T> processor,
    Map<String, dynamic> formData,
    CancelToken cancelToken,
    ProgressCallback onReceiveProgress,
    ProgressCallback onSendProgress,
    bool showProgress = false,
    String loadingText,
    bool toastMsg = false,
  }) async {
    assert(!showProgress || loadingText != null);
    assert(processor != null);
    processor = processor ?? (dynamic raw) => null;
    formData = formData ?? {};
    toastMsg = toastMsg ?? false;
    cancelToken = cancelToken ?? CancelToken();
    onReceiveProgress = onReceiveProgress ??
        (count, total) {
          ///默认接收进度
        };
    onSendProgress = onSendProgress ??
        (count, total) {
          ///默认发送进度
        };
    ToastFuture toastFuture;
    if (showProgress) {
      toastFuture = showLoadingWidget(loadingText);
    }
    return _dio
        .post(
      path,
      data: FormData.from(formData),
      options: RequestOptions(
        responseType: ResponseType.json,
        headers: {AuthorizationHeader: sp.getString(KEY_TOKEN)},
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
      return BaseResp.error(message: e.toString(), data: null as T);
    }).then((resp) {
      toastFuture?.dismiss();
      debugPrint(resp.toString());
      if (toastMsg) {
        showToast(resp.text);
      }
      return resp;
    });
  }

  ToastFuture showLoadingWidget(String loadingText) {
    return showToastWidget(
        AbsorbPointer(
          absorbing: true,
          child: Stack(
            children: <Widget>[
              ModalBarrier(
                dismissible: false,
                color: Color(0x33333333),
              ),
              Align(
                alignment: Alignment.center,
                child: Material(
                  type: MaterialType.card,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  elevation: 6,
                  color: Colors.deepPurpleAccent,
                  shadowColor: Colors.black,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          loadingText,
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        position: ToastPosition.center,
        textDirection: TextDirection.ltr,
        duration: Duration(seconds: 100));
  }
}
