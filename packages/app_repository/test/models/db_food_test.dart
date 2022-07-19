import 'package:app_repository/app_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DBFood', () {
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
          )
        },
      ),
    );

    test('isEmpty returns true for empty dbfood', () {
      expect(DBFood.empty.isEmpty, isTrue);
    });

    test('isEmpty returns false for non-empty dbfood', () {
      expect(dbFood.isEmpty, isFalse);
    });

    test('isNotEmpty returns false for empty dbfood', () {
      expect(DBFood.empty.isNotEmpty, isFalse);
    });

    test('isNotEmpty returns true for non-empty dbfood', () {
      expect(dbFood.isNotEmpty, isTrue);
    });

    test('get defaultPortion', () {
      expect(
        dbFood.defaultPortion,
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
      test('returns DBFood with values', () {
        expect(
          DBFood.fromJson(
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
              'lfood_external_id': constants.testUUID,
            },
          ),
          isA<DBFood>()
              .having(
                (DBFood s) => s.externalId,
                'external id',
                equals(constants.testUUID),
              )
              .having(
                (DBFood s) => s.name,
                'name',
                equals(constants.testFoodName),
              )
              .having(
                (DBFood s) => s.brand!.brandOwner,
                'brand owner',
                equals(constants.testBrandOwner),
              )
              .having(
                (DBFood s) => s.brand!.brandName,
                'brand name',
                equals(constants.testBrandName),
              )
              .having(
                (DBFood s) => s.portions!.length,
                'portions length',
                equals(1),
              )
              .having(
                (DBFood s) => s.nutrients!.values.length,
                'nutrients length',
                equals(1),
              )
              .having(
                (DBFood s) => s.lfoodExternalId,
                'lfood external id',
                equals(constants.testUUID),
              ),
        );
      });
    });
  });
}
