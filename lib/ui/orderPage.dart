
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

  void _submit() async {

  }

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
                controller: _submitControllers[0], // TODO: clear history button
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _ordered.isEmpty
              ? const Expanded(child: Center(child: Text(
                empty,
                style: TextStyle(fontSize: 18),
              )))
              : Expanded(child: ListView.separated(
                itemBuilder: (_, index) => _makeItem(_ordered[index]),
                separatorBuilder: (_, __) => divider,
                itemCount: _ordered.length
              )),
            if (_ordered.isNotEmpty) TextButton(
              onPressed: () {},
              child: const Text(clear)
            )
          ]
        )
      ])
    )
  );
}
