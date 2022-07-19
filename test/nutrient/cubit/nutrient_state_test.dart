import 'package:app_repository/app_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter_test/flutter_test.dart';
import 'package:famnom_flutter/nutrient/nutrient.dart';

void main() {
  group('NutrientState', () {
    test('supports value comparisons', () {
      expect(const NutrientState(), const NutrientState());
    });

    test('returns same object when no properties are passed', () {
      expect(const NutrientState().copyWith(), const NutrientState());
    });

    test('returns object with updated status when status is passed', () {
      expect(
        const NutrientState().copyWith(status: NutrientStatus.requestSubmitted),
        const NutrientState(status: NutrientStatus.requestSubmitted),
      );
    });

    test('returns object with updated nutrientPage when it is passed', () {
      const nutrientPage = NutrientPage(
        id: constants.testNutrientId,
        name: constants.testNutrientName,
      );
      expect(
        const NutrientState().copyWith(nutrientPage: nutrientPage),
        const NutrientState(nutrientPage: nutrientPage),
      );
    });
  });
}
