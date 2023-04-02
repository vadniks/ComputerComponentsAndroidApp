
import 'package:flutter/material.dart';
import '../model/proxies.dart';
import '../util.dart';
import '../consts.dart';

class OrderPage extends AbsPage {
  const OrderPage(super.appSate, {super.key});

  @override
  State<StatefulWidget> createState() => _OrderPageState();
}

class _OrderPageState extends PageState<OrderPage> {
  final _submitControllers = List.generate(4, (_) => TextEditingController(), growable: false);
  var _isFetchingOrders = false;

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(
        title: appBarTexts(subtitle(orders)),
        bottom: const TabBar(tabs: [
          Tab(text: create),
          Tab(text: history)
        ]),
      ),
      body: TabBarView(children: [
        Center(child: SingleChildScrollView(child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            makeTextField(controller: _submitControllers[0], hint: '')
          ]
        )))
      ])
    )
  );
}
