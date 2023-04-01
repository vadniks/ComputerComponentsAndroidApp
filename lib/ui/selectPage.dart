
// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter_svg/svg.dart';
import '../consts.dart';
import '../model/component.dart';
import '../util.dart';
import 'package:flutter/material.dart';

import 'widgets.dart';

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
  var _isSearching = false;
  late final TextEditingController _searchController;

  NavigatorState get _navigator => Navigator.of(context);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // final dynamic args = ModalRoute.of(context)!.settings.arguments;
    // if (args == null || args is! Type) {
    //   _type = ComponentType.cpu;
    //   _isLeaving = true;
    // } else
    //   _type = args as ComponentType;
    _type = ComponentType.cpu;

    if (!_isLeaving) _loadItems();
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

  Widget _makeItem(Component component, BuildContext context) => ListTile(
    onTap: () => _onItemClick(component),
    leading: component.id == null
      ? SvgPicture.asset(
        assets + appIcon + svgExtension,
        width: 50,
        height: 50
      )
      : null, // TODO
    title: Text(
      component.title,
      overflow: TextOverflow.ellipsis,
    ),
    trailing: Text('\$${component.cost}')
  );

  Future<List<Component>> _fetch() async => [for (var i = 0; i < 10; i++) Component( // TODO: test only
    title: i.toString(),
    type: ComponentType.values[i % ComponentType.amount],
    description: (i * 10).toString(),
    cost: i,
    image: ComponentType.values[i % ComponentType.amount].icon
  )];

  Future<void> _loadItems() async {
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
    await _loadItems();
  }

  void _onItemClick(Component component) => showModalBottomSheet( // TODO: redesign bottomSheet or create a separate page for displaying component's details
    context: context,
    builder: (builder) => SingleChildScrollView(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ListTile(
          leading: Text(''),

        )
      ]
    ))
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: !_isSearching
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            appNameWidget,
            Text(
              componentsSelection,
              style: TextStyle(fontSize: 14),
            )
          ]
        )
        : makeTextField(
          controller: _searchController,
          hint: searchByTitle
        ),
      actions: [AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        child: IconButton(
            onPressed: () => setState(() => _isSearching = !_isSearching),
            icon: Icon(!_isSearching ? Icons.search : Icons.close)
          )
      )]
    ),
    body: _hasFetched && _items.isEmpty // TODO: replace progress bar with refresh indicator
      ? const Center(child: Text(
        empty,
        style: TextStyle(fontSize: 18),
      ))
      : RefreshIndicator(
        onRefresh: () async {},
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        notificationPredicate: (notification) => notification.depth == 0 && !_isSearching,
        child: ListView.separated(
          itemBuilder: (_, index) => _makeItem(_items[index], context),
          separatorBuilder: (_, index) => divider,
          itemCount: _items.length
        ),
      )
  );
}
