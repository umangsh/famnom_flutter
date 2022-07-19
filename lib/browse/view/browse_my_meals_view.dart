import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famnom_flutter/browse/browse.dart';
import 'package:famnom_flutter/edit/edit.dart';
import 'package:famnom_flutter/widgets/widgets.dart';

class BrowseMyMealsView extends StatefulWidget {
  const BrowseMyMealsView({Key? key}) : super(key: key);

  @override
  State<BrowseMyMealsView> createState() => _BrowseMyMealsViewState();
}

class _BrowseMyMealsViewState extends State<BrowseMyMealsView>
    with AutomaticKeepAliveClientMixin<BrowseMyMealsView> {
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
      BlocProvider.of<BrowseMyMealsCubit>(context).getMoreResults();
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
    return BlocListener<BrowseMyMealsCubit, BrowseState>(
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
          Expanded(
            child: BlocBuilder<BrowseMyMealsCubit, BrowseState>(
              builder: (context, state) {
                switch (state.status) {
                  case BrowseStatus.init:
                  case BrowseStatus.barcodeRequest:
                    context.read<BrowseMyMealsCubit>().getResults();
                    return const EmptySpinner();
                  case BrowseStatus.requestSubmitted:
                  case BrowseStatus.requestFailure:
                    return const EmptySpinner();
                  case BrowseStatus.requestFinishedEmptyResults:
                    return EmptyResults(
                      firstLine: "Don't see any saved meals?",
                      secondLine: 'Add and save your own meals.',
                      buttonText: 'Add Meal',
                      onPressed: () async {
                        await Navigator.of(context).push(
                          EditUserMealPage.route(),
                        );
                      },
                    );
                  case BrowseStatus.requestFinishedWithResults:
                  case BrowseStatus.requestMoreFinishedWithResults:
                    return RefreshIndicator(
                      backgroundColor: theme.scaffoldBackgroundColor,
                      color: theme.colorScheme.secondary,
                      onRefresh: () {
                        return context.read<BrowseMyMealsCubit>().getResults();
                      },
                      child: UserMealResults(
                        results: state.mealResults,
                        controller: _scrollController,
                        withSpinner: true,
                      ),
                    );
                  case BrowseStatus.requestMoreFinishedEmptyResults:
                    return RefreshIndicator(
                      backgroundColor: theme.scaffoldBackgroundColor,
                      color: theme.colorScheme.secondary,
                      onRefresh: () {
                        return context.read<BrowseMyMealsCubit>().getResults();
                      },
                      child: UserMealResults(
                        results: state.mealResults,
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
