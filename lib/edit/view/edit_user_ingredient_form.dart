// ignore_for_file: lines_longer_than_80_chars

import 'package:constants/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famnom_flutter/details/details.dart';
import 'package:famnom_flutter/edit/edit.dart';
import 'package:famnom_flutter/home/home.dart';
import 'package:famnom_flutter/widgets/widgets.dart';

class EditUserIngredientForm extends StatelessWidget {
  const EditUserIngredientForm({Key? key, this.externalId}) : super(key: key);

  final String? externalId;
  static const double sectionSeparatorSize = 24;
  static const double fieldSeparatorSize = 14;

  Widget _header() {
    return Text(
      externalId != null ? 'Edit Food' : 'Add Food',
      style: const TextStyle(fontSize: 30),
    );
  }

  List<Widget> _foodDetails(
    BuildContext context,
    EditUserIngredientState state,
  ) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextInput(
              label: 'GTIN/UPC',
              initialValue: state.form?.gtinUpc,
              onChanged: (value) {
                state.form?.gtinUpc = value;
              },
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.view_week_rounded,
              color: Colors.black,
            ),
            tooltip: 'Search barcode',
            padding: EdgeInsets.zero,
            onPressed: () {
              BlocProvider.of<EditUserIngredientCubit>(
                context,
              ).scanInit();
            },
          )
        ],
      ),
      const SizedBox(height: fieldSeparatorSize),
      TextInput(
        label: 'Name',
        initialValue: state.form?.name,
        onChanged: (value) {
          state.form?.name = value;
        },
      ),
      const SizedBox(height: fieldSeparatorSize),
      TextInput(
        label: 'Brand name',
        initialValue: state.form?.brandName,
        onChanged: (value) {
          state.form?.brandName = value;
        },
      ),
      const SizedBox(height: fieldSeparatorSize),
      TextInput(
        label: 'Subbrand name',
        initialValue: state.form?.subbrandName,
        onChanged: (value) {
          state.form?.subbrandName = value;
        },
      ),
      const SizedBox(height: fieldSeparatorSize),
      TextInput(
        label: 'Brand owner',
        initialValue: state.form?.brandOwner,
        onChanged: (value) {
          state.form?.brandOwner = value;
        },
      ),
      const SizedBox(height: fieldSeparatorSize),
      DropdownInput(
        label: 'Category',
        choices: state.appConstants?.categories ?? [],
        initialValue: state.form?.categoryId,
        onChanged: (value) {
          state.form?.categoryId = value;
        },
      ),
    ];
  }

  List<Widget> _servingDetails(
    BuildContext context,
    EditUserIngredientState state,
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
          context.read<EditUserIngredientCubit>().servingChanged();
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
          context.read<EditUserIngredientCubit>().servingChanged();
        },
      ),
    ];
  }

  List<Widget> _nutritionDetails(EditUserIngredientState state) {
    return [
      const Text(
        'Nutrition details',
        style: TextStyle(fontSize: 24),
      ),
      Text(
        'per ${state.nutritionServing} serving',
        style: const TextStyle(fontSize: 14),
      ),
      const SizedBox(height: sectionSeparatorSize),
      for (var nutrientId in constants.LABEL_NUTRIENT_IDs) ...[
        TextInput(
          label: state.appConstants?.labelNutrients?[nutrientId]?.displayName ??
              '',
          initialValue: state.form?.nutrients?[nutrientId],
          onChanged: (value) {
            state.form?.nutrients?[nutrientId] = value;
          },
          isnum: true,
        ),
        const SizedBox(height: fieldSeparatorSize),
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: BlocBuilder<EditUserIngredientCubit, EditUserIngredientState>(
            builder: (context, state) {
              if (state.status == EditUserIngredientStatus.barcodeRequest) {
                return MyAppBar(
                  showSearchIcon: false,
                  endWidget: IconButton(
                    icon: const Icon(
                      Icons.clear,
                      size: 32,
                    ),
                    onPressed: () {
                      context.read<EditUserIngredientCubit>().scanClose();
                    },
                  ),
                );
              } else {
                return const MyAppBar(showLogo: false);
              }
            },
          ),
        ),
        body: BlocListener<EditUserIngredientCubit, EditUserIngredientState>(
          listener: (context, state) {
            if (state.status == EditUserIngredientStatus.requestFailure ||
                state.status == EditUserIngredientStatus.saveRequestFailure) {
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

            if (state.status == EditUserIngredientStatus.barcodeFound) {
              Navigator.of(context)
                  .push(DetailsDBFoodPage.route(state.redirectExternalId!));
            }

            if (state.status == EditUserIngredientStatus.saveRequestSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: externalId != null
                        ? const Text('Food updated.')
                        : const Text('Food created.'),
                  ),
                );

              Navigator.of(context).push(
                DetailsUserIngredientPage.route(
                  externalId: state.redirectExternalId!,
                ),
              );
            }
          },
          child: BlocBuilder<EditUserIngredientCubit, EditUserIngredientState>(
            builder: (context, state) {
              switch (state.status) {
                case EditUserIngredientStatus.init:
                  context.read<EditUserIngredientCubit>().fetchUserIngredient(
                        externalId: externalId,
                      );
                  return const EmptySpinner();
                case EditUserIngredientStatus.requestSubmitted:
                case EditUserIngredientStatus.requestFailure:
                  return const EmptySpinner();
                case EditUserIngredientStatus.barcodeRequest:
                  return const EditScanner();
                case EditUserIngredientStatus.barcodeFound:
                case EditUserIngredientStatus.barcodeCancelled:
                case EditUserIngredientStatus.barcodeNotFoundOrFailed:
                case EditUserIngredientStatus.requestSuccess:
                case EditUserIngredientStatus.saveRequestSubmitted:
                case EditUserIngredientStatus.saveRequestSuccess:
                case EditUserIngredientStatus.saveRequestFailure:
                  return RefreshIndicator(
                    backgroundColor: theme.scaffoldBackgroundColor,
                    color: theme.colorScheme.secondary,
                    onRefresh: () {
                      return context
                          .read<EditUserIngredientCubit>()
                          .fetchUserIngredient(externalId: externalId);
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

                                // Food details
                                ..._foodDetails(context, state),
                                const SizedBox(height: sectionSeparatorSize),

                                // Servings details
                                ..._servingDetails(context, state),
                                const SizedBox(height: sectionSeparatorSize),

                                // Nutrients
                                ..._nutritionDetails(state),
                                const SizedBox(
                                  height: 2 * sectionSeparatorSize,
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
                                  .read<EditUserIngredientCubit>()
                                  .saveUserIngredient(externalId: externalId);
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
