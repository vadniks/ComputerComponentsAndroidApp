
import 'package:flutter/material.dart';
import 'net.dart';

abstract class AbsPage extends StatefulWidget {
  final AppState appSate;
  const AbsPage(this.appSate, {super.key});
}

abstract class PageState<T extends AbsPage> extends State<T> {

  @protected
  AppState get appSate => widget.appSate;

  @protected
  NavigatorState get navigator => Navigator.of(context);

  @protected
  void updateState() => setState(() {});

  @protected
  void showSnackBar(String text) => ScaffoldMessenger
    .of(context)
    .showSnackBar(SnackBar(content: Text(text)));
}

/*interface*/ abstract class AppState { Net get net; }
