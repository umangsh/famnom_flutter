import 'package:app_repository/app_repository.dart';
import 'package:flutter/material.dart';
import 'package:famnom_flutter/details/details.dart';
import 'package:famnom_flutter/home/home.dart';
import 'package:famnom_flutter/widgets/widgets.dart';

class UserIngredientResults extends StatelessWidget {
  const UserIngredientResults({
    Key? key,
    required this.results,
    required this.controller,
    this.withSpinner = false,
  }) : super(key: key);

  final ScrollController controller;
  final List<UserIngredientDisplay> results;
  final bool withSpinner;
  static const minScrollableItems = 7;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: controller,
        itemCount: withSpinner
            ? results.length < minScrollableItems
                ? results.length
                : results.length + 1
            : results.length,
        separatorBuilder: (context, index) => Divider(
          color: theme.colorScheme.secondary,
          indent: 20,
          endIndent: 20,
        ),
        itemBuilder: (context, index) {
          final resultRows = results
              .map(
                (result) => UserIngredientRowWidget(
                  result: result,
                  onTap: (query) {
                    Navigator.of(context).push(
                      DetailsUserIngredientPage.route(
                        externalId: result.externalId,
                        onDeleteRoute: HomePage.route(selectedTab: 3),
                      ),
                    );
                  },
                ),
              )
              .toList();
          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
            child: index == resultRows.length
                ? Center(
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(
                        color: theme.colorScheme.secondary,
                        backgroundColor: theme.scaffoldBackgroundColor,
                      ),
                    ),
                  )
                : resultRows[index],
          );
        },
      ),
    );
  }
}
