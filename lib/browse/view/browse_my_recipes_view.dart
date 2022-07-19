import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famnom_flutter/browse/browse.dart';
import 'package:famnom_flutter/edit/edit.dart';
import 'package:famnom_flutter/widgets/widgets.dart';

class BrowseMyRecipesView extends StatefulWidget {
  const BrowseMyRecipesView({Key? key}) : super(key: key);

  @override
  State<BrowseMyRecipesView> createState() => _BrowseMyRecipesViewState();
}

class _BrowseMyRecipesViewState extends State<BrowseMyRecipesView>
    with AutomaticKeepAliveClientMixin<BrowseMyRecipesView> {
  final _scrollController = ScrollController();
  final _textController = TextEditingController();

  @override
  void initState() {
    _scrollController.addListener(_scrollControllerListener);
    super.initState();
  }

  void _scrollControllerListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      BlocProvider.of<BrowseMyRecipesCubit>(context).getMoreResults();
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _scrollController
      ..removeListener(_scrollControllerListener)
      ..dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    return BlocListener<BrowseMyRecipesCubit, BrowseState>(
      listener: (context, state) {
        if (state.status == BrowseStatus.requestFailure) {
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
      child: Column(
        children: [
          InlineSearchBar(
            controller: _textController,
            hintText: 'Search kitchen...',
            onSubmitted: (query) {
              if (query.isEmpty) {
                return;
              }
              _textController.text = query;
              BlocProvider.of<BrowseMyRecipesCubit>(context)
                  .getResultsWithQuery(query);
            },
            onClearPressed: () {
              _textController.clear();
              BlocProvider.of<BrowseMyRecipesCubit>(context).clearSearchBar();
            },
          ),
          Expanded(
            child: BlocBuilder<BrowseMyRecipesCubit, BrowseState>(
              builder: (context, state) {
                switch (state.status) {
                  case BrowseStatus.init:
                  case BrowseStatus.barcodeRequest:
                    context.read<BrowseMyRecipesCubit>().getResultsWithQuery();
                    return const EmptySpinner();
                  case BrowseStatus.requestSubmitted:
                  case BrowseStatus.requestFailure:
                    return const EmptySpinner();
                  case BrowseStatus.requestFinishedEmptyResults:
                    return EmptyResults(
                      firstLine: "Don't see any saved recipes?",
                      secondLine: 'Add and log your own recipes.',
                      buttonText: 'Add Recipe',
                      onPressed: () async {
                        await Navigator.of(context)
                            .push(EditUserRecipePage.route());
                      },
                    );
                  case BrowseStatus.requestFinishedWithResults:
                  case BrowseStatus.requestMoreFinishedWithResults:
                    return RefreshIndicator(
                      backgroundColor: theme.scaffoldBackgroundColor,
                      color: theme.colorScheme.secondary,
                      onRefresh: () {
                        return context
                            .read<BrowseMyRecipesCubit>()
                            .getResultsWithQuery();
                      },
                      child: UserRecipeResults(
                        results: state.recipeResults,
                        controller: _scrollController,
                        withSpinner: true,
                      ),
                    );
                  case BrowseStatus.requestMoreFinishedEmptyResults:
                    return RefreshIndicator(
                      backgroundColor: theme.scaffoldBackgroundColor,
                      color: theme.colorScheme.secondary,
                      onRefresh: () {
                        return context
                            .read<BrowseMyRecipesCubit>()
                            .getResultsWithQuery();
                      },
                      child: UserRecipeResults(
                        results: state.recipeResults,
                        controller: _scrollController,
                      ),
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
