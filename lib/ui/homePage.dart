
import 'package:flutter/material.dart';
import '../consts.dart';
import '../model/component.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _selected = List<Component?>.filled(ComponentType.amount, null);
  final _submitControllers = List.generate(4, (_) => TextEditingController(), growable: false);
  var _totalCost = 0, _authorized = false;
  String? _userName;
  var _isFetchingOrders = false;

  Component _makeStubComponent(int index) {
    final type = ComponentType.create(id: index)!;
    return Component(
      title: notSelected,
      type: type,
      description: notSelected,
      cost: 0
    );
  }

  Widget _makeItem(int index) {
    final component = _selected[index] ?? _makeStubComponent(index);
    return ListTile(
      leading: const SizedBox(width: 50, height: 50,),// TODO load image
      title: Text(component.title),
      subtitle: Text(component.type.title),
      trailing: Text(component.cost.toString()),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text(appName)),
    body: ListView.separated(
      itemBuilder: (context, index) => _makeItem(index),
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemCount: _selected.length
    )
  );
}
