import 'package:app_repository/app_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter_test/flutter_test.dart';
import 'package:famnom_flutter/edit/edit.dart';

void main() {
  group('EditUserIngredientState', () {
    test('supports value comparisons', () {
      expect(const EditUserIngredientState(), const EditUserIngredientState());
    });

    test('returns same object when no properties are passed', () {
      expect(
        const EditUserIngredientState().copyWith(),
        const EditUserIngredientState(),
      );
    });

    test('returns object with updated status when status is passed', () {
      expect(
        const EditUserIngredientState()
            .copyWith(status: EditUserIngredientStatus.requestSubmitted),
        const EditUserIngredientState(
          status: EditUserIngredientStatus.requestSubmitted,
        ),
      );
    });

    test('returns object with updated user ingredient when it is passed', () {
      const userIngredient = UserIngredientMutable(
        externalId: constants.testUUID,
        name: constants.testFoodName,
        portions: [
          UserFoodPortion(
            id: constants.testPortionId,
            externalId: constants.testPortionExternalId,
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
        const EditUserIngredientState()
            .copyWith(userIngredient: userIngredient),
        const EditUserIngredientState(userIngredient: userIngredient),
      );
    });

    test('returns object with updated app constants when it is passed', () {
      expect(
        const EditUserIngredientState()
            .copyWith(appConstants: const AppConstants()),
        const EditUserIngredientState(appConstants: AppConstants()),
      );
    });

    test('returns object with updated form when it is passed', () {
      expect(
        const EditUserIngredientState().copyWith(form: FoodForm()),
        EditUserIngredientState(form: FoodForm()),
      );
    });

    test('returns object with updated redirect external ID when it is passed',
        () {
      expect(
        const EditUserIngredientState()
            .copyWith(redirectExternalId: constants.testUUID),
        const EditUserIngredientState(redirectExternalId: constants.testUUID),
      );
    });

    test('returns object with updated nutrition serving when it is passed', () {
      expect(
        const EditUserIngredientState().copyWith(nutritionServing: 'ABC'),
        const EditUserIngredientState(nutritionServing: 'ABC'),
      );
    });
  });
}
