
// ignore_for_file: curly_braces_in_flow_control_structures, avoid_function_literals_in_foreach_calls

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
  var _totalCost = 0;

  Future<bool> _checkAuthAnNotify() async {
    if (!await appSate.net.authorized) {
      if (mounted) showSnackBar(unauthorized);
      return false;
    }
    return true;
  }

  void _calcCost() => _selected.forEach((i) => _totalCost += i?.cost ?? 0);

  void _onItemClick(int index) async {
    if (!await _checkAuthAnNotify()) return;

    final component = await navigator.pushNamed(
      routeSelect,
      arguments: ComponentType.values[index]
    );

    if (component != null && component is Component) {
      if (component.id != null)
        _selected[index] = component;
      else
        _selected[index] = null;
    }

    _totalCost = 0;
    _calcCost();

    if (mounted) updateState();
  }

  Widget _makeItem(int index) {
    final component = _selected[index] ?? makeStubComponent(index: index);
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

  Future<void> _fetchSelected() async {
    var index = 0;
    for (final component in await appSate.net.fetchSelected()) {
      _selected[index] = component;
      index++;
    }
    _calcCost();
    updateState();
  }

  void _onReturnFromLoginPage() {
    updateState();
    appSate.net.authorized.then((authorized)
    { if (authorized) _fetchSelected(); });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: svgImage(appIcon),
      ),
      title: appBarTexts(makeGreeting(appSate.net.fetchName())),
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
                : navigator.pushNamed(routeLogin).then((_) => _onReturnFromLoginPage()),
              icon: Icon(authorized ? Icons.logout : Icons.login)
            );
          }
        ),
        IconButton(
          onPressed: () async {
            if (!await _checkAuthAnNotify()) return;
            navigator.pushNamed(routeOrder);
          },
          icon: const Icon(Icons.shopping_cart),
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
