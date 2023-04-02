
import 'package:flutter/material.dart';
import '../consts.dart';
import '../ui/aboutPage.dart';
import '../ui/homePage.dart';
import '../ui/orderPage.dart';
import '../ui/selectPage.dart';
import '../ui/loginPage.dart';
import 'net.dart';
import 'proxies.dart';

void main() => runApp(const App());

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> implements AppState {
  late final _net = Net(this);

  @override
  Net get net => _net;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: appName,
    themeMode: ThemeMode.dark,
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true),
    home: HomePage(this),
    routes: {
      routeSelect: (_) => SelectPage(this),
      routeAbout: (_) => const AboutPage(),
      routeLogin: (_) => LoginPage(this),
      routeOrder: (_) => OrderPage(this)
    }
  );
}
