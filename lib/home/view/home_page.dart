import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famnom_flutter/app/app.dart';
import 'package:famnom_flutter/goals/view/goals_page.dart';
import 'package:famnom_flutter/kitchen/kitchen.dart';
import 'package:famnom_flutter/mealplan/mealplan.dart';
import 'package:famnom_flutter/profile/profile.dart';
import 'package:famnom_flutter/tracker/tracker.dart';
import 'package:famnom_flutter/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.selectedTab = 0, this.selectedKitchenTab = 0})
      : super(key: key);

  final int selectedTab;
  final int selectedKitchenTab;

  static Page page() => const MaterialPage<void>(child: HomePage());

  static Route<String> route({
    int selectedTab = 0,
    int selectedKitchenTab = 0,
  }) {
    return MaterialPageRoute(
      builder: (_) => HomePage(
        selectedTab: selectedTab,
        selectedKitchenTab: selectedKitchenTab,
      ),
    );
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _selectedBottomTab;
  late PageController _controller;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      const TrackerPage(),
      const GoalsPage(),
      const MealplanPage(),
      KitchenPage(selectedTab: widget.selectedKitchenTab),
      const ProfilePage(),
    ];
    _selectedBottomTab = widget.selectedTab;
    _controller = PageController(initialPage: _selectedBottomTab);
  }

  void _onPageChange(int index) {
    setState(() {
      _selectedBottomTab = index;
    });
  }

  void _onTapTab(int index) {
    setState(() {
      _selectedBottomTab = index;
      _controller.jumpToPage(index);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: _selectedBottomTab == 4 // Show logout button on Profile tab.
          ? MyAppBar(
              endWidget: IconButton(
                icon: const Icon(
                  Icons.logout,
                  size: 32,
                ),
                key: const Key('logout_iconButton'),
                onPressed: () {
                  // Go back to home before logout. FlowBuilder generates the
                  // right page after logout. Use popall so it pops all routes.
                  Navigator.popUntil(context, ModalRoute.withName('popall'));
                  context.read<AppBloc>().add(AppLogoutRequested());
                },
                padding: EdgeInsets.zero,
                tooltip: 'Logout',
              ),
            )
          : const MyAppBar(),
      body: PageView(
        controller: _controller,
        onPageChanged: _onPageChange,
        children: _pages,
      ),
      bottomNavigationBar: BottomBar(
        onTap: _onTapTab,
        currentIndex: _selectedBottomTab,
        selectionColor: theme.primaryColor,
      ),
    );
  }
}
