import 'package:app_repository/app_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:test/test.dart';

void main() {
  group('Brand', () {
    group('fromJson', () {
      test('returns Brand', () {
        expect(
          Brand.fromJson(
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
          isA<Brand>()
              .having(
                (Brand s) => s.brandOwner,
                'brand owner',
                equals(constants.testBrandOwner),
              )
              .having(
                (Brand s) => s.brandName,
                'brand name',
                equals(constants.testBrandName),
              )
              .having(
                (Brand s) => s.subBrandName,
                'sub brand name',
                equals(constants.testSubBrandName),
              )
              .having(
                (Brand s) => s.gtinUpc,
                'gtin/upc',
                equals(constants.testGTINUPC),
              )
              .having(
                (Brand s) => s.ingredients,
                'ingredients',
                equals(constants.testIngredients),
              )
              .having(
                (Brand s) => s.notASignificantSourceOf,
                'not a significant source of',
                equals(constants.testNotASignificantSourceOf),
              ),
        );
      });
    });

    group('brand details', () {
      test('empty', () {
        const brand = Brand.empty;
        expect(brand.brandDetails, isNull);
      });

      test('brand name only', () {
        const brand = Brand(brandName: constants.testBrandName);
        expect(brand.brandDetails, equals('test_brand_name'));
      });

      test('brand owner only', () {
        const brand = Brand(brandOwner: constants.testBrandOwner);
        expect(brand.brandDetails, equals('test_brand_owner'));
      });

      test('brand name and owner', () {
        const brand = Brand(
          brandName: constants.testBrandName,
          brandOwner: constants.testBrandOwner,
          subBrandName: constants.testSubBrandName,
        );
        expect(
          brand.brandDetails,
          equals('test_brand_name, test_sub_brand_name, test_brand_owner'),
        );
      });
    });
  });
}
