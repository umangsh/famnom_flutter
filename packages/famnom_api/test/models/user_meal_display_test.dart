import 'package:constants/constants.dart' as constants;
import 'package:famnom_api/famnom_api.dart';
import 'package:test/test.dart';

void main() {
  group('UserMealDisplay', () {
    group('fromJson', () {
      test('returns UserMealDisplay with values', () {
        expect(
          UserMealDisplay.fromJson(
            const <String, dynamic>{
              'external_id': constants.testUUID,
              'meal_type': constants.testMealType,
              'meal_date': constants.testMealDate,
              'display_nutrients': {
                'serving_size': constants.testNutrientServingSize,
                'serving_size_unit': constants.testNutrientServingSizeUnit,
                'values': [
                  {
                    'id': constants.testNutrientId,
                    'name': constants.testNutrientName,
                    'amount': constants.testNutrientAmount,
                    'unit': constants.testNutrientUnit
                  }
                ]
              },
              'member_ingredients': [
                {
                  'external_id': constants.testUUID,
                  'display_ingredient': {
                    'external_id': constants.testUUID,
                    'display_name': constants.testFoodName,
                    'display_brand': {
                      'brand_owner': constants.testBrandOwner,
                      'brand_name': constants.testBrandName,
                    }
                  },
                  'display_portion': {
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
                  'display_recipe': {
                    'external_id': constants.testUUID,
                    'name': constants.testRecipeName,
                    'recipe_date': constants.testRecipeDate,
                  },
                  'display_portion': {
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
                (UserMealDisplay s) => s.mealType,
                'meal type',
                equals(constants.testMealType),
              )
              .having(
                (UserMealDisplay s) => s.mealDate,
                'meal date',
                equals(constants.testMealDate),
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
                'member recipes length',
                equals(1),
              ),
        );
      });
    });
  });
}
