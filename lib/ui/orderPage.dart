
// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import '../model/component.dart';
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
  final _ordered = <Component>[];

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  void _fetchHistory() async {
    setState(() => _isFetchingOrders = true);

    _ordered.clear();
    for (final i in await appSate.net.fetchHistory())
      setState(() => _ordered.add(i));

    setState(() => _isFetchingOrders = false);
  }

  void _clearHistory() async {
    if (await appSate.net.clearHistory())
      setState(() => _ordered.clear());
    else if (mounted) showSnackBar(failedText);
  }

  void _submit() async => appSate.net
    .submit([for (final i in _submitControllers) i.text])
    .then((successful) {
      if (mounted) showSnackBar(successful ? successfulText : failedText);
      _fetchHistory(); // TODO: fetch history when user navigates to the history tab
    });

  Widget _makeItem(Component component) => ListTile(
    leading: FutureBuilder<Widget?>(
      future: appSate.net.fetchImage(component.image),
      builder: (_, snapshot) => snapshot.data ?? svgImageDefaultSized(component.type.icon),
    ),
    title: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Text(component.title),
    ),
    trailing: Text(component.cost.withDollarSign),
  );

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(
        title: appBarTexts(subtitle(orders)),
        bottom: const TabBar(tabs: [
          Tab(icon: Icon(Icons.create)),
          Tab(icon: Icon(Icons.history))
        ]),
      ),
      body: TabBarView(children: [
        Center(child: SingleChildScrollView(child: SizedBox(
          width: screenSize.width * 0.75,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                submitOrder,
                style: TextStyle(fontSize: 18),
              ),
              makeTextField(
                controller: _submitControllers[0],
                hint: firstName
              ),
              makeTextField(
                controller: _submitControllers[1],
                hint: lastName
              ),
              makeTextField(
                controller: _submitControllers[2],
                hint: phoneNumber,
                isNumeric: true
              ),
              makeTextField(
                controller: _submitControllers[3],
                hint: address
              ),
              TextButton(
                onPressed: _submit,
                child: const Text(submit),
              )
            ]
          )
        ))),
        Column(children: [
          if (_isFetchingOrders) const LinearProgressIndicator(),
          if (_ordered.isEmpty) const Expanded(child: Center(child: Text(
            empty,
            style: TextStyle(fontSize: 18),
          )))
          else Expanded(child: ListView.separated(
            itemBuilder: (_, index) => _makeItem(_ordered[index]),
            separatorBuilder: (_, __) => divider,
            itemCount: _ordered.length
          )),
          if (_ordered.isNotEmpty) TextButton(
            onPressed: _clearHistory,
            child: const Text(clear)
          )
        ])
      ])
    )
  );
}
