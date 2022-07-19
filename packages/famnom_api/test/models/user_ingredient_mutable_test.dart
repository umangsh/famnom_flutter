import 'package:constants/constants.dart' as constants;
import 'package:famnom_api/famnom_api.dart';
import 'package:test/test.dart';

void main() {
  group('UserIngredientMutable', () {
    group('fromJson', () {
      test('returns UserIngredientMutable with values', () {
        expect(
          UserIngredientMutable.fromJson(
            const <String, dynamic>{
              'external_id': constants.testUUID,
              'name': constants.testFoodName,
              'brand': {
                'brand_owner': constants.testBrandOwner,
                'brand_name': constants.testBrandName,
              },
              'portions': [
                {
                  'id': constants.testPortionId,
                  'external_id': constants.testPortionExternalId,
                  'servings_per_container':
                      constants.testPortionServingsPerContainer,
                  'household_quantity': constants.testPortionHouseholdQuantity,
                  'household_unit': constants.testPortionHouseholdUnit,
                  'serving_size': constants.testPortionSize,
                  'serving_size_unit': constants.testPortionSizeUnit,
                }
              ],
              'nutrients': {
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
              'category': constants.testCategoryName,
            },
          ),
          isA<UserIngredientMutable>()
              .having(
                (UserIngredientMutable s) => s.externalId,
                'external id',
                equals(constants.testUUID),
              )
              .having(
                (UserIngredientMutable s) => s.name,
                'name',
                equals(constants.testFoodName),
              )
              .having(
                (UserIngredientMutable s) => s.brand!.brandOwner,
                'brand owner',
                equals(constants.testBrandOwner),
              )
              .having(
                (UserIngredientMutable s) => s.brand!.brandName,
                'brand name',
                equals(constants.testBrandName),
              )
              .having(
                (UserIngredientMutable s) => s.portions?.length,
                'portions length',
                equals(1),
              )
              .having(
                (UserIngredientMutable s) => s.nutrients.values.length,
                'nutrients length',
                equals(1),
              )
              .having(
                (UserIngredientMutable s) => s.category,
                'food category',
                equals(constants.testCategoryName),
              ),
        );
      });
    });
  });
}
