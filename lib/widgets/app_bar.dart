import 'package:constants/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:famnom_flutter/search/search.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  const MyAppBar({
    Key? key,
    this.showLogo = true,
    this.endWidget,
    this.showSearchIcon = true,
    this.secondaryTitle = '',
  }) : super(key: key);

  final bool showLogo;
  final Widget? endWidget;
  final bool showSearchIcon;
  final String secondaryTitle;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      centerTitle: false,
      titleSpacing: 0,
      leading: showLogo
          ? IconButton(
              icon: Image.asset(constants.appLogoPath, height: 56, width: 56),
              onPressed: () {},
            )
          : BackButton(color: theme.primaryColor),
      title: Text.rich(
        TextSpan(
          text: constants.appTitle,
          style: TextStyle(
            color: theme.colorScheme.secondary,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.5,
          ),
          children: [
            TextSpan(
              text: secondaryTitle,
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      foregroundColor: theme.primaryColor,
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      shadowColor: theme.scaffoldBackgroundColor,
      actions: <Widget>[
        if (showSearchIcon)
          IconButton(
            icon: const Icon(
              Icons.search,
              size: 32,
            ),
            key: const Key('search_iconButton'),
            tooltip: 'Search food database ...',
            onPressed: () async {
              await Navigator.of(context).push(SearchPage.route());
            },
            padding: EdgeInsets.zero,
          ),
        if (endWidget != null) endWidget!
      ],
    );
  }
}
