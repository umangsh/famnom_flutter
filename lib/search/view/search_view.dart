import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famnom_flutter/edit/edit.dart';
import 'package:famnom_flutter/home/home.dart';
import 'package:famnom_flutter/search/search.dart';
import 'package:famnom_flutter/widgets/widgets.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _scrollController = ScrollController();
  final _textController = TextEditingController();

  @override
  void initState() {
    _scrollController.addListener(_scrollControllerListener);
    _textController.addListener(_textControllerListener);
    super.initState();
  }

  void _scrollControllerListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      BlocProvider.of<SearchCubit>(context).getMoreSearchResults();
    }
  }

  void _textControllerListener() {
    BlocProvider.of<SearchCubit>(context)
        .getAutocompleteResults(query: _textController.text);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_scrollControllerListener)
      ..dispose();
    _textController
      ..removeListener(_textControllerListener)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            if (state.status == SearchStatus.barcodeRequest) {
              return MyAppBar(
                showSearchIcon: false,
                secondaryTitle: ' Scanning...',
                endWidget: IconButton(
                  icon: const Icon(
                    Icons.clear,
                    size: 32,
                  ),
                  onPressed: () {
                    context.read<SearchCubit>().clearSearchBar();
                  },
                ),
              );
            } else {
              return SearchBar(
                key: const Key('search_queryInput_TextField'),
                controller: _textController,
              );
            }
          },
        ),
      ),
      body: BlocListener<SearchCubit, SearchState>(
        listener: (context, state) {
          if (state.status == SearchStatus.requestFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text(
                    state.errorMessage ??
                        'Something went wrong, please try again.',
                  ),
                ),
              );
          }
        },
        child: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            switch (state.status) {
              case SearchStatus.init:
              case SearchStatus.autocomplete:
                return AutocompleteResults(
                  results: state.autocompleteResults,
                  onTap: (String query) {
                    _textController.text = query;
                    context
                        .read<SearchCubit>()
                        .getSearchResultsWithQuery(query: query);
                  },
                );
              case SearchStatus.barcodeRequest:
                return const SearchScanner();
              case SearchStatus.requestSubmitted:
              case SearchStatus.requestFailure:
                return const EmptySpinner();
              case SearchStatus.requestFinishedEmptyResults:
                return EmptyResults(
                  firstLine: "Can't find what you're looking for?",
                  secondLine: 'Add and log your own food.',
                  buttonText: 'Add Food',
                  onPressed: () async {
                    await Navigator.of(context)
                        .push(EditUserIngredientPage.route());
                  },
                );
              case SearchStatus.requestFinishedWithResults:
              case SearchStatus.requestMoreFinishedWithResults:
                return RefreshIndicator(
                  backgroundColor: theme.scaffoldBackgroundColor,
                  color: theme.colorScheme.secondary,
                  onRefresh: () {
                    return context
                        .read<SearchCubit>()
                        .getSearchResultsWithQuery(query: _textController.text);
                  },
                  child: SearchResults(
                    results: state.searchResults,
                    controller: _scrollController,
                    withSpinner: true,
                  ),
                );
              case SearchStatus.requestMoreFinishedEmptyResults:
                return RefreshIndicator(
                  backgroundColor: theme.scaffoldBackgroundColor,
                  color: theme.colorScheme.secondary,
                  onRefresh: () {
                    return context
                        .read<SearchCubit>()
                        .getSearchResultsWithQuery(query: _textController.text);
                  },
                  child: SearchResults(
                    results: state.searchResults,
                    controller: _scrollController,
                  ),
                );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomBar(
        onTap: (index) async {
          await Navigator.of(context).push(HomePage.route(selectedTab: index));
        },
      ),
    );
  }
}
