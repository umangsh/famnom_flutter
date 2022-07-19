import 'package:constants/constants.dart' as constants;
import 'package:famnom_api/famnom_api.dart';
import 'package:test/test.dart';

void main() {
  group('DBFood', () {
    group('fromJson', () {
      test('returns DBFood with values', () {
        expect(
          DBFood.fromJson(
            const <String, dynamic>{
              'external_id': constants.testUUID,
              'description': constants.testFoodName,
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
                'values': [
                  {
                    'id': constants.testNutrientId,
                    'name': constants.testNutrientName,
                    'amount': constants.testNutrientAmount,
                    'unit': constants.testNutrientUnit
                  }
                ]
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
                (DBFood s) => s.description,
                'description',
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
