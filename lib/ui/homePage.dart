
// ignore_for_file: curly_braces_in_flow_control_structures

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
  final _submitControllers = List.generate(4, (_) => TextEditingController(), growable: false); // TODO: move to a separate page
  var _totalCost = 0;
  String? _userName;
  var _isFetchingOrders = false;

  Future<bool> _checkAuthAnNotify() async {
    if (!await appSate.net.authorized) {
      if (mounted) showSnackBar(unauthorized);
      return false;
    }
    return true;
  }

  void _onItemClick(int index) async {
    if (!await _checkAuthAnNotify()) return;

    final component = await navigator.pushNamed(
      routeSelect,
      arguments: ComponentType.values[index]
    );
    final chosen = component != null && component is Component;

    _selected[index] = chosen ? component : null;
    _totalCost = 0;
    for (final i in _selected) _totalCost += i?.cost ?? 0;

    if (mounted) updateState();
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
    final stubImage = svgImageDefaultSized(component.type.icon);

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

  void _logout() async {
    if (mounted) showSnackBar(await appSate.net.logout() ? successfulText : failedText);
    updateState();
  }

  void _clear() async {
    if (!await _checkAuthAnNotify()) return;

    for (var i = 0; i < _selected.length; i++)
      _selected[i] = null;
    _totalCost = 0;

    updateState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: svgImage(appIcon),
      ),
      title: appBarTexts(makeGreeting(appSate.net.fetchName)),
      actions: [
        IconButton(
          onPressed: () => navigator.pushNamed(routeAbout),
          icon: const Icon(Icons.info)
        ),
        FutureBuilder<bool>(
          future: appSate.net.authorized,
          builder: (_, snapshot) {
            final authorized = snapshot.data != null && snapshot.data == true;
            return IconButton(
              onPressed: () => authorized
                ? _logout()
                : navigator.pushNamed(routeLogin).then((_) => Future.delayed(
                  const Duration(seconds: 1),
                  updateState
                )),
              icon: Icon(authorized ? Icons.logout : Icons.login)
            );
          }
        )
      ]
    ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: ListView.separated(
          itemBuilder: (_, index) => _makeItem(index),
          separatorBuilder: (_, __) => divider,
          itemCount: _selected.length
        )),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            divider,
            ListTile(
              title: Text('$totalCost ${_totalCost.withDollarSign}'),
              trailing: IconButton(
                onPressed: _clear,
                icon: const Icon(Icons.clear_all),
              ),
            )
          ]
        )
      ]
    )
  );
}
