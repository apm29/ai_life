import 'configs/configs.dart';
import 'index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/announcement_model.dart';
import 'model/base_response.dart';
import 'model/user_model.dart';
import 'persistence/const.dart';

void main() async {
  sp = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: MainIndexModel()),
        ChangeNotifierProvider.value(value: UserModel(),),
        ChangeNotifierProvider.value(value: AnnouncementModel())
      ],
      child: MaterialApp(
        title: APP_NAME,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          fontFamily: "Determination",
        ),
        debugShowCheckedModeBanner: APP_DEBUG,
        routes: {
          "/": (context) {
            return MainPage();
          }
        },
      ),
    );
  }
}
