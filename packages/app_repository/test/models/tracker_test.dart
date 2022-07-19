import 'package:app_repository/app_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:test/test.dart';

void main() {
  group('Tracker', () {
    group('fromJson', () {
      test('returns empty Tracker', () {
        expect(
          Tracker.fromJson(
            const <String, dynamic>{
              'meals': <UserMealDisplay>[],
              'nutrients': <String, dynamic>{
                'values': <String, dynamic>{},
              },
            },
          ),
          isA<Tracker>()
              .having(
                (Tracker s) => s.meals.length,
                'meals',
                equals(0),
              )
              .having(
                (Tracker s) => s.nutrients.values.length,
                'nutrients',
                equals(0),
              ),
        );
      });

      test('returns Tracker with values', () {
        expect(
          Tracker.fromJson(
            const <String, dynamic>{
              'meals': [
                {
                  'external_id': constants.testUUID,
                  'meal_type': constants.testMealType,
                  'meal_date': constants.testMealDate,
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
              ],
              'nutrients': {
                'values': {
                  '${constants.testNutrientId}': {
                    'id': constants.testNutrientId,
                    'name': constants.testNutrientName,
                    'amount': constants.testNutrientAmount,
                    'unit': constants.testNutrientUnit
                  },
                },
              },
            },
          ),
          isA<Tracker>()
              .having(
                (Tracker s) => s.meals.length,
                'meals',
                equals(1),
              )
              .having(
                (Tracker s) => s.nutrients.values.length,
                'nutrients',
                equals(1),
              ),
        );
      });
    });
  });
}
