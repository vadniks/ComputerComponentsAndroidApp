
// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter_svg/svg.dart';

import '../consts.dart';
import '../model/component.dart';
import '../util.dart';
import 'widgets.dart';
import 'package:flutter/material.dart';

class SelectPage extends StatefulWidget {
  const SelectPage({super.key});

  @override
  State<StatefulWidget> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  late final ComponentType _type;
  final List<Component> _items = [];
  var _isFetching = false;
  var _hasFetched = false;
  var _hasSearched = false;
  var _isLeaving = false;
  late final TextEditingController _searchController;

  NavigatorState get _navigator => Navigator.of(context);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final dynamic args = ModalRoute.of(context)!.settings.arguments;
    if (args == null || args is! Type) {
      _type = ComponentType.cpu;
      _isLeaving = true;
    } else
      _type = args as ComponentType;

    if (!_isLeaving) _loadItems(true);
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController()..addListener(_search);
    // _checkAuthorization();
  }

  @override
  void dispose() {
    _searchController.removeListener(_search);
    super.dispose();
  }

  Widget _makeItem(Component component, BuildContext context) => Card(
    child: Material(child: ListTile(
      onTap: () => _onItemClick(component),
      leading: component.id == null
        ? SvgPicture.asset(
          appIcon,
          width: 50,
          height: 50
        )
        : null, // TODO
      title: Text(
        component.title,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text('\$${component.cost}'),
    )),
  );

  Future<List<Component>> _fetch() async => [ // TODO

  ];

  Future<void> _loadItems(bool firstTime) async {
    setState(() => _isFetching = true);

    final items = await _fetch();
    if (items.isNotEmpty) setState(() => _items.addAll(items));

    setState(() {
      _isFetching = false;
      _hasFetched = true;
    });
  }

  void _resetItemsList() => setState(() {
    _items.clear();
    _hasFetched = false;
  });

  Future<List<Component>> _doSearch(String query) async {
    final results = <Component>[];
    for (final i in await _fetch())
      if (i.title.containsIgnoreCase(query)) results.add(i);
    return results;
  }

  Future<void> _search() async {
    final query = _searchController.text;
    if (query.isEmpty) {
      if (_hasSearched) _refresh();
      return;
    }

    setState(() => _isFetching = true);
    _resetItemsList();

    _items.addAll(await _doSearch(query));
    setState(() {
      _isFetching = false;
      _hasFetched = true;
      _hasSearched = true;
    });
  }

  Future<void> _refresh() async {
    _resetItemsList();
    setState(() => _hasSearched = false);
    await _loadItems(true);
  }

  void _onItemClick(Component component) => showModalBottomSheet(
    constraints: const BoxConstraints(maxWidth: 700),
    context: context,
    builder: (builder) => Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 5,
              top: 5,
              right: 5
            ),
            child: Text(
              component.title,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          TextButton(
            onPressed: () => _navigator..pop()..pop(component),
            child: const Text(
              submit,
              style: TextStyle(fontSize: 18),
            )
          )
        ]
      ),
      const Divider(
        thickness: 1,
        height: 1,
      ),
      Expanded(child: Row(children: [
        //component.id == null
          /*?*/ SvgPicture.asset(
            appIcon,
            width: 300,
            height: 300
          ),
          //: null, // TODO
        const VerticalDivider(thickness: 1),
        RichText(
          textAlign: TextAlign.justify,
          text: TextSpan(
            text: component.description,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white70
            )
          )
        )
      ]))
    ])
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: makeAppBar(),
    body: _hasFetched && _items.isEmpty
      ? const Center(child: Text(
        empty,
        style: TextStyle(fontSize: 18),
      ))
      : ListView.separated(
        itemBuilder: (_, index) => _makeItem(_items[index], context),
        separatorBuilder: (_, index) => divider,
        itemCount: _items.length
      ),
  );
}
