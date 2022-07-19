import 'package:constants/constants.dart' as constants;
import 'package:famnom_api/famnom_api.dart';
import 'package:test/test.dart';

void main() {
  group('DBBrandedFood', () {
    group('fromJson', () {
      test('returns DBBrandedFood', () {
        expect(
          DBBrandedFood.fromJson(
            const <String, dynamic>{
              'brand_owner': constants.testBrandOwner,
              'brand_name': constants.testBrandName,
              'sub_brand_name': constants.testSubBrandName,
              'gtin_upc': constants.testGTINUPC,
              'ingredients': constants.testIngredients,
              'not_a_significant_source_of':
                  constants.testNotASignificantSourceOf,
            },
          ),
          isA<DBBrandedFood>()
              .having(
                (DBBrandedFood s) => s.brandOwner,
                'brand owner',
                equals(constants.testBrandOwner),
              )
              .having(
                (DBBrandedFood s) => s.brandName,
                'brand name',
                equals(constants.testBrandName),
              )
              .having(
                (DBBrandedFood s) => s.subBrandName,
                'sub brand name',
                equals(constants.testSubBrandName),
              )
              .having(
                (DBBrandedFood s) => s.gtinUpc,
                'gtin/upc',
                equals(constants.testGTINUPC),
              )
              .having(
                (DBBrandedFood s) => s.ingredients,
                'ingredients',
                equals(constants.testIngredients),
              )
              .having(
                (DBBrandedFood s) => s.notASignificantSourceOf,
                'not a significant source of',
                equals(constants.testNotASignificantSourceOf),
              ),
        );
      });
    });
  });
}
