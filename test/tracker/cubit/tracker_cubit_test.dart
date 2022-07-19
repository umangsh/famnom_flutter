import 'package:app_repository/app_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/tracker/tracker.dart';

class MockAppRepository extends Mock implements AppRepository {}

void main() {
  const preferences = <int, Preference>{};

  group('TrackerCubit', () {
    late AppRepository appRepository;

    setUp(() {
      appRepository = MockAppRepository();
      when(
        () => appRepository.getTracker(any()),
      ).thenAnswer(
        (_) async => Tracker.empty,
      );
      when(() => appRepository.getNutritionPreferences())
          .thenAnswer((_) async => preferences);
    });

    test('initial state is TrackerState', () {
      expect(TrackerCubit(appRepository).state, const TrackerState());
    });

    group('getTracker', () {
      final date = DateTime.now();
      blocTest<TrackerCubit, TrackerState>(
        'emits [requestSubmitted], emits [requestSuccess] and returns tracker',
        build: () => TrackerCubit(appRepository),
        act: (cubit) => cubit.getTracker(date: date),
        expect: () => <TrackerState>[
          TrackerState(
            status: TrackerStatus.requestSubmitted,
            date: date,
          ),
          TrackerState(
            status: TrackerStatus.requestSuccess,
            tracker: Tracker.empty,
            date: date,
          ),
        ],
      );

      blocTest<TrackerCubit, TrackerState>(
        'emits [requestSubmitted], emits [requestFailure] and throws',
        setUp: () {
          when(
            () => appRepository.getTracker(any()),
          ).thenThrow(const GetTrackerFailure());
        },
        build: () => TrackerCubit(appRepository),
        act: (cubit) => cubit.getTracker(date: date),
        expect: () => <TrackerState>[
          TrackerState(status: TrackerStatus.requestSubmitted, date: date),
          TrackerState(
            status: TrackerStatus.requestFailure,
            date: date,
            errorMessage: 'Something went wrong. Please try again later.',
          ),
        ],
      );
    });

    group('dateChanged', () {
      final date = DateTime.now();
      blocTest<TrackerCubit, TrackerState>(
        'emits [dateChanged], and returns tracker',
        build: () => TrackerCubit(appRepository),
        act: (cubit) => cubit.dateChanged(date: date),
        expect: () => <TrackerState>[
          TrackerState(status: TrackerStatus.dateChanged, date: date),
        ],
      );
    });
  });
}
