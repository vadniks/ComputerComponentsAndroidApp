
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'consts.dart';
import 'model/component.dart';

dynamic getArgs(BuildContext context) => ModalRoute.of(context)!.settings.arguments;

List<Widget> get defaultFooter => const [SizedBox(width: 25, height: 25)];

const Widget divider = Divider(height: 1);

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

Widget makeGreeting(Future<String?> username) => FutureBuilder<String?>(
  future: username,
  builder: (_, snapshot) => subtitle(
    '$welcome ${snapshot.data == null ? anonymous : snapshot.data!}!',
    overflow: TextOverflow.ellipsis
  )
);

Component makeStubComponent({int? index, ComponentType? type}) {
  assert((index != null) != (type != null));
  final type2 = type ?? ComponentType.create(id: index!)!;
  return Component(
    title: notSelected,
    type: type2,
    description: notSelected,
    cost: 0,
    image: type2.icon
  );
}

extension NullableAdditionals on String? { String get value => this ?? nullString; }

extension Additionals on String
{ bool containsIgnoreCase(String value) => toLowerCase().contains(value.toLowerCase()); }

extension Additions on int { String get withDollarSign => '$this\$'; }

extension AdditionsR on Response { bool get successful => statusCode == 200; }
