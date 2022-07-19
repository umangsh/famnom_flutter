import 'package:app_repository/app_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:famnom_flutter/details/details.dart';
import 'package:famnom_flutter/edit/edit.dart';
import 'package:famnom_flutter/home/home.dart';
import 'package:famnom_flutter/widgets/widgets.dart';

class EditUserMealForm extends StatelessWidget {
  const EditUserMealForm({Key? key, this.externalId}) : super(key: key);

  final String? externalId;
  static const double sectionSeparatorSize = 24;
  static const double fieldSeparatorSize = 14;

  Widget _header() {
    return Text(
      externalId != null ? 'Edit Meal' : 'Add Meal',
      style: const TextStyle(fontSize: 30),
    );
  }

  List<Widget> _mealDetails(BuildContext context, EditUserMealState state) {
    return [
      DropdownInput(
        label: 'Meal Type',
        choices: constants.mealTypes,
        initialValue: state.form?.mealType,
        onChanged: (value) {
          state.form?.mealType = value;
        },
      ),
      const SizedBox(height: fieldSeparatorSize),
      DateInput(
        label: 'Meal date',
        initialValue: state.form?.mealDate,
        onChanged: (date) {
          state.form?.mealDate = DateFormat(constants.DATE_FORMAT).format(date);
        },
      ),
    ];
  }

  List<Widget> _ingredientMemberDetails(
    BuildContext context,
    EditUserMealState state,
    FoodMemberForm form,
    int index,
  ) {
    final theme = Theme.of(context);
    return [
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.secondary),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(fieldSeparatorSize),
        child: Column(
          children: [
            /// Member name
            DropdownSearchInput<UserIngredientDisplay>(
              label: 'Food',
              asyncItems: (value) {
                return context
                    .read<EditUserMealCubit>()
                    .getMyFoods(query: value);
              },
              compareFn: (i, s) => i.isEqual(s),
              showSearchBox: true,
              showSelectedItems: true,
              isFilterOnline: true,
              selectedItem: form.childExternalId == null
                  ? null
                  : UserIngredientDisplay(
                      externalId: form.childExternalId!,
                      name: form.childName!,
                    ),
              onChanged: (value) {
                form
                  ..childExternalId = value?.externalId
                  ..childName = value?.name;
              },
              emptyText: 'Select food',
            ),
            const SizedBox(height: fieldSeparatorSize),

            /// Member portion
            DropdownSearchInput<Portion>(
              label: 'Serving',
              asyncItems: (value) {
                if (form.childExternalId == null) {
                  return Future.value(<Portion>[]);
                }
                return context.read<EditUserMealCubit>().getFoodPortions(
                      externalId: form.childExternalId!,
                    );
              },
              compareFn: (i, s) => i.isEqual(s),
              showSelectedItems: true,
              selectedItem: form.serving == null
                  ? null
                  : Portion(
                      externalId: form.serving!,
                      name: form.servingName!,
                      servingSize: 0,
                      servingSizeUnit: '',
                    ),
              onChanged: (value) {
                form
                  ..serving = value?.externalId
                  ..servingName = value?.name;
              },
              emptyText: 'Select food',
            ),
            const SizedBox(height: fieldSeparatorSize),

            /// Member portion quantity
            TextInput(
              label: 'Quantity',
              initialValue: form.quantity,
              isnum: true,
              onChanged: (value) {
                form.quantity = value;
              },
            ),
            const SizedBox(height: fieldSeparatorSize),

            /// Delete icon
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                primary: theme.primaryColor,
              ),
              onPressed: () async {
                state.form?.deleteFoodMember(index);
                await context.read<EditUserMealCubit>().redrawPage();
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
      const SizedBox(height: sectionSeparatorSize),
    ];
  }

  List<Widget> _recipeMemberDetails(
    BuildContext context,
    EditUserMealState state,
    FoodMemberForm form,
    int index,
  ) {
    final theme = Theme.of(context);
    return [
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.secondary),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(fieldSeparatorSize),
        child: Column(
          children: [
            /// Member name
            DropdownSearchInput<UserRecipeDisplay>(
              label: 'Recipe',
              asyncItems: (value) {
                return context
                    .read<EditUserMealCubit>()
                    .getMyRecipes(query: value);
              },
              compareFn: (i, s) => i.isEqual(s),
              showSearchBox: true,
              showSelectedItems: true,
              isFilterOnline: true,
              selectedItem: form.childExternalId == null
                  ? null
                  : UserRecipeDisplay(
                      externalId: form.childExternalId!,
                      name: form.childName!,
                    ),
              onChanged: (value) {
                form
                  ..childExternalId = value?.externalId
                  ..childName = value?.name;
              },
              emptyText: 'Select recipe',
            ),
            const SizedBox(height: fieldSeparatorSize),

            /// Member portion
            DropdownSearchInput<Portion>(
              label: 'Serving',
              asyncItems: (value) {
                if (form.childExternalId == null) {
                  return Future.value(<Portion>[]);
                }
                return context.read<EditUserMealCubit>().getRecipePortions(
                      externalId: form.childExternalId!,
                    );
              },
              compareFn: (i, s) => i.isEqual(s),
              showSelectedItems: true,
              selectedItem: form.serving == null
                  ? null
                  : Portion(
                      externalId: form.serving!,
                      name: form.servingName!,
                      servingSize: 0,
                      servingSizeUnit: '',
                    ),
              onChanged: (value) {
                form
                  ..serving = value?.externalId
                  ..servingName = value?.name;
              },
              emptyText: 'Select recipe',
            ),
            const SizedBox(height: fieldSeparatorSize),

            /// Member portion quantity
            TextInput(
              label: 'Quantity',
              initialValue: form.quantity,
              isnum: true,
              onChanged: (value) {
                form.quantity = value;
              },
            ),
            const SizedBox(height: fieldSeparatorSize),

            /// Delete icon
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                primary: theme.primaryColor,
              ),
              onPressed: () async {
                state.form?.deleteRecipeMember(index);
                await context.read<EditUserMealCubit>().redrawPage();
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
      const SizedBox(height: sectionSeparatorSize),
    ];
  }

  List<Widget> _ingredientMembersDetails(
    BuildContext context,
    EditUserMealState state,
  ) {
    final theme = Theme.of(context);
    return [
      const Text(
        'Foods',
        style: TextStyle(fontSize: 24),
      ),
      const SizedBox(height: fieldSeparatorSize),
      for (var entry in (state.form?.ingredientMembers ?? <FoodMemberForm>[])
          .asMap()
          .entries)
        if (!(entry.value.isDeleted ?? false))
          ..._ingredientMemberDetails(context, state, entry.value, entry.key),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          primary: theme.primaryColor,
        ),
        onPressed: () async {
          state.form?.addFoodMember();
          await context.read<EditUserMealCubit>().redrawPage();
        },
        child: const Text('Add Food'),
      ),
    ];
  }

