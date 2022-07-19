import 'package:flutter/material.dart';
import 'package:famnom_flutter/browse/browse.dart';
import 'package:famnom_flutter/edit/edit.dart';

class KitchenPage extends StatefulWidget {
  const KitchenPage({Key? key, this.selectedTab = 0}) : super(key: key);

  final int selectedTab;

  static Page page() => const MaterialPage<void>(child: KitchenPage());

  static Route<String> route({int selectedTab = 0}) {
    return MaterialPageRoute(
      builder: (_) => KitchenPage(selectedTab: selectedTab),
    );
  }

  @override
  State<KitchenPage> createState() => _KitchenPageState();
}

class _KitchenPageState extends State<KitchenPage>
    with SingleTickerProviderStateMixin {
  late int _selectedTab;
  late TabController _controller;

  static const List<Tab> _tabs = <Tab>[
    Tab(text: 'Foods'),
    Tab(text: 'Recipes'),
    Tab(text: 'Meals'),
  ];

  static const List<Widget> _pages = <Widget>[
    BrowseMyFoodsPage(),
    BrowseMyRecipesPage(),
    BrowseMyMealsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.selectedTab;
    _controller = TabController(
      initialIndex: _selectedTab,
      length: _tabs.length,
      vsync: this,
    );
    _controller.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    setState(() {});
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handleTabChange)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Column(
          children: [
            SafeArea(
              child: PreferredSize(
                preferredSize: const Size.fromHeight(80),
                child: TabBar(
                  controller: _controller,
                  tabs: _tabs,
                  unselectedLabelColor: Colors.black54,
                  labelColor: theme.primaryColor,
                  indicatorColor: theme.primaryColor,
                  indicatorSize: TabBarIndicatorSize.label,
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _controller,
                children: _pages,
              ),
            ),
          ],
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            onPressed: () async {
              if (_controller.index == 0) {
                await Navigator.of(context)
                    .push(EditUserIngredientPage.route());
              } else if (_controller.index == 1) {
                await Navigator.of(context).push(EditUserRecipePage.route());
              } else if (_controller.index == 2) {
                await Navigator.of(context).push(EditUserMealPage.route());
              }
            },
            autofocus: true,
            focusElevation: 5,
            tooltip: _controller.index == 0
                ? 'New Food'
                : _controller.index == 1
                    ? 'New Recipe'
                    : 'New Meal',
            backgroundColor: theme.primaryColor,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
