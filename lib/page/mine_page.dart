import 'package:ai_life/configs/configs.dart';
import 'package:ai_life/configs/themes.dart';
import 'package:ai_life/model/user_model.dart';
import 'package:ai_life/remote/api.dart';
import 'package:ai_life/widget/ease_icon_button.dart';
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
    return Consumer<UserModel>(
      builder: (BuildContext context, UserModel userModel, Widget child) {
        if (!userModel.isLogin) {
          return Center(
            child: buildLoginButton(userModel),
          );
        }
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
            SliverToBoxAdapter(
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  DecoratedBox(
                    decoration: APP_DEFAULT_DECO,
                    child: Container(
                      height: 100,
                    ),
                  ),
                  Align(
                    alignment: Alignment(0.9, -0.9),
                    child: LocationSwitchWidget(),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 50, left: 16, right: 16),
                    child: Material(
                      type: MaterialType.card,
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      color: Colors.white,
                      child: Container(
                        padding:
                            EdgeInsets.only(bottom: 12, left: 12, right: 12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              height: 30,
                            ),
                            Text(userModel.userName),
                            SizedBox(
                              width: 6,
                            ),
                            Consumer<DistrictModel>(
                              builder: (BuildContext context,
                                  DistrictModel value, Widget child) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      size: 10,
                                      color: Colors.blueGrey,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      value.currentDistrict.districtName,
                                      style: TextStyle(
                                          color: Colors.blueGrey, fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                );
                              },
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                EaseIconButton(
                                  0,
                                  "我的房屋",
                                  () {},
                                  Icons.home,
                                ),
                                EaseIconButton(
                                  1,
                                  "家庭成员",
                                  () {},
                                  Icons.people,
                                ),
                                EaseIconButton(
                                  2,
                                  "我的爱车",
                                  () {},
                                  Icons.airport_shuttle,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      elevation: 4,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 25),
                    child: SizedBox(
                      child: CircleAvatar(),
                      height: 50,
                    ),
                  ),
                ],
              ),
            ),
            SliverFillRemaining(
              child: Container(
                alignment: Alignment.center,
                child: buildLoginButton(userModel),
              ),
            ),
          ],
        );
      },
    );
  }

  GradientButton buildLoginButton(UserModel value) {
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
  }
}
