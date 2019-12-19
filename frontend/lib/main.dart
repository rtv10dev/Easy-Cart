import 'package:flutter/material.dart';
import 'package:easy_cart/src/providers/push_notifications.dart';
import 'package:easy_cart/src/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_cart/src/libs/constants.dart' as Constants;
import 'generated/custom_i18n.dart';

String user;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  user = sharedPreferences.getString(Constants.USER_KEY);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var pushProvider;

  @override
  void initState() {
    super.initState();

    pushProvider = new PushNotificationsProvider();
    pushProvider.initNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [S.delegate],
      supportedLocales: S.delegate.supportedLocales,
      debugShowCheckedModeBanner: false,
      initialRoute: user == null ? 'register' : 'products',
      routes: getApplicationRoutes(pushProvider),
      theme:
          ThemeData(primaryColor: Colors.deepPurple, accentColor: Colors.teal),
    );
  }
}
