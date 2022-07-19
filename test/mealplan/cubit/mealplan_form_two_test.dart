import 'package:famnom_flutter/mealplan/mealplan.dart';
import 'package:test/test.dart';

void main() {
  group('MealplanFormTwo', () {
    group('convertToMap', () {
      test('MealplanFormTwo with values', () {
        const form = MealplanFormTwo(
          thresholdTypes: {
            'one': '1',
            'two': '2',
          },
          thresholdValues: {
            'one': 1,
            'two': 2,
          },
        );
        final expected = <String, dynamic>{
          'one': 1,
          'threshold_one': '1',
          'two': 2,
          'threshold_two': '2',
        };
        expect(form.convertToMap(), equals(expected));
      });
    });
  });
}
