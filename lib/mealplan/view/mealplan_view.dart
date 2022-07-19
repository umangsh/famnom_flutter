// ignore_for_file: lines_longer_than_80_chars

import 'package:app_repository/app_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:famnom_flutter/home/home.dart';
import 'package:famnom_flutter/mealplan/mealplan.dart';
import 'package:famnom_flutter/widgets/widgets.dart';

class MealplanView extends StatefulWidget {
  const MealplanView({Key? key}) : super(key: key);

  @override
  State<MealplanView> createState() => _MealplanViewState();
}

class _MealplanViewState extends State<MealplanView>
    with AutomaticKeepAliveClientMixin<MealplanView> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocListener<MealplanCubit, MealplanState>(
        listener: (context, state) {
          if (state.status == MealplanStatus.requestFailure ||
              state.status == MealplanStatus.loadRequestFailure ||
              state.status == MealplanStatus.thresholdsRequestFailure ||
              state.status == MealplanStatus.mealplanRequestFailure) {
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

          if (state.status == MealplanStatus.mealplanSaved) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text('Mealplan saved'),
                ),
              );
            Navigator.of(context).push(HomePage.route());
          }
        },
        child: BlocBuilder<MealplanCubit, MealplanState>(
          builder: (context, state) {
            switch (state.status) {
              case MealplanStatus.init:
                context.read<MealplanCubit>().loadItems();
                return const EmptySpinner();
              case MealplanStatus.requestFailure:
              case MealplanStatus.loadRequestSubmitted:
              case MealplanStatus.loadRequestFailure:
              case MealplanStatus.thresholdsRequestSubmitted:
              case MealplanStatus.thresholdsRequestFailure:
              case MealplanStatus.mealplanRequestSubmitted:
              case MealplanStatus.mealplanRequestFailure:
                return const EmptySpinner();
              case MealplanStatus.loadRequestSuccess:
                return RefreshIndicator(
                  backgroundColor: theme.scaffoldBackgroundColor,
                  color: theme.colorScheme.secondary,
                  onRefresh: () {
                    return context.read<MealplanCubit>().refreshPage();
                  },
                  child: Align(
                    alignment: const Alignment(0, -1 / 3),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: const [
                                  Text(
                                    'Meal Planner',
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Plan daily meals based on your taste and nutrition'
                                ' preferences. Save items from Food Database to '
                                'setup your Kitchen, or add family members in your '
                                'profile to share foods and recipes in your '
                                'Kitchen.',
                                style: TextStyle(fontSize: 14),
                              ),

                              /// Available Items
                              const SizedBox(height: 30),
                              Row(
                                children: const [
                                  Text(
                                    'Step 1: Available items',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ],
                              ),
                              Row(
                                children: const [
                                  Text(
                                    'Add foods and recipes available in your kitchen.',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              MultiSelectBottomSheetField(
                                items: (state.formOne?.allFoods ?? [])
                                    .map(
                                      (e) => MultiSelectItem<
                                          UserIngredientDisplay>(
                                        e,
                                        e.displayName,
                                      ),
                                    )
                                    .toList(),
                                initialValue: state.formOne?.availableFoods,
                                title: const Text('Available Foods'),
                                selectedColor: Theme.of(context).primaryColor,
                                searchable: true,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(40),
                                  ),
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                buttonIcon: Icon(
                                  Icons.kitchen,
                                  color: Theme.of(context).primaryColor,
                                ),
                                buttonText: const Text(
                                  'Search Foods',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                chipDisplay: MultiSelectChipDisplay(
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  onTap: (value) {},
                                ),
                                onConfirm: (items) {
                                  state.formOne?.availableFoods =
                                      List<UserIngredientDisplay>.from(items);
                                },
                              ),
                              const SizedBox(height: 16),
                              MultiSelectBottomSheetField(
                                items: (state.formOne?.allRecipes ?? [])
                                    .map(
                                      (e) => MultiSelectItem<UserRecipeDisplay>(
                                        e,
                                        e.displayName,
                                      ),
                                    )
                                    .toList(),
                                initialValue: state.formOne?.availableRecipes,
                                title: const Text('Available Recipes'),
                                selectedColor: Theme.of(context).primaryColor,
                                searchable: true,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(40),
                                  ),
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                buttonIcon: Icon(
                                  Icons.kitchen,
                                  color: Theme.of(context).primaryColor,
                                ),
                                buttonText: const Text(
                                  'Search Recipes',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                chipDisplay: MultiSelectChipDisplay(
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  onTap: (value) {},
                                ),
                                onConfirm: (items) {
                                  state.formOne?.availableRecipes =
                                      List<UserRecipeDisplay>.from(items);
                                },
                              ),

                              /// Must have items
                              const SizedBox(height: 30),
                              Row(
                                children: const [
                                  Text(
                                    'Step 2: Must haves',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ],
                              ),
                              Row(
                                children: const [
                                  Text(
                                    'Must have foods and recipes.',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              MultiSelectBottomSheetField(
                                items: (state.formOne?.allFoods ?? [])
                                    .map(
                                      (e) => MultiSelectItem<
                                          UserIngredientDisplay>(
                                        e,
                                        e.displayName,
                                      ),
                                    )
                                    .toList(),
                                initialValue: state.formOne?.mustHaveFoods,
                                title: const Text('Must Have Foods'),
                                selectedColor: Theme.of(context).primaryColor,
                                searchable: true,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(40),
                                  ),
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                buttonIcon: Icon(
                                  Icons.kitchen,
                                  color: Theme.of(context).primaryColor,
                                ),
                                buttonText: const Text(
                                  'Search Foods',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                chipDisplay: MultiSelectChipDisplay(
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  onTap: (value) {},
                                ),
                                onConfirm: (items) {
                                  state.formOne?.mustHaveFoods =
                                      List<UserIngredientDisplay>.from(items);
                                },
                              ),
                              const SizedBox(height: 16),
                              MultiSelectBottomSheetField(
                                items: (state.formOne?.allRecipes ?? [])
                                    .map(
                                      (e) => MultiSelectItem<UserRecipeDisplay>(
                                        e,
                                        e.displayName,
                                      ),
                                    )
                                    .toList(),
                                initialValue: state.formOne?.mustHaveRecipes,
                                title: const Text('Add Recipes'),
                                selectedColor: Theme.of(context).primaryColor,
                                searchable: true,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(40),
                                  ),
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                buttonIcon: Icon(
                                  Icons.kitchen,
                                  color: Theme.of(context).primaryColor,
                                ),
                                buttonText: const Text(
                                  'Search Recipes',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                chipDisplay: MultiSelectChipDisplay(
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  onTap: (value) {},
                                ),
                                onConfirm: (items) {
                                  state.formOne?.mustHaveRecipes =
                                      List<UserRecipeDisplay>.from(items);
                                },
                              ),

                              /// Dont have items
                              const SizedBox(height: 30),
                              Row(
                                children: const [
                                  Text(
                                    "Step 3: Don't haves",
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ],
                              ),
                              Row(
                                children: const [
                                  Text(
                                    "Don't use these items for meal planning.",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              MultiSelectBottomSheetField(
                                items: (state.formOne?.allFoods ?? [])
                                    .map(
                                      (e) => MultiSelectItem<
                                          UserIngredientDisplay>(
                                        e,
                                        e.displayName,
                                      ),
                                    )
                                    .toList(),
                                initialValue: state.formOne?.dontHaveFoods,
                                title: const Text("Don't Have Foods"),
                                selectedColor: Theme.of(context).primaryColor,
                                searchable: true,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(40),
                                  ),
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                buttonIcon: Icon(
                                  Icons.kitchen,
                                  color: Theme.of(context).primaryColor,
                                ),
                                buttonText: const Text(
                                  'Search Foods',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                chipDisplay: MultiSelectChipDisplay(
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  onTap: (value) {},
                                ),
                                onConfirm: (items) {
                                  state.formOne?.dontHaveFoods =
                                      List<UserIngredientDisplay>.from(items);
                                },
                              ),
                              const SizedBox(height: 16),
                              MultiSelectBottomSheetField(
                                items: (state.formOne?.allRecipes ?? [])
                                    .map(
                                      (e) => MultiSelectItem<UserRecipeDisplay>(
                                        e,
                                        e.displayName,
                                      ),
                                    )
                                    .toList(),
                                initialValue: state.formOne?.dontHaveRecipes,
                                title: const Text("Don't Have Recipes"),
                                selectedColor: Theme.of(context).primaryColor,
                                searchable: true,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(40),
                                  ),
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                buttonIcon: Icon(
                                  Icons.kitchen,
                                  color: Theme.of(context).primaryColor,
                                ),
                                buttonText: const Text(
                                  'Search Recipes',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                chipDisplay: MultiSelectChipDisplay(
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  onTap: (value) {},
                                ),
                                onConfirm: (items) {
                                  state.formOne?.dontHaveRecipes =
                                      List<UserRecipeDisplay>.from(items);
                                },
                              ),

                              /// Dont repeat items
                              const SizedBox(height: 30),
                              Row(
                                children: const [
                                  Text(
                                    "Step 4: Can't have everyday",
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ],
                              ),
                              Row(
                                children: const [
                                  Text(
                                    "Ignore if logged in yesterday's meals.",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              MultiSelectBottomSheetField(
                                items: (state.formOne?.allFoods ?? [])
                                    .map(
                                      (e) => MultiSelectItem<
                                          UserIngredientDisplay>(
                                        e,
                                        e.displayName,
                                      ),
                                    )
                                    .toList(),
                                initialValue: state.formOne?.dontRepeatFoods,
                                title: const Text('Add Foods'),
                                selectedColor: Theme.of(context).primaryColor,
                                searchable: true,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(40),
                                  ),
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                buttonIcon: Icon(
                                  Icons.kitchen,
                                  color: Theme.of(context).primaryColor,
                                ),
                                buttonText: const Text(
                                  'Search Foods',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                chipDisplay: MultiSelectChipDisplay(
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  onTap: (value) {},
                                ),
                                onConfirm: (items) {
                                  state.formOne?.dontRepeatFoods =
                                      List<UserIngredientDisplay>.from(items);
                                },
                              ),
                              const SizedBox(height: 16),
                              MultiSelectBottomSheetField(
                                items: (state.formOne?.allRecipes ?? [])
                                    .map(
                                      (e) => MultiSelectItem<UserRecipeDisplay>(
                                        e,
                                        e.displayName,
                                      ),
                                    )
                                    .toList(),
                                initialValue: state.formOne?.dontRepeatRecipes,
                                title: const Text('Add Recipes'),
                                selectedColor: Theme.of(context).primaryColor,
                                searchable: true,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(40),
                                  ),
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                buttonIcon: Icon(
                                  Icons.kitchen,
                                  color: Theme.of(context).primaryColor,
                                ),
                                buttonText: const Text(
                                  'Search Recipes',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                chipDisplay: MultiSelectChipDisplay(
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  onTap: (value) {},
                                ),
                                onConfirm: (items) {
                                  state.formOne?.dontRepeatRecipes =
                                      List<UserRecipeDisplay>.from(items);
                                },
                              ),

                              const SizedBox(height: 16),
                              SaveButton(
                                label: 'NEXT',
                                onPressed: () {
                                  context.read<MealplanCubit>().saveItems();
                                  context
                                      .read<MealplanCubit>()
                                      .loadThresholds();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              case MealplanStatus.thresholdsRequestSuccess:
                return RefreshIndicator(
                  backgroundColor: theme.scaffoldBackgroundColor,
                  color: theme.colorScheme.secondary,
                  onRefresh: () {
                    return context.read<MealplanCubit>().refreshPage();
                  },
                  child: Align(
                    alignment: const Alignment(0, -1 / 3),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: const [
                                  Text(
                                    'Meal Planner',
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Plan daily meals based on your taste and nutrition'
                                ' preferences. Save items from Food Database to '
                                'setup your Kitchen, or add family members in your '
                                'profile to share foods and recipes in your '
                                'Kitchen.',
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: const [
                                  Text(
                                    'Step 5: Adjust portions',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ],
                              ),
                              Row(
                                children: const [
                                  Expanded(
                                    child: Text(
                                      'Adjust food portion preferences (in g/ml), '
                                      'used by the planner. If unspecified, a '
                                      'portion size between 10 and 100 (g/ml) is '
                                      'considered for all available foods and '
                                      'recipes by default.',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  for (final externalId in state
                                      .formTwo!.thresholdTypes.keys) ...[
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            state.preferences?[externalId]
                                                    ?.name ??
                                                '',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          child: DropdownInput(
                                            label: '',
                                            choices: constants.thresholdTypes,
                                            initialValue:
                                                state.formTwo?.thresholdTypes[
                                                        externalId] ??
                                                    '',
                                            onChanged: (value) {
                                              state.formTwo?.thresholdTypes[
                                                      externalId] =
                                                  value.toString();
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Flexible(
                                          child: TextInput(
                                            label: 'Portion (g/ml)',
                                            initialValue: state.formTwo
                                                ?.thresholdValues[externalId],
                                            onChanged: (value) {
                                              state.formTwo?.thresholdValues[
                                                      externalId] =
                                                  value.isEmpty
                                                      ? null
                                                      : double.parse(value);
                                            },
                                            isnum: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15)
                                  ]
                                ],
                              ),
                              SaveButton(
                                label: 'NEXT',
                                onPressed: () {
                                  context
                                      .read<MealplanCubit>()
                                      .saveThresholds();
                                  context.read<MealplanCubit>().loadMealplan();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              case MealplanStatus.mealplanRequestSuccess:
              case MealplanStatus.mealplanSaved:
                return RefreshIndicator(
                  backgroundColor: theme.scaffoldBackgroundColor,
                  color: theme.colorScheme.secondary,
                  onRefresh: () {
                    return context.read<MealplanCubit>().refreshPage();
                  },
                  child: Align(
                    alignment: const Alignment(0, -1 / 3),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: const [
                                  Text(
                                    'Meal Planner',
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Plan daily meals based on your taste and nutrition'
                                ' preferences. Save items from Food Database to '
                                'setup your Kitchen, or add family members in your '
                                'profile to share foods and recipes in your '
                                'Kitchen.',
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: const [
                                  Expanded(
                                    child: Text(
                                      'Step 6: Recommended Mealplan',
                                      softWrap: true,
                                      style: TextStyle(fontSize: 24),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: const [
                                  Expanded(
                                    child: Text(
                                      'Adjust portion sizes (in g/ml), select '
                                      'meals and save.',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              if (!(state.mealplanInfeasible ?? true)) ...[
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    for (final externalId in state
                                        .formThree!.quantities.keys) ...[
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              state.mealplanResults?[externalId]
                                                      ?.name ??
                                                  '',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 200,
                                            child: DropdownInput(
                                              label: '',
                                              choices: constants.mealTypes,
                                              onChanged: (value) {
                                                state.formThree?.mealTypes[
                                                        externalId] =
                                                    value.toString();
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Flexible(
                                            child: TextInput(
                                              label: 'Serving (g/ml)',
                                              initialValue: state.formThree
                                                  ?.quantities[externalId],
                                              onChanged: (value) {
                                                state.formThree?.quantities[
                                                        externalId] =
                                                    value.isEmpty
                                                        ? null
                                                        : double.parse(value);
                                              },
                                              isnum: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 15)
                                    ]
                                  ],
                                ),
                                SaveButton(
                                  label: 'DONE',
                                  onPressed: () {
                                    context
                                        .read<MealplanCubit>()
                                        .saveMealplan();
                                  },
                                ),
                              ],
                              if (state.mealplanInfeasible ?? true) ...[
                                const Flexible(
                                  child: Text(
                                    'A mealplan cannot be computed based on '
                                    'available foods, nutrition goals and '
                                    'portion preferences. '
                                    'Try adjusting portion sizes.',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SaveButton(
                                  label: 'BACK',
                                  onPressed: () {
                                    context
                                        .read<MealplanCubit>()
                                        .loadThresholds();
                                  },
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
