
// ignore_for_file: curly_braces_in_flow_control_structures

import '../consts.dart';
import '../model/component.dart';
import '../util.dart';
import 'package:flutter/material.dart';
import '../model/proxies.dart';

class SelectPage extends AbsPage {
  const SelectPage(super.appSate, {super.key});

  @override
  State<StatefulWidget> createState() => _SelectPageState();
}

class _SelectPageState extends PageState<SelectPage> {
  late final ComponentType _type;
  final List<Component> _items = [];
  var _isFetching = false;
  var _hasFetched = false;
  var _hasSearched = false;
  var _isLeaving = false;
  var _isSearching = false;
  late final TextEditingController _searchController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setType(ComponentType type) { try {
      _type = type;
    } catch (e) {/*ignored*/} }

    final dynamic args = getArgs(context);
    if (args == null || args is! ComponentType) {
      setType(ComponentType.cpu);
      _isLeaving = true;
    } else
      setType(args);

    if (!_isLeaving && _items.isEmpty) _loadItems();
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController()..addListener(_search);
  }

  @override
  void dispose() {
    _searchController.removeListener(_search);
    super.dispose();
  }

  Widget _makeItem(Component component) {
    final stubImage = svgImageDefaultSized(_type.icon);
    return ListTile(
      onTap: () => _onItemClick(component),
      leading: component.id == null ? stubImage : FutureBuilder<Widget?>(
        future: appSate.net.fetchImage(component.image),
        builder: (_, snapshot) => snapshot.data ?? stubImage
      ),
      title: Text(
        component.title,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(component.cost.withDollarSign)
    );
  }

  Future<List<Component>> _fetch() async => await appSate.net.fetchComponents(_type);

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

  void _onItemClick(Component component) async
  => _showComponentDetails(component, await appSate.net.fetchImage(component.image, false));

  void _showComponentDetails(Component component, Widget? fetchedImage) => showModalBottomSheet(
    context: context,
    builder: (builder) => SingleChildScrollView(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ListTile(
          title: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(component.title)
          ),
          trailing: IconButton(
            onPressed: () => navigator..pop()..pop(component),
            icon: const Icon(Icons.done),
          ),
        ),
        divider,
        ListTile(
          leading: Text(component.type.title),
          trailing: Text(component.cost.withDollarSign),
        ),
        DefaultTabController(
          length: 2,
          child: Column(children: [
            const TabBar(tabs: [
              Tab(
                text: description,
                icon: Icon(Icons.description),
              ),
              Tab(
                text: image,
                icon: Icon(Icons.image)
              )
            ]),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SizedBox(
                width: screenSize.width,
                height: screenSize.height * 0.3,
                child: TabBarView(children: [
                  ListTile(subtitle: Text(
                    component.description,
                    textAlign: TextAlign.justify,
                  )),
                  fetchedImage ?? svgImageDefaultSized(_type.icon)
                ])
              ),
            )
          ])
        )
      ]
    ))
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: !_isSearching ? appBarTexts(subtitle(
        _type.title + selection,
        overflow: TextOverflow.ellipsis
      )) : makeTextField(
        controller: _searchController,
        hint: searchByTitle,
        autofocus: true
      ),
      actions: [
        if (!_isSearching) IconButton(
          onPressed: () => navigator.pop(makeStubComponent(type: _type)),
          icon: const Icon(Icons.remove_circle),
        ),
        IconButton(
          onPressed: () => setState(() => _isSearching = !_isSearching),
          icon: Icon(!_isSearching ? Icons.search : Icons.close)
        )
      ]
    ),
    body: _hasFetched && _items.isEmpty
      ? const Center(child: Text(
        empty,
        style: TextStyle(fontSize: 18),
      ))
      : Column(children: [
        if (_isFetching) const LinearProgressIndicator(),
        Expanded(child: RefreshIndicator(
          onRefresh: () async {},
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          notificationPredicate: (notification) => notification.depth == 0 && !_isSearching,
          child: ListView.separated(
            itemBuilder: (_, index) => _makeItem(_items[index]),
            separatorBuilder: (_, index) => divider,
            itemCount: _items.length
          ),
        ))
      ])
  );
}
