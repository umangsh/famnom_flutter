import 'package:constants/constants.dart' as constants;
import 'package:famnom_api/famnom_api.dart';
import 'package:test/test.dart';

void main() {
  group('UserRecipeDisplay', () {
    group('fromJson', () {
      test('returns UserRecipeDisplay with values', () {
        expect(
          UserRecipeDisplay.fromJson(
            const <String, dynamic>{
              'external_id': constants.testUUID,
              'name': constants.testRecipeName,
              'recipe_date': constants.testRecipeDate,
              'display_portions': [
                {
                  'external_id': constants.testPortionExternalId,
                  'name': constants.testPortionName,
                  'serving_size': constants.testPortionSize,
                  'serving_size_unit': constants.testPortionSizeUnit
                }
              ],
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
              'display_membership': {
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
            },
          ),
          isA<UserRecipeDisplay>()
              .having(
                (UserRecipeDisplay s) => s.externalId,
                'external id',
                equals(constants.testUUID),
              )
              .having(
                (UserRecipeDisplay s) => s.name,
                'name',
                equals(constants.testRecipeName),
              )
              .having(
                (UserRecipeDisplay s) => s.recipeDate,
                'recipe date',
                equals(constants.testRecipeDate),
              )
              .having(
                (UserRecipeDisplay s) => s.portions?.length,
                'portions length',
                equals(1),
              )
              .having(
                (UserRecipeDisplay s) => s.nutrients?.values.length,
                'nutrients length',
                equals(1),
              )
              .having(
                (UserRecipeDisplay s) => s.memberIngredients?.length,
                'ingredients length',
                equals(1),
              )
              .having(
                (UserRecipeDisplay s) => s.memberRecipes?.length,
                'member recipes length',
                equals(1),
              )
              .having(
                (UserRecipeDisplay s) => s.membership!.externalId,
                'membership',
                equals(constants.testUUID),
              ),
        );
      });
    });
  });
}
