
import 'package:flutter/material.dart';
import '../consts.dart';
import '../model/component.dart';
import '../util.dart';
import '../model/proxies.dart';

class HomePage extends AbsPage {
  const HomePage(super.appSate, {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends PageState<HomePage> {
  final _selected = List<Component?>.filled(ComponentType.amount, null);
  final _submitControllers = List.generate(4, (_) => TextEditingController(), growable: false);
  var _totalCost = 0;
  String? _userName;
  var _isFetchingOrders = false;

  NavigatorState get _navigator => Navigator.of(context);

  void _onItemClick(int index) async {
    final component = await _navigator.pushNamed(
      routeSelect,
      arguments: ComponentType.values[index]
    );
    setState(() => _selected[index] = component != null && component is Component ? component : null);
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
    final stubImage = svgImageDefaultSized(component.image);

    return ListTile(
      leading: component.id == null ? stubImage : FutureBuilder<Widget?>(
        future: appSate.net.fetchImage(component.image),
        builder: (_, snapshot) => snapshot.data ?? stubImage
      ),
      title: Text(component.title),
      subtitle: Text(component.type.title),
      trailing: Text(component.cost.withDollarSign),
      onTap: () => _onItemClick(index),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: svgImage(appIcon),
      title: appBarTexts(subtitle(
        '$welcome $anonymous!', // TODO
        overflow: TextOverflow.ellipsis
      )),
      actions: [
        IconButton(
          onPressed: () => _navigator.pushNamed(routeAbout),
          icon: const Icon(Icons.info)
        ),
        IconButton(
          onPressed: () => _navigator.pushNamed(routeLogin), // TODO
          icon: Icon(Icons.login)
        )
      ]
    ),
    body: ListView.separated(
      itemBuilder: (_, index) => _makeItem(index),
      separatorBuilder: (_, __) => divider,
      itemCount: _selected.length
    )
  );
}
