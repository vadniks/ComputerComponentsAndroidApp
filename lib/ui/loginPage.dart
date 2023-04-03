
import 'package:flutter/material.dart';
import '../consts.dart';
import '../util.dart';
import '../model/proxies.dart';

class LoginPage extends AbsPage {
  const LoginPage(super.appSate, {super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends PageState<LoginPage> {
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  bool get _isPortrait => orientation == Orientation.portrait;

  void _proceed() async {
    final successful = await appSate.net.login(
      _loginController.text,
      _passwordController.text
    );
    if (successful) navigator.pop();
    if (mounted) showSnackBar(successful ? successfulText : failedText);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: appBarTexts(subtitle(logIn))),
    body: Center(child: SizedBox(
      width: screenSize.width * 0.75,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isPortrait) svgImage(
            appIcon,
            width: screenSize.width * 0.25
          ),
          if (_isPortrait) makeGreeting(appSate.net.fetchName()),
          const SizedBox(height: 50),
          makeTextField(
            controller: _loginController,
            hint: login
          ),
          makeTextField(
            controller: _passwordController,
            hint: password,
            isPassword: true
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: _proceed,
                child: const Text(proceed),
              ),
              TextButton(
                onPressed: () => setState(() {
                  _loginController.text = emptyString;
                  _passwordController.text = emptyString;
                }),
                child: const Text(clear)
              )
            ]
          )
        ]
      )
    ))
  );
}
