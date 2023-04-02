
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marquee/marquee.dart';
import '../consts.dart';
import '../util.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Size _screenSize(BuildContext context) => MediaQuery.of(context).size;

  Widget _withPadding(Widget widget) => Padding(
      padding: const EdgeInsets.all(10),
      child: widget
  );

  Widget _makeIcon(String icon, BuildContext context) => _withPadding(SvgPicture.asset(
    assets + icon + svgExtension,
    width: _screenSize(context).width * 0.1,
    height: _screenSize(context).height * 0.1
  ));

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appNameWidget,
        SizedBox(
          width: _screenSize(context).width,
          height: 15,
          child: Marquee(
            text: slogan,
            style: const TextStyle(fontSize: 14),
            blankSpace: 20,
          )
        )
      ]
    )),
    body: SingleChildScrollView(child: SizedBox(
      width: _screenSize(context).width,
      height: _screenSize(context).height * 0.9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(title: Text(
            aboutText,
            textAlign: TextAlign.justify,
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _makeIcon('hwr_ico', context),
              _makeIcon('qlt_ico', context),
            ]
          ),
          _withPadding(const Text(
            copyright,
            style: TextStyle(fontSize: 14) // TODO: extract default subtitle font style
          ))
        ]
      )),
    )
  );
}