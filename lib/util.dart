
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'consts.dart';

dynamic getArgs(BuildContext context) => ModalRoute.of(context)!.settings.arguments;

List<Widget> get defaultFooter => const [SizedBox(width: 25, height: 25)];

const Widget divider = Divider(height: 1);

void showSnackBar(BuildContext context, String text) => ScaffoldMessenger
  .of(context)
  .showSnackBar(SnackBar(content: Text(text)));

makeTextField({
  required TextEditingController controller,
  required String hint,
  bool isNumeric = false,
  bool isPassword = false,
  bool isItalic = false,
  autofocus = false
}) => SizedBox(
  width: 500,
  child: TextFormField(
    autofocus: autofocus,
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

const appNameWidget = Text(
  appName,
  style: TextStyle(fontFamily: appNameFont),
);

const subtitleStyle = TextStyle(fontSize: 14);

Widget subtitle(String text, {TextOverflow? overflow}) => Text(
  text,
  style: subtitleStyle,
  overflow: overflow
);

Widget svgImage(String which, {double? width, double? height}) => SvgPicture.asset(
  assets + which + svgExtension,
  width: width,
  height: height,
);

Widget svgImageDefaultSized(String which) => svgImage(
  which,
  width: 50,
  height: 50
);

Widget appBarTexts([Widget? subtitle]) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    appNameWidget,
    if (subtitle != null) subtitle
  ]
);

extension NullableAdditionals on String? { String get value => this ?? nullString; }

extension Additionals on String
{ bool containsIgnoreCase(String value) => toLowerCase().contains(value.toLowerCase()); }

extension Additions on int { String get withDollarSign => '$this\$'; }
