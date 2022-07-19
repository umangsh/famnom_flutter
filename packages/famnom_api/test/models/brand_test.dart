import 'package:constants/constants.dart' as constants;
import 'package:famnom_api/famnom_api.dart';
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
              'subbrand_name': constants.testSubBrandName,
              'gtin_upc': constants.testGTINUPC,
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
                (Brand s) => s.subbrandName,
                'sub brand name',
                equals(constants.testSubBrandName),
              )
              .having(
                (Brand s) => s.gtinUpc,
                'gtin/upc',
                equals(constants.testGTINUPC),
              ),
        );
      });
    });
  });
}
