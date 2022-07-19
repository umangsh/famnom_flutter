import 'package:app_repository/app_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserMealDisplay', () {
    const userMealDisplay = UserMealDisplay(
      externalId: constants.testUUID,
      mealDate: constants.testMealDate,
      mealType: constants.testMealType,
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
      memberIngredients: [
        UserMemberIngredientDisplay(
          externalId: constants.testUUID,
          ingredient: UserIngredientDisplay(
            externalId: constants.testUUID,
            name: constants.testFoodName,
          ),
        )
      ],
      memberRecipes: [
        UserMemberRecipeDisplay(
          externalId: constants.testUUID,
          recipe: UserRecipeDisplay(
            externalId: constants.testUUID,
            name: constants.testFoodName,
          ),
        )
      ],
    );

    test('isEmpty returns true for empty usermealdisplay', () {
      expect(UserMealDisplay.empty.isEmpty, isTrue);
    });

    test('isEmpty returns false for non-empty usermealdisplay', () {
      expect(userMealDisplay.isEmpty, isFalse);
    });

    test('isNotEmpty returns false for empty usermealdisplay', () {
      expect(UserMealDisplay.empty.isNotEmpty, isFalse);
    });

    test('isNotEmpty returns true for non-empty usermealdisplay', () {
      expect(userMealDisplay.isNotEmpty, isTrue);
    });

    group('fromJson', () {
      test('returns userMealDisplay with values', () {
        expect(
          UserMealDisplay.fromJson(
            const <String, dynamic>{
              'external_id': constants.testUUID,
              'meal_type': constants.testMealType,
              'meal_date': constants.testMealDate,
              'display_nutrients': {
                'serving_size': constants.testNutrientServingSize,
                'serving_size_unit': constants.testNutrientServingSizeUnit,
                'values': {
                  '${constants.testNutrientId}': {
                    'id': constants.testNutrientId,
                    'name': constants.testNutrientName,
                    'amount': constants.testNutrientAmount,
                    'unit': constants.testNutrientUnit
                  }
                }
              },
              'member_ingredients': [
                {
                  'external_id': constants.testUUID,
                  'ingredient': {
                    'external_id': constants.testUUID,
                    'name': constants.testFoodName,
                    'brand': {
                      'brand_owner': constants.testBrandOwner,
                      'brand_name': constants.testBrandName,
                    }
                  },
                  'portion': {
                    'external_id': constants.testPortionExternalId,
                    'name': constants.testPortionName,
                    'serving_size': constants.testPortionSize,
                    'serving_size_unit': constants.testPortionSizeUnit
                  }
                }
              ],
              'member_recipes': [
                {
                  'external_id': constants.testUUID,
                  'recipe': {
                    'external_id': constants.testUUID,
                    'name': constants.testRecipeName,
                    'recipe_date': constants.testRecipeDate,
                  },
                  'portion': {
                    'external_id': constants.testPortionExternalId,
                    'name': constants.testPortionName,
                    'serving_size': constants.testPortionSize,
                    'serving_size_unit': constants.testPortionSizeUnit
                  }
                }
              ],
            },
          ),
          isA<UserMealDisplay>()
              .having(
                (UserMealDisplay s) => s.externalId,
                'external id',
                equals(constants.testUUID),
              )
              .having(
                (UserMealDisplay s) => s.mealDate,
                'name',
                equals(constants.testMealDate),
              )
              .having(
                (UserMealDisplay s) => s.mealType,
                'name',
                equals(constants.testMealType),
              )
              .having(
                (UserMealDisplay s) => s.nutrients?.values.length,
                'nutrients length',
                equals(1),
              )
              .having(
                (UserMealDisplay s) => s.memberIngredients?.length,
                'ingredients length',
                equals(1),
              )
              .having(
                (UserMealDisplay s) => s.memberRecipes?.length,
                'recipes length',
                equals(1),
              ),
        );
      });
    });
  });
}
