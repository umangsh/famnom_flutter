import 'package:famnom_flutter/mealplan/mealplan.dart';
import 'package:test/test.dart';

void main() {
  group('MealplanFormThree', () {
    group('convertToMap', () {
      test('MealplanFormThree with values', () {
        const form = MealplanFormThree(
          mealTypes: {
            'one': 'Lunch',
            'two': 'Dinner',
          },
          quantities: {
            'one': 1,
            'two': 2,
          },
        );
        final expected = <String, dynamic>{
          'one': 1,
          'meal_one': 'Lunch',
          'two': 2,
          'meal_two': 'Dinner',
        };
        expect(form.convertToMap(), equals(expected));
      });
    });
  });
}
