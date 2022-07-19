import 'package:constants/constants.dart' as constants;
import 'package:famnom_api/famnom_api.dart';
import 'package:test/test.dart';

void main() {
  group('TrackerResponse', () {
    group('fromJson', () {
      test('returns empty TrackerResponse', () {
        expect(
          TrackerResponse.fromJson(
            const <String, dynamic>{
              'display_meals': <UserMealDisplay>[],
              'display_nutrients': <String, dynamic>{
                'values': <Nutrient>[],
              },
            },
          ),
          isA<TrackerResponse>()
              .having(
                (TrackerResponse s) => s.meals.length,
                'meals',
                equals(0),
              )
              .having(
                (TrackerResponse s) => s.nutrients.values.length,
                'nutrients',
                equals(0),
              ),
        );
      });

      test('returns TrackerResponse with values', () {
        expect(
          TrackerResponse.fromJson(
            const <String, dynamic>{
              'display_meals': [
                {
                  'external_id': constants.testUUID,
                  'meal_type': constants.testMealType,
                  'meal_date': constants.testMealDate,
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
              ],
              'display_nutrients': {
                'values': [
                  {
                    'id': constants.testNutrientId,
                    'name': constants.testNutrientName,
                    'amount': constants.testNutrientAmount,
                    'unit': constants.testNutrientUnit
                  },
                ],
              },
            },
          ),
          isA<TrackerResponse>()
              .having(
                (TrackerResponse s) => s.meals.length,
                'meals',
                equals(1),
              )
              .having(
                (TrackerResponse s) => s.nutrients.values.length,
                'nutrients',
                equals(1),
              ),
        );
      });
    });
  });
}
