
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../consts.dart';

PreferredSizeWidget makeAppBar({List<Widget>? actions}) => AppBar(
  leading: SvgPicture.asset(assets + appIcon + svgExtension),
  title: const Text(
    appName,
    style: TextStyle(fontFamily: appNameFont),
  ),
  actions: actions
);
