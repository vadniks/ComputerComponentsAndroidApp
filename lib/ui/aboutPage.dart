
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
    appBar: AppBar(
      leading: SvgPicture.asset(assets + appIcon + svgExtension), // TODO: extract template
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          appNameWidget,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              slogan,
              style: TextStyle(fontSize: 14),
            ),
          )
        ]
      ),
    ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    )
  );
}
