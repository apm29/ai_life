import 'dart:convert';

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

  static bool proxyHttp = false;
  static bool printLog = false;
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
    //设置代理
    if (proxyHttp)
      (_dio.httpClientAdapter as DefaultHttpClientAdapter)
          .onHttpClientCreate = (client) {
        // config the http client
        client.findProxy = (uri) {
          //proxy all request to localhost:8888
          return "PROXY 192.168.1.181:8888";
        };
        // you can also create a new HttpClient to dio
        // return new HttpClient();
      };
    if (printLog)
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (req) {
            debugPrint("REQUEST:");
            debugPrint("===========================================");
            debugPrint("  Method:${req.method},Url:${req.baseUrl + req.path}");
            debugPrint("  Headers:${req.headers}");
            debugPrint("  QueryParams:${req.queryParameters}");
            print('=======>${req.data.runtimeType}');
            if (req.data.runtimeType != FormData) {
              debugPrint("    Data:${req.data}");
            }

            debugPrint("===========================================");
          },
          onResponse: (resp) {
            debugPrint("REQUEST:");
            debugPrint("===========================================");
            debugPrint(
                "  Method:${resp.request.method},Url:${resp.request.baseUrl + resp.request.path}");
            debugPrint("  Headers:${resp.request.headers}");
            debugPrint("  QueryParams:${resp.request.queryParameters}");
            if (resp.request.data.runtimeType != FormData) {
              debugPrint("  Data:${resp.request.data}");
            }
            debugPrint("  -------------------------");
            debugPrint("  RESULT:");
            debugPrint("    Headers:${resp.headers}");
            debugPrint("  Data:${resp.data}");
            debugPrint("    Redirect:${resp.redirects}");
            debugPrint("    StatusCode:${resp.statusCode}");
            debugPrint("    Extras:${resp.extra}");
            debugPrint(" ===========================================");
          },
          onError: (err) {
            debugPrint("ERROR:");
            debugPrint("===========================================");
            debugPrint("Message:${err.message}");
            debugPrint("Error:${err.error}");
            debugPrint("Type:${err.type}");
            debugPrint("Trace:${err.stackTrace}");
            debugPrint("===========================================");
          },
        ),
      );
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
    print('$path');
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
      if(e is DioError){
        showToast(e.message);
      }
      return BaseResp.error(message: e.toString(), data: null as T);
    }).then((resp) {
      toastFuture?.dismiss();
      //debugPrint(resp.toString());
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

  Future<List<Index>> getMenu() async {
    List<Index> res = [];
    try {
      Response<String> response = await _dio.get<String>(
        "/axj_menu.json",
      );
      if (response.statusCode == 200) {
        var jsonString = response.data;
        List list = json.decode(jsonString);
        var indexList = list.map((d) {
          return Index.fromJson(d);
        }).toList();
        res.addAll(indexList);
      }
    } catch (e) {
      print(e);
    }
    return res;
  }
}
