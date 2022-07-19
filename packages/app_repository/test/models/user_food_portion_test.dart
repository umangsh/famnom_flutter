import 'package:constants/constants.dart' as constants;
import 'package:famnom_api/famnom_api.dart';
import 'package:test/test.dart';

void main() {
  group('UserFoodPortion', () {
    group('fromJson', () {
      test('returns UserFoodPortion', () {
        expect(
          UserFoodPortion.fromJson(
            const <String, dynamic>{
              'id': constants.testPortionId,
              'external_id': constants.testPortionExternalId,
              'servings_per_container':
                  constants.testPortionServingsPerContainer,
              'household_quantity': constants.testPortionHouseholdQuantity,
              'household_unit': constants.testPortionHouseholdUnit,
              'serving_size': constants.testPortionSize,
              'serving_size_unit': constants.testPortionSizeUnit,
            },
          ),
          isA<UserFoodPortion>()
              .having(
                (UserFoodPortion s) => s.id,
                'id',
                equals(constants.testPortionId),
              )
              .having(
                (UserFoodPortion s) => s.externalId,
                'external ID',
                equals(constants.testPortionExternalId),
              )
              .having(
                (UserFoodPortion s) => s.servingsPerContainer,
                'servings per container',
                equals(constants.testPortionServingsPerContainer),
              )
              .having(
                (UserFoodPortion s) => s.householdQuantity,
                'household quantity',
                equals(constants.testPortionHouseholdQuantity),
              )
              .having(
                (UserFoodPortion s) => s.householdUnit,
                'household unit',
                equals(constants.testPortionHouseholdUnit),
              )
              .having(
                (UserFoodPortion s) => s.servingSize,
                'serving size',
                equals(constants.testPortionSize),
              )
              .having(
                (UserFoodPortion s) => s.servingSizeUnit,
                'serving size unit',
                equals(constants.testPortionSizeUnit),
              ),
        );
      });
    });
  });
}
