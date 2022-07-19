import 'package:constants/constants.dart' as constants;
import 'package:famnom_api/famnom_api.dart';
import 'package:test/test.dart';

void main() {
  group('UserFoodMembership', () {
    group('fromJson', () {
      test('returns UserFoodMembership', () {
        expect(
          UserFoodMembership.fromJson(
            const <String, dynamic>{
              'id': constants.testPortionId,
              'external_id': constants.testPortionExternalId,
              'child_id': constants.testID,
              'child_name': constants.testFoodName,
              'child_external_id': constants.testUUID,
              'child_portion_name': constants.testPortionName,
              'child_portion_external_id': constants.testUUID,
              'quantity': constants.testPortionSize,
            },
          ),
          isA<UserFoodMembership>()
              .having(
                (UserFoodMembership s) => s.id,
                'id',
                equals(constants.testPortionId),
              )
              .having(
                (UserFoodMembership s) => s.externalId,
                'external ID',
                equals(constants.testPortionExternalId),
              )
              .having(
                (UserFoodMembership s) => s.childId,
                'child id',
                equals(constants.testID),
              )
              .having(
                (UserFoodMembership s) => s.childExternalId,
                'child external id',
                equals(constants.testUUID),
              )
              .having(
                (UserFoodMembership s) => s.childPortionExternalId,
                'child portion external id',
                equals(constants.testUUID),
              )
              .having(
                (UserFoodMembership s) => s.quantity,
                'quantity',
                equals(constants.testPortionSize),
              ),
        );
      });
    });
  });
}
