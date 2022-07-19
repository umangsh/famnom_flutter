import 'package:constants/constants.dart' as constants;
import 'package:famnom_api/famnom_api.dart';
import 'package:test/test.dart';

void main() {
  group('Preference', () {
    group('fromJson', () {
      test('returns Preference object', () {
        expect(
          Preference.fromJson(
            const <String, dynamic>{
              'food_nutrient_id': constants.testNutrientId,
              'thresholds': [
                <String, double?>{
                  'min_value': 90.0,
                  'max_value': null,
                  'exact_value': null
                }
              ],
            },
          ),
          isA<Preference>()
              .having(
                (Preference a) => a.foodNutrientId,
                'food nutrient ID',
                equals(constants.testNutrientId),
              )
              .having(
                (Preference a) => a.thresholds.length,
                'thresholds',
                equals(1),
              ),
        );
      });
    });
  });
}
