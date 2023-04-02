
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

  Size get _screenSize => MediaQuery.of(context).size;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: appBarTexts(subtitle(!_register ? logIn : register))),
    body: Center(child: SizedBox(
      width: _screenSize.width * 0.75,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          svgImage(
            appIcon,
            width: _screenSize.width * 0.35
          ),
          const Text(
            '$welcome $anonymous!',
            style: TextStyle(fontSize: 20),
          ),
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
                onPressed: () { if (!_register) appSate.net.login(login, password); /*else TODO*/ },
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
