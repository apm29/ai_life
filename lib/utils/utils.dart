import 'package:ai_life/model/main_index_model.dart';
import 'package:ai_life/model/user_model.dart';
import 'package:ai_life/model/user_verify_status_model.dart';
import 'package:ai_life/page/web_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

Type _getType<T>() => T;

Future toWebPage(BuildContext context, String indexId,
    {Map<String, dynamic> params,
    bool checkHasHouse = false,
    bool checkFaceVerified = true}) async {
  var userVerifyStatusModel = UserVerifyStatusModel.of(context);
  var userModel = UserModel.of(context);
  if (checkFaceVerified || checkHasHouse) {
    if (!userModel.isLogin) {
      return Navigator.of(context).pushNamed("/login");
    }
  }
  if (checkFaceVerified) {
    if (!userVerifyStatusModel.isVerified()) {
      return showFaceVerifyDialog(context);
    }
  }
  if (checkHasHouse) {
    if (!userVerifyStatusModel.hasHouse()) {
      return showApplyHouseDialog(context);
    }
  }

  return routeDirectlyToWebPage(context, params, indexId);
}

Future routeDirectlyToWebPage(
    BuildContext context, Map<String, dynamic> params, String indexId) {
  return MainIndexModel.of(context).getIndex().then((list) {
    params = params ?? {};
    for (var index in list) {
      var menuItem = index.menu.firstWhere((menu) {
        return menu.id == indexId;
      }, orElse: () => null);
      if (menuItem != null) {
        params['url'] = menuItem.url;
        return Navigator.of(context)
            .pushNamed(WebPage.routeName, arguments: params);
      }
    }
    return Navigator.of(context).pushNamed(indexId, arguments: params);
  });
}

Future showApplyHouseDialog(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("提醒"),
          content: Text.rich(
            TextSpan(children: [
              TextSpan(text: "您身份证名下还未拥有当前小区房屋,您可以申请成为房屋成员,若您已经提交申请,请在"),
              TextSpan(
                  text: "申请记录",
                  style: TextStyle(
                    color: Colors.blueAccent,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      routeDirectlyToWebPage(context, {}, "sqjl");
                    }),
              TextSpan(
                text: "中查看已提交的申请",
              ),
            ]),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("取消"),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed("/apply");
              },
              child: Text("前往申请"),
            ),
          ],
        );
      });
}

Future showFaceVerifyDialog(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("提醒"),
          content: Text("您还未通过人脸对比,点击实名验证按钮前往认证"),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("取消"),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed("/verify");
              },
              child: Text("实名验证"),
            ),
          ],
        );
      });
}
