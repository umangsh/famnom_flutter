import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famnom_flutter/browse/browse.dart';
import 'package:famnom_flutter/edit/edit.dart';
import 'package:famnom_flutter/widgets/widgets.dart';

class BrowseMyFoodsView extends StatefulWidget {
  const BrowseMyFoodsView({Key? key}) : super(key: key);

  @override
  State<BrowseMyFoodsView> createState() => _BrowseMyFoodsViewState();
}

class _BrowseMyFoodsViewState extends State<BrowseMyFoodsView>
    with AutomaticKeepAliveClientMixin<BrowseMyFoodsView> {
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
      BlocProvider.of<BrowseMyFoodsCubit>(context).getMoreResults();
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
    return BlocListener<BrowseMyFoodsCubit, BrowseState>(
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
              BlocProvider.of<BrowseMyFoodsCubit>(context)
                  .getResultsWithQuery(query);
            },
            onClearPressed: () {
              _textController.clear();
              BlocProvider.of<BrowseMyFoodsCubit>(context).clearSearchBar();
            },
            endWidget: IconButton(
              icon: const Icon(
                Icons.view_week_rounded,
                color: Colors.black,
              ),
              tooltip: 'Search barcode',
              padding: EdgeInsets.zero,
              onPressed: () {
                BlocProvider.of<BrowseMyFoodsCubit>(context).scannerInit();
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<BrowseMyFoodsCubit, BrowseState>(
              builder: (context, state) {
                switch (state.status) {
                  case BrowseStatus.init:
                    context.read<BrowseMyFoodsCubit>().getResultsWithQuery();
                    return const EmptySpinner();
                  case BrowseStatus.barcodeRequest:
                    return const MyFoodsScanner();
                  case BrowseStatus.requestSubmitted:
                  case BrowseStatus.requestFailure:
                    return const EmptySpinner();
                  case BrowseStatus.requestFinishedEmptyResults:
                    return EmptyResults(
                      firstLine: "Don't see any saved items?",
                      secondLine: 'Add and log your own food.',
                      buttonText: 'Add Food',
                      onPressed: () async {
                        await Navigator.of(context)
                            .push(EditUserIngredientPage.route());
                      },
                    );
                  case BrowseStatus.requestFinishedWithResults:
                  case BrowseStatus.requestMoreFinishedWithResults:
                    return RefreshIndicator(
                      backgroundColor: theme.scaffoldBackgroundColor,
                      color: theme.colorScheme.secondary,
                      onRefresh: () {
                        return context
                            .read<BrowseMyFoodsCubit>()
                            .getResultsWithQuery();
                      },
                      child: UserIngredientResults(
                        results: state.ingredientResults,
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
                            .read<BrowseMyFoodsCubit>()
                            .getResultsWithQuery();
                      },
                      child: UserIngredientResults(
                        results: state.ingredientResults,
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
