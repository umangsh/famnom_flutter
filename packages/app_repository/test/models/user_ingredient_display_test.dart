import 'package:app_repository/app_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserIngredientDisplay', () {
    const userIngredientDisplay = UserIngredientDisplay(
      externalId: constants.testUUID,
      name: constants.testFoodName,
      brand: Brand(
        brandOwner: constants.testBrandOwner,
        brandName: constants.testBrandName,
      ),
      portions: [
        Portion(
          externalId: constants.testPortionExternalId,
          name: constants.testPortionName,
          servingSize: constants.testPortionSize,
          servingSizeUnit: constants.testPortionSizeUnit,
        )
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
      category: constants.testCategoryName,
      membership: UserMemberIngredientDisplay(
        externalId: constants.testUUID,
        ingredient: UserIngredientDisplay(
          externalId: constants.testUUID,
          name: constants.testFoodName,
        ),
      ),
    );

    test('isEmpty returns true for empty useringredientdisplay', () {
      expect(UserIngredientDisplay.empty.isEmpty, isTrue);
    });

    test('isEmpty returns false for non-empty useringredientdisplay', () {
      expect(userIngredientDisplay.isEmpty, isFalse);
    });

    test('isNotEmpty returns false for empty useringredientdisplay', () {
      expect(UserIngredientDisplay.empty.isNotEmpty, isFalse);
    });

    test('isNotEmpty returns true for non-empty useringredientdisplay', () {
      expect(userIngredientDisplay.isNotEmpty, isTrue);
    });

    test('get defaultPortion', () {
      expect(
        userIngredientDisplay.defaultPortion,
        equals(
          const Portion(
            externalId: constants.testPortionExternalId,
            name: constants.testPortionName,
            servingSize: constants.testPortionSize,
            servingSizeUnit: constants.testPortionSizeUnit,
          ),
        ),
      );
    });

    group('fromJson', () {
      test('returns UserIngredientDisplay with values', () {
        expect(
          UserIngredientDisplay.fromJson(
            const <String, dynamic>{
              'external_id': constants.testUUID,
              'name': constants.testFoodName,
              'brand': {
                'brand_owner': constants.testBrandOwner,
                'brand_name': constants.testBrandName,
              },
              'portions': [
                {
                  'external_id': constants.testPortionExternalId,
                  'name': constants.testPortionName,
                  'serving_size': constants.testPortionSize,
                  'serving_size_unit': constants.testPortionSizeUnit
                }
              ],
              'nutrients': {
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
              'category': constants.testCategoryName,
              'membership': {
                'external_id': constants.testUUID,
                'ingredient': {
                  'external_id': constants.testUUID,
                  'name': constants.testFoodName,
                },
                'portion': {
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
                'category',
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