  List<Widget> _recipeMembersDetails(
    BuildContext context,
    EditUserMealState state,
  ) {
    final theme = Theme.of(context);
    return [
      const Text(
        'Recipes',
        style: TextStyle(fontSize: 24),
      ),
      const SizedBox(height: fieldSeparatorSize),
      for (var entry
          in (state.form?.recipeMembers ?? <FoodMemberForm>[]).asMap().entries)
        if (!(entry.value.isDeleted ?? false))
          ..._recipeMemberDetails(context, state, entry.value, entry.key),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          primary: theme.primaryColor,
        ),
        onPressed: () async {
          state.form?.addRecipeMember();
          await context.read<EditUserMealCubit>().redrawPage();
        },
        child: const Text('Add Recipe'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: const MyAppBar(showLogo: false),
        body: BlocListener<EditUserMealCubit, EditUserMealState>(
          listener: (context, state) {
            if (state.status == EditUserMealStatus.requestFailure ||
                state.status == EditUserMealStatus.saveRequestFailure) {
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

            if (state.status == EditUserMealStatus.saveRequestSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: externalId != null
                        ? const Text('Meal updated.')
                        : const Text('Meal created.'),
                  ),
                );

              Navigator.of(context).push(
                DetailsUserMealPage.route(state.redirectExternalId!),
              );
            }
          },
          child: BlocBuilder<EditUserMealCubit, EditUserMealState>(
            builder: (context, state) {
              switch (state.status) {
                case EditUserMealStatus.init:
                  context.read<EditUserMealCubit>().fetchUserMeal(
                        externalId: externalId,
                      );
                  return const EmptySpinner();
                case EditUserMealStatus.requestSubmitted:
                case EditUserMealStatus.requestFailure:
                  return const EmptySpinner();
                case EditUserMealStatus.redrawRequested:
                case EditUserMealStatus.redrawDone:
                case EditUserMealStatus.requestSuccess:
                case EditUserMealStatus.saveRequestSubmitted:
                case EditUserMealStatus.saveRequestSuccess:
                case EditUserMealStatus.saveRequestFailure:
                  return RefreshIndicator(
                    backgroundColor: theme.scaffoldBackgroundColor,
                    color: theme.colorScheme.secondary,
                    onRefresh: () {
                      return context
                          .read<EditUserMealCubit>()
                          .fetchUserMeal(externalId: externalId);
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: const Alignment(0, -1 / 3),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                            child: ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                // Page heading
                                _header(),
                                const SizedBox(height: sectionSeparatorSize),

                                /// Meal details.
                                ..._mealDetails(context, state),
                                const SizedBox(height: sectionSeparatorSize),

                                // Food members
                                ..._ingredientMembersDetails(context, state),
                                const SizedBox(height: sectionSeparatorSize),

                                // Recipe members
                                ..._recipeMembersDetails(context, state),
                                const SizedBox(
                                  height: 3 * sectionSeparatorSize,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          child: SaveButton(
                            onPressed: () {
                              context
                                  .read<EditUserMealCubit>()
                                  .saveUserMeal(externalId: externalId);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
              }
            },
          ),
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
