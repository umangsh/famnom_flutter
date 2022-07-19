import 'package:constants/constants.dart' as constants;
import 'package:famnom_api/famnom_api.dart';
import 'package:test/test.dart';

void main() {
  group('UserIngredientDisplay', () {
    group('fromJson', () {
      test('returns UserIngredientDisplay with values', () {
        expect(
          UserIngredientDisplay.fromJson(
            const <String, dynamic>{
              'external_id': constants.testUUID,
              'display_name': constants.testFoodName,
              'display_brand': {
                'brand_owner': constants.testBrandOwner,
                'brand_name': constants.testBrandName,
              },
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
              'display_category': constants.testCategoryName,
              'display_membership': {
                'external_id': constants.testUUID,
                'display_ingredient': {
                  'external_id': constants.testUUID,
                  'display_name': constants.testFoodName,
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
          isA<UserIngredientDisplay>()
              .having(
                (UserIngredientDisplay s) => s.externalId,
                'external id',
                equals(constants.testUUID),
              )
              .having(
                (UserIngredientDisplay s) => s.name,
                'name',
                equals(constants.testFoodName),
              )
              .having(
                (UserIngredientDisplay s) => s.brand!.brandOwner,
                'brand owner',
                equals(constants.testBrandOwner),
              )
              .having(
                (UserIngredientDisplay s) => s.brand!.brandName,
                'brand name',
                equals(constants.testBrandName),
              )
              .having(
                (UserIngredientDisplay s) => s.portions?.length,
                'portions length',
                equals(1),
              )
              .having(
                (UserIngredientDisplay s) => s.nutrients?.values.length,
                'nutrients length',
                equals(1),
              )
              .having(
                (UserIngredientDisplay s) => s.category,
                'food category',
                equals(constants.testCategoryName),
              )
              .having(
                (UserIngredientDisplay s) => s.membership!.externalId,
                'membership',
                equals(constants.testUUID),
              ),
        );
      });
    });
  });
}
