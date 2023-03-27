
import 'package:flutter/material.dart';
import 'consts.dart';
import 'ui/homePage.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: appName,
    themeMode: ThemeMode.dark,
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true),
    home: const HomePage(),
  );
}
