
import 'package:flutter/material.dart';
import '../consts.dart';
import '../ui/aboutPage.dart';
import '../ui/homePage.dart';
import '../ui/selectPage.dart';
import '../ui/loginPage.dart';
import 'proxies.dart';

void main() => runApp(const App());

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> implements AppState {
  var _authorized = false;

  @override
  bool get authorized => _authorized;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: appName,
    themeMode: ThemeMode.dark,
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true),
    home: HomePage(this),
    routes: {
      routeSelect: (context) => SelectPage(this),
      routeAbout: (context) => const AboutPage(),
      routeLogin: (context) => LoginPage(this)
    }
  );
}
