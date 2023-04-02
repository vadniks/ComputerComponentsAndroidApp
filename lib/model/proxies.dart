
import 'package:flutter/material.dart';

abstract class AbsPage extends StatefulWidget {
  final AppState appSate;

  const AbsPage(this.appSate, {super.key});
}

abstract class PageState<T extends AbsPage> extends State<T>
{ AppState get appSate => widget.appSate; }

/*interface*/ abstract class AppState { bool get authorized; }
