
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
  var _register = false;

  void _proceed() async {
    final successful = !_register
      ? await appSate.net.login(_loginController.text, _passwordController.text)
      : false; // TODO
    if (successful) navigator.pop();
    if (mounted) showSnackBar(successful ? successfulText : failedText);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: appBarTexts(subtitle(!_register ? logIn : register))),
    body: Center(child: SizedBox(
      width: screenSize.width * 0.75,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          svgImage(
            appIcon,
            width: screenSize.width * 0.35
          ),
          makeGreeting(appSate.net.fetchName),
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
            children: [
              TextButton(
                onPressed: _proceed,
                child: const Text(proceed),
              ),
              TextButton(
                onPressed: () => setState(() => _register = !_register),
                child: Text(_register ? logIn : register)
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
      ),
    ))
  );
}
