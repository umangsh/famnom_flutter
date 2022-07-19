import 'package:app_repository/app_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:famnom_flutter/goals/goals.dart';

void main() {
  group('GoalsState', () {
    test('supports value comparisons', () {
      expect(const GoalsState(), const GoalsState());
    });

    test('returns same object when no properties are passed', () {
      expect(const GoalsState().copyWith(), const GoalsState());
    });

    test('returns object with updated status when status is passed', () {
      expect(
        const GoalsState().copyWith(status: GoalsStatus.requestSubmitted),
        const GoalsState(status: GoalsStatus.requestSubmitted),
      );
    });

    test('returns object with updated nutritionPreferences when it is passed',
        () {
      const preferences = <int, Preference>{};
      expect(
        const GoalsState().copyWith(nutritionPreferences: preferences),
        const GoalsState(),
      );
    });

    test('returns object with updated fdaRDIs when it is passed', () {
      const rdis = <FDAGroup, Map<int, FdaRdi>>{};
      expect(
        const GoalsState().copyWith(fdaRDIs: rdis),
        const GoalsState(fdaRDIs: rdis),
      );
    });
  });
}
