import 'package:ai_life/model/user_model.dart';
import 'package:ai_life/remote/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Consumer<UserModel>(
              builder: (context, UserModel value, child) {
                return Text("${value.userId}");
              },
            ),
            Consumer<UserModel>(
              builder: (context, UserModel value, child) {
                print('build --------------- ');
                return FlatButton(
                  onPressed: () {
                    (!value.isLogin)
                        ? Api.login().then((resp) {
                      value.login(resp.data.userInfo, resp.token);
                    })
                        : value.logout();
                  },
                  child: Text(value.isLogin.toString()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
