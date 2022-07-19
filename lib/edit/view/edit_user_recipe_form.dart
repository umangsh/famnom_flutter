import 'package:app_repository/app_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:famnom_flutter/details/details.dart';
import 'package:famnom_flutter/edit/edit.dart';
import 'package:famnom_flutter/home/home.dart';
import 'package:famnom_flutter/widgets/widgets.dart';

class EditUserRecipeForm extends StatelessWidget {
  const EditUserRecipeForm({Key? key, this.externalId}) : super(key: key);

  final String? externalId;
  static const double sectionSeparatorSize = 24;
  static const double fieldSeparatorSize = 14;

  Widget _header() {
    return Text(
      externalId != null ? 'Edit Recipe' : 'Add Recipe',
      style: const TextStyle(fontSize: 30),
    );
  }

  List<Widget> _recipeDetails(
    BuildContext context,
    EditUserRecipeState state,
  ) {
    return [
      TextInput(
        label: 'Name',
        initialValue: state.form?.name,
        onChanged: (value) {
          state.form?.name = value;
        },
      ),
      const SizedBox(height: fieldSeparatorSize),
      DateInput(
        label: 'Recipe date',
        initialValue: state.form?.recipeDate,
        onChanged: (date) {
          state.form?.recipeDate =
              DateFormat(constants.DATE_FORMAT).format(date);
        },
      ),
    ];
  }

  List<Widget> _ingredientMemberDetails(
    BuildContext context,
    EditUserRecipeState state,
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
                    .read<EditUserRecipeCubit>()
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
                return context.read<EditUserRecipeCubit>().getFoodPortions(
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
                await context.read<EditUserRecipeCubit>().redrawPage();
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
    EditUserRecipeState state,
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
                    .read<EditUserRecipeCubit>()
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
                return context.read<EditUserRecipeCubit>().getRecipePortions(
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
                await context.read<EditUserRecipeCubit>().redrawPage();
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
    EditUserRecipeState state,
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
          await context.read<EditUserRecipeCubit>().redrawPage();
        },
        child: const Text('Add Food'),
      ),
    ];
  }

  List<Widget> _recipeMembersDetails(
    BuildContext context,
    EditUserRecipeState state,
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
          await context.read<EditUserRecipeCubit>().redrawPage();
        },
        child: const Text('Add Recipe'),
      ),
    ];
  }

  List<Widget> _servingDetails(
    BuildContext context,
    EditUserRecipeState state,
  ) {
    return [
      const Text(
        'Servings',
        style: TextStyle(fontSize: 24),
      ),
      const SizedBox(height: fieldSeparatorSize),
      TextInput(
        label: 'Servings per container',
        initialValue: state.form?.portions?.at(0)?.servingsPerContainer,
        onChanged: (value) {
          if (state.form?.portions?.at(0) != null) {
            state.form?.portions?.at(0)?.servingsPerContainer = value;
          } else {
            state.form?.portions?.add(
              FoodPortionForm(servingsPerContainer: value),
            );
          }
        },
        isnum: true,
      ),
      const SizedBox(height: fieldSeparatorSize),
      DropdownInput(
        label: 'Household quantity',
        choices: state.appConstants?.householdQuantities ?? [],
        initialValue: state.form?.portions?.at(0)?.householdQuantity,
        onChanged: (value) {
          if (state.form?.portions?.at(0) != null) {
            state.form?.portions?.at(0)?.householdQuantity = value;
          } else {
            state.form?.portions
                ?.add(FoodPortionForm(householdQuantity: value));
          }
        },
      ),
      const SizedBox(height: fieldSeparatorSize),
      DropdownInput(
        label: 'Household unit',
        choices: state.appConstants?.householdUnits ?? [],
        initialValue: state.form?.portions?.at(0)?.householdUnit,
        onChanged: (value) {
          if (state.form?.portions?.at(0) != null) {
            state.form?.portions?.at(0)?.householdUnit = value;
          } else {
            state.form?.portions?.add(FoodPortionForm(householdUnit: value));
          }
        },
      ),
      const SizedBox(height: fieldSeparatorSize),
      TextInput(
        label: 'Serving size',
        initialValue: state.form?.portions?.at(0)?.servingSize,
        onChanged: (value) {
          if (state.form?.portions?.at(0) != null) {
            state.form?.portions?.at(0)?.servingSize = value;
          } else {
            state.form?.portions?.add(FoodPortionForm(servingSize: value));
          }
        },
        isnum: true,
      ),
      const SizedBox(height: fieldSeparatorSize),
      DropdownInput(
        label: 'Serving unit',
        choices: state.appConstants?.servingSizeUnits ?? [],
        initialValue: state.form?.portions?.at(0)?.servingSizeUnit,
        onChanged: (value) {
          if (state.form?.portions?.at(0) != null) {
            state.form?.portions?.at(0)?.servingSizeUnit = value;
          } else {
            state.form?.portions?.add(FoodPortionForm(servingSizeUnit: value));
          }
        },
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
        body: BlocListener<EditUserRecipeCubit, EditUserRecipeState>(
          listener: (context, state) {
            if (state.status == EditUserRecipeStatus.requestFailure ||
                state.status == EditUserRecipeStatus.saveRequestFailure) {
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

            if (state.status == EditUserRecipeStatus.saveRequestSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: externalId != null
                        ? const Text('Recipe updated.')
                        : const Text('Recipe created.'),
                  ),
                );

              Navigator.of(context).push(
                DetailsUserRecipePage.route(
                  externalId: state.redirectExternalId!,
                ),
              );
            }
          },
          child: BlocBuilder<EditUserRecipeCubit, EditUserRecipeState>(
            builder: (context, state) {
              switch (state.status) {
                case EditUserRecipeStatus.init:
                  context.read<EditUserRecipeCubit>().fetchUserRecipe(
                        externalId: externalId,
                      );
                  return const EmptySpinner();
                case EditUserRecipeStatus.requestSubmitted:
                case EditUserRecipeStatus.requestFailure:
                  return const EmptySpinner();
                case EditUserRecipeStatus.redrawRequested:
                case EditUserRecipeStatus.redrawDone:
                case EditUserRecipeStatus.requestSuccess:
                case EditUserRecipeStatus.saveRequestSubmitted:
                case EditUserRecipeStatus.saveRequestSuccess:
                case EditUserRecipeStatus.saveRequestFailure:
                  return RefreshIndicator(
                    backgroundColor: theme.scaffoldBackgroundColor,
                    color: theme.colorScheme.secondary,
                    onRefresh: () {
                      return context
                          .read<EditUserRecipeCubit>()
                          .fetchUserRecipe(externalId: externalId);
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

                                /// Recipe details.
                                ..._recipeDetails(context, state),
                                const SizedBox(height: sectionSeparatorSize),

                                // Food members
                                ..._ingredientMembersDetails(context, state),
                                const SizedBox(height: sectionSeparatorSize),

                                // Recipe members
                                ..._recipeMembersDetails(context, state),
                                const SizedBox(height: sectionSeparatorSize),

                                // Servings details
                                ..._servingDetails(context, state),
                                const SizedBox(height: 3 * sectionSeparatorSize)
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          child: SaveButton(
                            onPressed: () {
                              context
                                  .read<EditUserRecipeCubit>()
                                  .saveUserRecipe(externalId: externalId);
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
