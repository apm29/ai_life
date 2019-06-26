import 'configs/configs.dart';
import 'index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/base_response.dart';
import 'model/user_model.dart';
import 'persistence/sp.dart';
import 'remote/dio_utils.dart';

void main() async {
  sp = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        fontFamily: "SoukouMincho",
      ),
      //home: MainPage(),
      debugShowCheckedModeBanner: App_Debug,
      routes: {
        "/": (context) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: MainIndexModel()),
              ChangeNotifierProvider.value(value: UserModel(),),

            ],
            child: MainPage(),
          );
        }
      },
    );
  }
}
