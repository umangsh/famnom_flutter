import 'package:app_repository/app_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter_test/flutter_test.dart';
import 'package:famnom_flutter/browse/browse.dart';

void main() {
  group('BrowseState', () {
    test('supports value comparisons', () {
      expect(const BrowseState(), const BrowseState());
    });

    test('returns same object when no properties are passed', () {
      expect(const BrowseState().copyWith(), const BrowseState());
    });

    test('returns object with updated status when status is passed', () {
      expect(
        const BrowseState().copyWith(status: BrowseStatus.requestSubmitted),
        const BrowseState(status: BrowseStatus.requestSubmitted),
      );
    });

    test('returns object with updated ingredient results when it is passed',
        () {
      const userIngredient = UserIngredientDisplay(
        externalId: constants.testUUID,
        name: constants.testFoodName,
        portions: [
          Portion(
            externalId: constants.testPortionExternalId,
            name: constants.testPortionName,
            servingSize: constants.testPortionSize,
            servingSizeUnit: constants.testPortionSizeUnit,
          ),
        ],
        nutrients: Nutrients(
          servingSize: constants.testNutrientServingSize,
          servingSizeUnit: constants.testNutrientServingSizeUnit,
          values: {
            constants.testNutrientId: Nutrient(
              id: constants.testNutrientId,
              name: constants.testNutrientName,
              amount: constants.testNutrientAmount,
              unit: constants.testNutrientUnit,
            )
          },
        ),
      );
      expect(
        const BrowseState().copyWith(ingredientResults: [userIngredient]),
        const BrowseState(ingredientResults: [userIngredient]),
      );
    });

    test('returns object with updated recipe results when it is passed', () {
      const userRecipe = UserRecipeDisplay(
        externalId: constants.testUUID,
        name: constants.testRecipeName,
      );
      expect(
        const BrowseState().copyWith(recipeResults: [userRecipe]),
        const BrowseState(recipeResults: [userRecipe]),
      );
    });

    test('returns object with updated meal results when it is passed', () {
      const userMeal = UserMealDisplay(
        externalId: constants.testUUID,
        mealType: constants.testMealType,
        mealDate: constants.testMealDate,
      );
      expect(
        const BrowseState().copyWith(mealResults: [userMeal]),
        const BrowseState(mealResults: [userMeal]),
      );
    });
  });
}
