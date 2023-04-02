
import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../consts.dart';
import '../ui/aboutPage.dart';
import '../ui/homePage.dart';
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
  Future<bool> get authorized => _net.authorized;
  
  @override
  void initState() {
    super.initState();
    _net.fetchImage('amd_r5').then((value) => debugPrint((value as Uint8List).length.toString()));
  }

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
