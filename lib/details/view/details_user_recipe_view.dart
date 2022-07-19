import 'package:app_repository/app_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famnom_flutter/details/details.dart';
import 'package:famnom_flutter/edit/edit.dart';
import 'package:famnom_flutter/home/home.dart';
import 'package:famnom_flutter/log/log.dart';
import 'package:famnom_flutter/widgets/widgets.dart';

class DetailsUserRecipeView extends StatefulWidget {
  const DetailsUserRecipeView({
    Key? key,
    required this.externalId,
    this.membershipExternalId,
    this.onDeleteRoute,
  }) : super(key: key);

  final String externalId;
  final String? membershipExternalId;
  final Route<String>? onDeleteRoute;

  @override
  State<DetailsUserRecipeView> createState() => _DetailsUserRecipeViewState();
}

class _DetailsUserRecipeViewState extends State<DetailsUserRecipeView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: MyAppBar(
          showLogo: false,
          endWidget: IconButton(
            icon: const Icon(
              Icons.delete_forever_outlined,
              size: 32,
            ),
            key: const Key('delete_iconButton'),
            onPressed: () {
              final detailsCubit =
                  BlocProvider.of<DetailsUserRecipeCubit>(context);
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
                          detailsCubit.delete(
                            externalId: widget.externalId,
                            membershipExternalId: widget.membershipExternalId,
                          );
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
            tooltip: 'Delete Recipe',
          ),
        ),
        body: BlocListener<DetailsUserRecipeCubit, DetailsState>(
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
                      'Recipe deleted.',
                    ),
                  ),
                );

              if (widget.onDeleteRoute != null) {
                Navigator.of(context).push(widget.onDeleteRoute!);
              } else {
                Navigator.of(context).pop();
              }
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
          child: BlocBuilder<DetailsUserRecipeCubit, DetailsState>(
            builder: (context, state) {
              switch (state.status) {
                case DetailsStatus.init:
                  context.read<DetailsUserRecipeCubit>().loadPageData(
                        externalId: widget.externalId,
                        membershipExternalId: widget.membershipExternalId,
                      );
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
                          .read<DetailsUserRecipeCubit>()
                          .loadPageData(
                            externalId: widget.externalId,
                            membershipExternalId: widget.membershipExternalId,
                          );
                    },
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                      children: <Widget>[
                        /// Food name
                        Text(
                          state.userRecipe!.name,
                          softWrap: true,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.userRecipe!.displayDate,
                          softWrap: true,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 24),

                        /// Food members
                        if (state
                            .userRecipe!.memberIngredients!.isNotEmpty) ...[
                          UserMemberIngredientResults(
                            results: state.userRecipe!.memberIngredients!,
                          ),
                          const SizedBox(height: 20),
                        ],

                        /// Recipe members
                        if (state.userRecipe!.memberRecipes!.isNotEmpty) ...[
                          UserMemberRecipeResults(
                            results: state.userRecipe!.memberRecipes!,
                          ),
                          const SizedBox(height: 20),
                        ],
                        const SizedBox(height: 10),

                        /// Portion details
                        PortionDetails(
                          portions: state.userRecipe!.portions!,
                          defaultPortion: state.selectedPortion!,
                          defaultQuantity: state.quantity,
                          onChangedServings: (value) {
                            context
                                .read<DetailsUserRecipeCubit>()
                                .selectPortion(portion: value! as Portion);
                          },
                          onChangedQuantity: (value) {
                            double quantity;
                            try {
                              quantity = double.parse(value.toString());
                            } catch (_) {
                              quantity = 1;
                            }
                            context
                                .read<DetailsUserRecipeCubit>()
                                .setQuantity(quantity: quantity);
                          },
                        ),

                        /// Log form
                        BlocProvider(
                          create: (_) => LogUserRecipeCubit(
                            appRepository: context.read<AppRepository>(),
                            mealType:
                                state.userRecipe?.membership?.meal?.mealType,
                            mealDate:
                                state.userRecipe?.membership?.meal?.mealDate,
                          ),
                          child: LogUserRecipeForm(
                            externalId: widget.externalId,
                            membershipExternalId: widget.membershipExternalId,
                          ),
                        ),

                        /// Nutrition label
                        NutritionLabel(
                          nutrients: state.userRecipe!.nutrients!,
                          portion: state.selectedPortion,
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
        floatingActionButton: BlocBuilder<DetailsUserRecipeCubit, DetailsState>(
          builder: (context, state) {
            return Visibility(
              visible: [
                DetailsStatus.requestSuccess,
                DetailsStatus.portionSelected,
              ].contains(state.status),
              child: FloatingActionButton(
                onPressed: () async {
                  await Navigator.of(context).push(
                    EditUserRecipePage.route(
                      externalId: widget.externalId,
                    ),
                  );
                },
                tooltip: 'Edit Recipe',
                backgroundColor: theme.primaryColor,
                child: const Icon(Icons.create),
              ),
            );
          },
        ),
        bottomNavigationBar: BottomBar(
          onTap: (index) async {
            await Navigator.of(context)
                .push(HomePage.route(selectedTab: index));
          },
        ),
      ),
    );
  }
}
