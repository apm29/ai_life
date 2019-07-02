import 'package:ai_life/configs/configs.dart';
import 'package:ai_life/configs/themes.dart';
import 'package:ai_life/model/district_model.dart';
import 'package:ai_life/model/user_model.dart';
import 'package:ai_life/providers/login_page_model.dart';
import 'package:ai_life/remote/api.dart';
import 'package:ai_life/widget/gradient_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

const kTopDec = 140.8;
const kLogoHeight = 50.8;
const kLogoMargin = 10.8;

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _userName = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      child: Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: DecoratedBox(
                  decoration: appDeco(context),
                  child: SizedBox(
                    height: MediaQuery
                        .of(context)
                        .padding
                        .top,
                  ),
                ),
              ),
              SliverAppBar(
                floating: true,
                forceElevated: true,
                snap: true,
                centerTitle: true,
                flexibleSpace: DecoratedBox(
                  decoration: appDeco(context),
                  child: Container(),
                ),
                title: Text("登录"),
                elevation: 0,
                actions: <Widget>[
                  FlatButton(
                    onPressed: (){
                      Navigator.of(context).pushNamed("/register");
                    },
                    child: Text("注册"),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Container(
                      decoration: appDeco(context),
                      height: kTopDec,
                    ),
                    Container(
                      margin:
                      EdgeInsets.only(left: 12, right: 12, top: kLogoMargin),
                      child: FlutterLogo(
                        size: kLogoHeight,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 12,
                          right: 12,
                          top: kLogoHeight + kLogoMargin + 10),
                      child: Material(
                        elevation: 3,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        child: Container(
                          padding:
                          EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                          child: Form(
                            key: _formKey,
                            autovalidate: false,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "SIGN IN",
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .title,
                                ),
                                SizedBox(
                                  height: 32,
                                ),
                                TextFormField(
                                  validator: (s) =>
                                  (s.length > 0) ? null : "用户名不可为空",
                                  decoration: InputDecoration(
                                    helperText: "用户名",
                                  ),
                                  controller: _userName,
                                ),
                                TextFormField(
                                  validator: (s) =>
                                  (s.length >= 6) ? null : "密码长度小于6",
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    helperText: "密码",
                                  ),
                                  controller: _password,
                                ),
                                SizedBox(
                                  height: 24,
                                ),
                                Consumer<LoginPageModel>(
                                  builder: (BuildContext context,
                                      LoginPageModel model, Widget child) {
                                    return GradientButton(
                                      Text("登录"),
                                      onPressed: () async {
                                        if(!model.checkedService){
                                          showToast("请您勾选用户协议");
                                          return;
                                        }
                                        if (_formKey.currentState.validate()) {
                                          Api.loginByUserName(
                                              _userName.text, _password.text)
                                              .then((resp) {
                                            if (resp.success) {
                                              UserModel.of(context).login(
                                                  resp.data.userInfo,
                                                  resp.token);
                                              DistrictModel.of(context).tryFetchCurrentDistricts();
                                              Navigator.of(context)
                                                  .pop<String>(resp.token);
                                            } else {
                                              showToast(resp.text);
                                            }
                                          });
                                        } else {
                                          showToast("请您按提示输入用户名密码");
                                        }
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Consumer<LoginPageModel>(
                      builder: (BuildContext context, LoginPageModel model,
                          Widget child) {
                        return Checkbox(
                          value: model.checkedService,
                          onChanged: (value) {
                            model.checkedService = value;
                          },
                        );
                      },
                    ),
                    Text.rich(TextSpan(
                        text: "登录即视为同意",
                        style: Theme
                            .of(context)
                            .textTheme
                            .caption,
                        children: [
                          TextSpan(
                            text: "<<用户服务协议>>",
                            style: Theme
                                .of(context)
                                .textTheme
                                .caption
                                .copyWith(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).pushNamed("/service");
                              },
                          )
                        ])),
                  ],
                ),
              )
            ],
          )),
      builder: (BuildContext context) {
        return LoginPageModel();
      },
    );
  }
}
