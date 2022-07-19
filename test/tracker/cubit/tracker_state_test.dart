import 'package:app_repository/app_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:famnom_flutter/tracker/tracker.dart';

void main() {
  group('TrackerState', () {
    test('supports value comparisons', () {
      expect(const TrackerState(), const TrackerState());
    });

    test('returns same object when no properties are passed', () {
      expect(const TrackerState().copyWith(), const TrackerState());
    });

    test('returns object with updated status when status is passed', () {
      expect(
        const TrackerState().copyWith(status: TrackerStatus.init),
        const TrackerState(),
      );
    });

    test('returns object with updated tracker when it is passed', () {
      expect(
        const TrackerState().copyWith(tracker: Tracker.empty),
        const TrackerState(tracker: Tracker.empty),
      );
    });

    test('returns object with updated date when it is passed', () {
      final date = DateTime.now();
      expect(
        const TrackerState().copyWith(date: date),
        TrackerState(date: date),
      );
    });
  });
}
