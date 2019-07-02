import 'dart:async';

import 'package:oktoast/oktoast.dart';

import 'configs/configs.dart';
import 'index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/announcement_model.dart';
import 'model/district_model.dart';
import 'model/home_end_scroll_model.dart';
import 'model/notification_model.dart';
import 'model/theme_model.dart';
import 'model/user_model.dart';
import 'page/not_found_page.dart';
import 'page/web_page.dart';
import 'persistence/const.dart';

void main() async {
  sp = await SharedPreferences.getInstance();
  runZoned(() {
    runApp(MyApp());
  }, onError: (e) {
    debugPrint(e.toString());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: MainIndexModel()),
          ChangeNotifierProvider.value(value: UserModel()),
          ChangeNotifierProvider.value(value: AnnouncementModel()),
          ChangeNotifierProvider.value(value: AppThemeModel()),
          ChangeNotifierProvider.value(value: DistrictModel()),
          ChangeNotifierProvider.value(value: HomeEndScrollModel()),
          ChangeNotifierProvider.value(value: NotificationModel()),
        ],
        child: Consumer<AppThemeModel>(
          builder: (context, model, child) {
            return MaterialApp(
              title: APP_NAME,
              theme: model.appTheme,
              debugShowCheckedModeBanner: false,
              routes: {
                "/": (context) {
                  return MainPage();
                },
                WebPage.routeName: (context) {
                  return WebPage();
                }
              },
              onUnknownRoute: (settings) {
                return MaterialPageRoute(builder: (context) {
                  return NotFoundPage(routeName: settings.name);
                });
              },
            );
          },
        ),
      ),
    );
  }
}
