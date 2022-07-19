import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    Key? key,
    required this.onTap,
    this.currentIndex = 0,
    this.selectionColor = Colors.black54,
  }) : super(key: key);

  final ValueChanged<int>? onTap;
  final int currentIndex;
  final Color selectionColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BottomNavigationBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      currentIndex: currentIndex,
      mouseCursor: SystemMouseCursors.grab,
      selectedIconTheme: IconThemeData(color: selectionColor),
      selectedItemColor: selectionColor,
      selectedLabelStyle: const TextStyle(fontSize: 12),
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.equalizer),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.tune),
          label: 'Goals',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_rounded),
          label: 'Mealplan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.kitchen),
          label: 'Kitchen',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Profile',
        ),
      ],
    );
  }
}
