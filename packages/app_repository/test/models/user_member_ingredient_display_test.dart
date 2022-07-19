import 'package:app_repository/app_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:test/test.dart';

void main() {
  group('UserMemberIngredientDisplay', () {
    group('fromJson', () {
      test('returns UserMemberIngredientDisplay with values', () {
        expect(
          UserMemberIngredientDisplay.fromJson(const <String, dynamic>{
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
          }),
          isA<UserMemberIngredientDisplay>()
              .having(
                (UserMemberIngredientDisplay s) => s.externalId,
                'external id',
                equals(constants.testUUID),
              )
              .having(
                (UserMemberIngredientDisplay s) => s.ingredient.externalId,
                'ingredient external ID',
                equals(constants.testUUID),
              )
              .having(
                (UserMemberIngredientDisplay s) => s.ingredient.name,
                'ingredient name',
                equals(constants.testFoodName),
              )
              .having(
                (UserMemberIngredientDisplay s) => s.ingredient.brand,
                'brand',
                isNotNull,
              )
              .having(
                (UserMemberIngredientDisplay s) => s.portion,
                'portion',
                isNotNull,
              ),
        );
      });
    });
  });
}
