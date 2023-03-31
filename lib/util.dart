
import 'package:flutter/material.dart';

import 'consts.dart';

dynamic getArgs(BuildContext context) => ModalRoute.of(context)!.settings.arguments;

List<Widget> get defaultFooter => const [SizedBox(width: 25, height: 25)];

const Widget divider = Divider(height: 1);

makeTextField({
  required TextEditingController controller,
  required String hint,
  bool isNumeric = false,
  bool isPassword = false,
  bool isItalic = false
}) => SizedBox(
  width: 500,
  child: TextFormField(
    keyboardType: !isNumeric ? TextInputType.text : TextInputType.number,
    obscureText: isPassword,
    maxLines: 1,
    cursorColor: Colors.white70,
    controller: controller,
    style: TextStyle(
      color: Colors.white70,
      fontSize: 14,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal
    ),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white38)
    ),
  ),
);

extension NullableAdditionals on String?
{ String get value => this ?? nullString; }

extension Additionals on String {

  bool containsIgnoreCase(String value)
  => toLowerCase().contains(value.toLowerCase());

  Uri get uri => Uri.parse(this);

  String get beforeLast => substring(0, length - 1);
}
