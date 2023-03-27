
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  void _onItemClick(int index) {

  }

  Component _makeStubComponent(int index) {
    final type = ComponentType.create(id: index)!;
    return Component(
      title: notSelected,
      type: type,
      description: notSelected,
      cost: 0,
      image: type.icon
    );
  }

  Widget _makeItem(int index) {
    final component = _selected[index] ?? _makeStubComponent(index);
    return ListTile(
      leading: component.id != null
        ? null // TODO
        : SvgPicture.asset(
          assets + component.image + svgExtension,
          width: 50,
          height: 50
        ),
      title: Text(component.title),
      subtitle: Text(component.type.title),
      trailing: Text(component.cost.toString()),
      onTap: () => _onItemClick(index),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: SvgPicture.asset(assets + appIcon + svgExtension),
      title: const Text(
        appName,
        style: TextStyle(fontFamily: appNameFont),
      ),
      actions: [
        const IconButton(
          onPressed: null, // TODO
          icon: Icon(Icons.info)
        ),
        IconButton(
          onPressed: null, // TODO
          icon: Icon(_authorized ? Icons.logout : Icons.login)
        )
      ],
    ),
    body: ListView.separated(
      itemBuilder: (context, index) => _makeItem(index),
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemCount: _selected.length
    )
  );
}
