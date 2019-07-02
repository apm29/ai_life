import 'dart:convert';

import 'package:ai_life/providers/web_page_model.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../index.dart';
import 'login_page.dart';

class WebPage extends StatefulWidget {
  static String routeName = "/web";

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    var argument = ModalRoute.of(context).settings.arguments;
    var url = argument is Map ? argument['url'] : "https://flutter.dev";
    return ChangeNotifierProvider(
      builder: (context)=> WebPageModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Consumer<WebPageModel>(
            builder: (BuildContext context, WebPageModel value, Widget child) {
              return Text(value.title ?? "");
            },
          ),
        ),
        body: Builder(
          builder: (context){
            return WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: url,
              javascriptChannels:
              <JavascriptChannel>[_userJavascriptChannel(context)].toSet(),
              onWebViewCreated: (controller) {
                _controller = controller;
              },
              onPageFinished: (String url) {
                _tryGetTitle(context);
              },
            );
          },
        ),
      ),
    );
  }

  void _tryGetTitle(BuildContext context) {
    _controller
        .evaluateJavascript(
        'document.getElementsByTagName("title")[0].innerText')
        .then((title) {
      title = title.replaceAll('"', "");
      if (title == "null" || title == "undefined") {
        title = null;
      }
      WebPageModel.of(context).title = title;
    });
  }

  JavascriptChannel _userJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'UserState',
      onMessageReceived: (JavascriptMessage message) {
        Map<String, dynamic> jsonMap = json.decode(message.message);
        print('$jsonMap');
        switch (jsonMap['funcName']) {
          case "getToken":
            doGetToken(jsonMap["data"], context);
            break;
          default:
            break;
        }
      },
    );
  }

  void doGetToken(dynamic data, BuildContext context) {
    if (UserModel.of(context).isLogin) {
      var javascriptString =
          '${data["callbackName"]}("${UserModel.of(context).token}","${DistrictModel.of(context).currentDistrict.districtId}","${data["backRoute"]}")';

      print('$javascriptString');

      _controller.evaluateJavascript(javascriptString);
    } else {
      Navigator.of(context).push<String>(MaterialPageRoute(
        builder: (context) {
          return LoginPage();
        },
      )).then((token) {
        if (token != null) {
          var javascriptString =
              '${data["callbackName"]}("${UserModel.of(context).token}}","${DistrictModel.of(context).currentDistrict.districtId}}","${data["backRoute"]}")';

          _controller.evaluateJavascript(javascriptString).then((_){
            _tryGetTitle(context);
          });
        } else {
          Navigator.of(context).pop();
        }
      });
    }
  }
}
