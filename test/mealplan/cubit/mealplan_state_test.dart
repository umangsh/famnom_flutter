import 'package:flutter_test/flutter_test.dart';
import 'package:famnom_flutter/mealplan/mealplan.dart';

void main() {
  group('MealplanState', () {
    test('supports value comparisons', () {
      expect(const MealplanState(), const MealplanState());
    });

    test('returns same object when no properties are passed', () {
      expect(const MealplanState().copyWith(), const MealplanState());
    });

    test('returns object with updated status when status is passed', () {
      expect(
        const MealplanState()
            .copyWith(status: MealplanStatus.loadRequestSubmitted),
        const MealplanState(status: MealplanStatus.loadRequestSubmitted),
      );
    });

    test('returns object with updated form one when it is passed', () {
      final form = MealplanFormOne();
      expect(
        const MealplanState().copyWith(formOne: form),
        MealplanState(formOne: form),
      );
    });
  });
}
