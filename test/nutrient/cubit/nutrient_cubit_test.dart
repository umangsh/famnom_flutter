import 'package:app_repository/app_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/nutrient/nutrient.dart';

class MockAppRepository extends Mock implements AppRepository {}

void main() {
  const nutrientPage = NutrientPage(
    id: constants.testNutrientId,
    name: constants.testNutrientName,
  );

  group('NutrientCubit', () {
    late AppRepository appRepository;

    setUp(() {
      appRepository = MockAppRepository();
      when(
        () => appRepository.getNutrientPage(
          nutrientId: constants.testNutrientId,
          chartDays: any(named: 'chartDays'),
        ),
      ).thenAnswer((_) async => nutrientPage);
    });

    test('initial state is NutrientState', () {
      expect(
        NutrientCubit(appRepository).state,
        const NutrientState(),
      );
    });

    group('fetchData', () {
      blocTest<NutrientCubit, NutrientState>(
        'emits [requestSubmitted], emits [requestSuccess] and loads data',
        build: () => NutrientCubit(appRepository),
        act: (cubit) => cubit.fetchData(nutrientId: constants.testNutrientId),
        expect: () => <NutrientState>[
          const NutrientState(status: NutrientStatus.requestSubmitted),
          const NutrientState(
            status: NutrientStatus.requestSuccess,
            nutrientPage: nutrientPage,
          ),
        ],
      );

      blocTest<NutrientCubit, NutrientState>(
        'emits [requestSubmitted], emits [requestFailure] '
        'and throws [GetNutrientPageFailure]',
        setUp: () {
          when(
            () => appRepository.getNutrientPage(
              nutrientId: constants.testNutrientId,
              chartDays: any(named: 'chartDays'),
            ),
          ).thenThrow(const GetNutrientPageFailure());
        },
        build: () => NutrientCubit(appRepository),
        act: (cubit) => cubit.fetchData(nutrientId: constants.testNutrientId),
        expect: () => <NutrientState>[
          const NutrientState(status: NutrientStatus.requestSubmitted),
          const NutrientState(
            status: NutrientStatus.requestFailure,
            errorMessage: 'Something went wrong. Please try again later.',
          ),
        ],
      );
    });
  });
}
