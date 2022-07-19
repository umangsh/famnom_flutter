import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famnom_flutter/details/details.dart';
import 'package:famnom_flutter/edit/edit.dart';
import 'package:famnom_flutter/home/home.dart';
import 'package:famnom_flutter/widgets/widgets.dart';

class DetailsUserMealView extends StatefulWidget {
  const DetailsUserMealView({Key? key, required this.externalId})
      : super(key: key);

  final String externalId;

  @override
  State<DetailsUserMealView> createState() => _DetailsUserMealViewState();
}

class _DetailsUserMealViewState extends State<DetailsUserMealView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: MyAppBar(
        showLogo: false,
        endWidget: IconButton(
          icon: const Icon(
            Icons.delete_forever_outlined,
            size: 32,
          ),
          key: const Key('delete_iconButton'),
          onPressed: () {
            final detailsCubit = BlocProvider.of<DetailsUserMealCubit>(context);
            showDialog<void>(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Alert'),
                  content: const Text('Confirm Delete?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        detailsCubit.delete(externalId: widget.externalId);
                        Navigator.pop(context);
                      },
                      child: const Text('Confirm'),
                    ),
                    TextButton(
                      onPressed: () {
                        detailsCubit.cancelDelete();
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    )
                  ],
                );
              },
            );
          },
          padding: EdgeInsets.zero,
          tooltip: 'Delete Meal',
        ),
      ),
      body: BlocListener<DetailsUserMealCubit, DetailsState>(
        listener: (context, state) {
          if (state.status == DetailsStatus.requestFailure ||
              state.status == DetailsStatus.saveRequestFailure) {
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

          if (state.status == DetailsStatus.deleteRequestSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text(
                    'Meal deleted.',
                  ),
                ),
              );
            Navigator.of(context)
                .push(HomePage.route(selectedTab: 3, selectedKitchenTab: 2));
          }

          if (state.status == DetailsStatus.deleteRequestCancelled) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text(
                    'Delete cancelled.',
                  ),
                ),
              );
          }
        },
        child: BlocBuilder<DetailsUserMealCubit, DetailsState>(
          builder: (context, state) {
            switch (state.status) {
              case DetailsStatus.init:
                context
                    .read<DetailsUserMealCubit>()
                    .loadPageData(externalId: widget.externalId);
                return const EmptySpinner();
              case DetailsStatus.requestSubmitted:
              case DetailsStatus.requestFailure:
              case DetailsStatus.deleteRequestSuccess:
                return const EmptySpinner();
              case DetailsStatus.requestSuccess:
              case DetailsStatus.portionSelected:
              case DetailsStatus.saveRequestSubmitted:
              case DetailsStatus.saveRequestSuccess:
              case DetailsStatus.saveRequestFailure:
              case DetailsStatus.deleteRequestCancelled:
              case DetailsStatus.deleteRequestSubmitted:
                return RefreshIndicator(
                  backgroundColor: theme.scaffoldBackgroundColor,
                  color: theme.colorScheme.secondary,
                  onRefresh: () {
                    return context
                        .read<DetailsUserMealCubit>()
                        .loadPageData(externalId: widget.externalId);
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                    children: <Widget>[
                      /// Meal name
                      Text(
                        state.userMeal!.mealType,
                        softWrap: true,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.userMeal!.displayDate,
                        softWrap: true,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),

                      /// Food members
                      if (state.userMeal!.memberIngredients!.isNotEmpty) ...[
                        UserMemberIngredientResults(
                          results: state.userMeal!.memberIngredients!,
                        ),
                        const SizedBox(height: 20),
                      ],

                      /// Recipe members
                      if (state.userMeal!.memberRecipes!.isNotEmpty) ...[
                        UserMemberRecipeResults(
                          results: state.userMeal!.memberRecipes!,
                        ),
                        const SizedBox(height: 20),
                      ],
                      const SizedBox(height: 10),

                      /// Nutrition label
                      NutritionLabel(
                        nutrients: state.userMeal!.nutrients!,
                        quantity: state.quantity,
                        fdaRDIs: state.fdaRDIs,
                        nutritionPreferences: state.nutritionPreferences,
                      )
                    ],
                  ),
                );
            }
          },
        ),
      ),
      floatingActionButton: BlocBuilder<DetailsUserMealCubit, DetailsState>(
        builder: (context, state) {
          return Visibility(
            visible: [
              DetailsStatus.requestSuccess,
              DetailsStatus.portionSelected,
            ].contains(state.status),
            child: FloatingActionButton(
              onPressed: () async {
                await Navigator.of(context).push(
                  EditUserMealPage.route(
                    externalId: widget.externalId,
                  ),
                );
              },
              tooltip: 'Edit Meal',
              backgroundColor: theme.primaryColor,
              child: const Icon(Icons.create),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomBar(
        onTap: (index) async {
          await Navigator.of(context).push(HomePage.route(selectedTab: index));
        },
      ),
    );
  }
}
