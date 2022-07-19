import 'package:constants/constants.dart' as constants;
import 'package:famnom_api/famnom_api.dart';
import 'package:test/test.dart';

void main() {
  group('UserMemberIngredientDisplay', () {
    group('fromJson', () {
      test('returns UserMemberIngredientDisplay with values', () {
        expect(
          UserMemberIngredientDisplay.fromJson(const <String, dynamic>{
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
          }),
          isA<UserMemberIngredientDisplay>()
              .having(
                (UserMemberIngredientDisplay s) => s.externalId,
                'external id',
                equals(constants.testUUID),
              )
              .having(
                (UserMemberIngredientDisplay s) =>
                    s.displayIngredient.externalId,
                'display ingredient external ID',
                equals(constants.testUUID),
              )
              .having(
                (UserMemberIngredientDisplay s) => s.displayIngredient.name,
                'display ingredient name',
                equals(constants.testFoodName),
              )
              .having(
                (UserMemberIngredientDisplay s) =>
                    s.displayIngredient.brand?.brandName,
                'brand name',
                equals(constants.testBrandName),
              )
              .having(
                (UserMemberIngredientDisplay s) =>
                    s.displayIngredient.brand?.brandOwner,
                'brand owner',
                equals(constants.testBrandOwner),
              )
              .having(
                (UserMemberIngredientDisplay s) => s.displayPortion,
                'portion',
                isNotNull,
              ),
        );
      });
    });
  });
}
