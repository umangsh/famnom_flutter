import 'package:app_repository/app_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter_test/flutter_test.dart';
import 'package:famnom_flutter/details/details.dart';

void main() {
  group('DetailsState', () {
    test('supports value comparisons', () {
      expect(const DetailsState(), const DetailsState());
    });

    test('returns same object when no properties are passed', () {
      expect(const DetailsState().copyWith(), const DetailsState());
    });

    test('returns object with updated status when status is passed', () {
      expect(
        const DetailsState().copyWith(status: DetailsStatus.requestSubmitted),
        const DetailsState(status: DetailsStatus.requestSubmitted),
      );
    });

    test('returns object with updated dbfood when it is passed', () {
      const dbFood = DBFood(
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
        const DetailsState().copyWith(dbFood: dbFood),
        const DetailsState(dbFood: dbFood),
      );
    });

    test('returns object with updated ingredient when it is passed', () {
      const userIngredient = UserIngredientDisplay(
        externalId: constants.testUUID,
        name: constants.testFoodName,
      );
      expect(
        const DetailsState().copyWith(userIngredient: userIngredient),
        const DetailsState(userIngredient: userIngredient),
      );
    });

    test('returns object with updated recipe when it is passed', () {
      const userRecipe = UserRecipeDisplay(
        externalId: constants.testUUID,
        name: constants.testRecipeName,
      );
      expect(
        const DetailsState().copyWith(userRecipe: userRecipe),
        const DetailsState(userRecipe: userRecipe),
      );
    });

    test('returns object with updated meal when it is passed', () {
      const userMeal = UserMealDisplay(
        externalId: constants.testUUID,
        mealType: constants.testMealType,
        mealDate: constants.testMealDate,
      );
      expect(
        const DetailsState().copyWith(userMeal: userMeal),
        const DetailsState(userMeal: userMeal),
      );
    });

    test('returns object with updated selectedPortion when it is passed', () {
      const portion = Portion(
        externalId: constants.testUUID,
        name: constants.testPortionName,
        servingSize: constants.testPortionSize,
        servingSizeUnit: constants.testPortionSizeUnit,
      );
      expect(
        const DetailsState().copyWith(selectedPortion: portion),
        const DetailsState(selectedPortion: portion),
      );
    });

    test('returns object with updated quantity when it is passed', () {
      expect(
        const DetailsState().copyWith(quantity: 2),
        const DetailsState(quantity: 2),
      );
    });

    test('returns object with updated fdaRDIs when it is passed', () {
      const rdis = <FDAGroup, Map<int, FdaRdi>>{};
      expect(
        const DetailsState().copyWith(fdaRDIs: rdis),
        const DetailsState(fdaRDIs: rdis),
      );
    });
  });
}
