import 'package:ai_life/configs/configs.dart';
import 'package:ai_life/configs/themes.dart';
import 'package:ai_life/model/user_model.dart';
import 'package:ai_life/remote/api.dart';
import 'package:ai_life/widget/gradient_button.dart';
import 'package:ai_life/widget/location_switch_widget.dart';
import 'package:flutter/material.dart';

import '../index.dart';

class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: DecoratedBox(
            decoration: APP_DEFAULT_DECO,
            child: SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
          ),
        ),
        SliverAppBar(
          expandedHeight: MediaQuery.of(context).viewInsets.top,
          floating: true,
          forceElevated: true,
          snap: true,
          centerTitle: true,
          flexibleSpace: DecoratedBox(
            decoration: APP_DEFAULT_DECO,
            child: Container(),
          ),
          title: Text(APP_NAME),
          actions: <Widget>[LocationSwitchWidget()],
        ),
        SliverToBoxAdapter(
          child: Consumer<UserModel>(
            builder: (context, UserModel value, child) {
              return GradientButton(
                Text(
                  value.isLogin ? "登出" : "登录",
                ),
                onPressed: () async {
                  return value.isLogin
                      ? value.logout()
                      : Api.login().then((resp) {
                          if (resp.success) {
                            value.login(resp.data?.userInfo, resp.token);
                          }
                          return;
                        });
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
