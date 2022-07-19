import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famnom_flutter/search/search.dart';

class SearchBar extends StatelessWidget with PreferredSizeWidget {
  const SearchBar({Key? key, required this.controller}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      foregroundColor: theme.primaryColor,
      leadingWidth: 25,
      shadowColor: theme.scaffoldBackgroundColor,
      title: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(5),
        ),
        height: 40,
        width: double.infinity,
        child: Center(
          child: TextField(
            key: key,
            textAlignVertical: TextAlignVertical.bottom,
            textInputAction: TextInputAction.search,
            onSubmitted: (query) {
              controller.text = query;
              BlocProvider.of<SearchCubit>(context)
                  .getSearchResultsWithQuery(query: query);
            },
            controller: controller,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  controller.clear();
                  BlocProvider.of<SearchCubit>(context).clearSearchBar();
                },
              ),
              hintText: 'Search food database...',
            ),
          ),
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.view_week_rounded,
            color: Colors.black,
          ),
          tooltip: 'Search barcode',
          padding: EdgeInsets.zero,
          onPressed: () {
            BlocProvider.of<SearchCubit>(context).scannerInit();
          },
        ),
      ],
    );
  }
}
