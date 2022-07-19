import 'package:constants/constants.dart' as constants;
import 'package:famnom_api/famnom_api.dart';
import 'package:test/test.dart';

void main() {
  group('MealplanPreference', () {
    group('fromJson', () {
      test('returns MealplanPreference object', () {
        expect(
          MealplanPreference.fromJson(
            const <String, dynamic>{
              'external_id': constants.testUUID,
              'name': constants.testFoodName,
              'thresholds': [
                <String, double?>{
                  'min_value': 90.0,
                  'max_value': null,
                  'exact_value': null
                }
              ],
            },
          ),
          isA<MealplanPreference>()
              .having(
                (MealplanPreference a) => a.externalId,
                'external ID',
                equals(constants.testUUID),
              )
              .having(
                (MealplanPreference a) => a.name,
                'name',
                equals(constants.testFoodName),
              )
              .having(
                (MealplanPreference a) => a.thresholds.length,
                'thresholds',
                equals(1),
              ),
        );
      });
    });
  });
}
