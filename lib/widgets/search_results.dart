import 'package:flutter/material.dart';
import 'package:famnom_flutter/details/details.dart';
import 'package:famnom_flutter/widgets/widgets.dart';
import 'package:search_repository/search_repository.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({
    Key? key,
    required this.results,
    required this.controller,
    this.withSpinner = false,
  }) : super(key: key);

  final ScrollController controller;
  final List<SearchResult> results;
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
          final searchRows = results
              .map(
                (result) => SearchRowWidget(
                  searchResult: result,
                  onTap: (query) {
                    Navigator.of(context)
                        .push(DetailsDBFoodPage.route(result.externalId));
                  },
                ),
              )
              .toList();
          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
            child: index == searchRows.length
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
                : searchRows[index],
          );
        },
      ),
    );
  }
}
