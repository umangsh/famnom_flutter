import 'package:app_repository/app_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/mealplan/mealplan.dart';

class MockAppRepository extends Mock implements AppRepository {}

void main() {
  group('MealplanCubit', () {
    late AppRepository appRepository;

    setUp(() {
      appRepository = MockAppRepository();
    });

    test('initial state is MealplanState', () {
      expect(MealplanCubit(appRepository).state, const MealplanState());
    });

    group('refreshPage', () {
      blocTest<MealplanCubit, MealplanState>(
        'emits [init]',
        build: () => MealplanCubit(appRepository),
        act: (cubit) => cubit.refreshPage(),
        expect: () => const [MealplanState()],
      );
    });

    group('loadItems', () {
      blocTest<MealplanCubit, MealplanState>(
        'emits [loadRequestSubmitted], emits [loadRequestSuccess] and '
        'loads items',
        setUp: () {
          when(
            () => appRepository.myFoodsWithQuery(
              flagSet: any(named: 'flagSet'),
              pageSize: any(named: 'pageSize'),
            ),
          ).thenAnswer((_) async => []);
          when(
            () => appRepository.myRecipesWithQuery(
              flagSet: any(named: 'flagSet'),
              pageSize: any(named: 'pageSize'),
            ),
          ).thenAnswer((_) async => []);
        },
        build: () => MealplanCubit(appRepository),
        act: (cubit) => cubit.loadItems(),
        expect: () => <MealplanState>[
          const MealplanState(status: MealplanStatus.loadRequestSubmitted),
          MealplanState(
            status: MealplanStatus.loadRequestSuccess,
            formOne: MealplanFormOne(
              allFoods: const [],
              allRecipes: const [],
              availableFoods: const [],
              availableRecipes: const [],
              dontHaveFoods: const [],
              dontHaveRecipes: const [],
              mustHaveFoods: const [],
              mustHaveRecipes: const [],
              dontRepeatFoods: const [],
              dontRepeatRecipes: const [],
            ),
          ),
        ],
      );

      blocTest<MealplanCubit, MealplanState>(
        'emits [loadRequestSubmitted], emits [loadRequestFailure] and throws ',
        setUp: () {
          when(
            () => appRepository.myFoodsWithQuery(
              flagSet: any(named: 'flagSet'),
            ),
          ).thenThrow(const MyFoodsFailure());
        },
        build: () => MealplanCubit(appRepository),
        act: (cubit) => cubit.loadItems(),
        expect: () => <MealplanState>[
          const MealplanState(status: MealplanStatus.loadRequestSubmitted),
          const MealplanState(
            status: MealplanStatus.loadRequestFailure,
            errorMessage: 'Something went wrong. Please try again later.',
          ),
        ],
      );
    });

    group('saveItems', () {
      blocTest<MealplanCubit, MealplanState>(
        'emits [requestFailure]',
        setUp: () {
          when(
            () => appRepository.saveMealplanFormOne(
              values: any(named: 'values'),
            ),
          ).thenThrow(const SaveMealplanFormOneFailure());
        },
        build: () => MealplanCubit(appRepository),
        act: (cubit) => cubit.saveItems(),
        expect: () => <MealplanState>[
          const MealplanState(
            status: MealplanStatus.requestFailure,
            errorMessage: 'Something went wrong. Please try again later.',
          ),
        ],
      );
    });

    group('loadThresholds', () {
      blocTest<MealplanCubit, MealplanState>(
        'emits [thresholdsRequestSubmitted], emits [thresholdsRequestSuccess] '
        'and loads thresholds',
        setUp: () {
          when(
            () => appRepository.getMealplanFormTwo(),
          ).thenAnswer((_) async => []);
        },
        build: () => MealplanCubit(appRepository),
        act: (cubit) => cubit.loadThresholds(),
        expect: () => <MealplanState>[
          const MealplanState(
            status: MealplanStatus.thresholdsRequestSubmitted,
          ),
          const MealplanState(
            status: MealplanStatus.thresholdsRequestSuccess,
            preferences: {},
            formTwo: MealplanFormTwo(thresholdTypes: {}, thresholdValues: {}),
          ),
        ],
      );

      blocTest<MealplanCubit, MealplanState>(
        'emits [thresholdsRequestSubmitted], emits [thresholdsRequestSuccess] '
        'and throws ',
        setUp: () {
          when(
            () => appRepository.myFoodsWithQuery(
              flagSet: any(named: 'flagSet'),
            ),
          ).thenThrow(const GetMealplanFormTwoFailure());
        },
        build: () => MealplanCubit(appRepository),
        act: (cubit) => cubit.loadThresholds(),
        expect: () => <MealplanState>[
          const MealplanState(
            status: MealplanStatus.thresholdsRequestSubmitted,
          ),
          const MealplanState(
            status: MealplanStatus.thresholdsRequestFailure,
            errorMessage: 'Something went wrong. Please try again later.',
          ),
        ],
      );
    });

    group('saveThresholds', () {
      blocTest<MealplanCubit, MealplanState>(
        'emits [requestFailure]',
        setUp: () {
          when(
            () => appRepository.saveMealplanFormTwo(
              values: any(named: 'values'),
            ),
          ).thenThrow(const SaveMealplanFormTwoFailure());
        },
        build: () => MealplanCubit(appRepository),
        act: (cubit) => cubit.saveThresholds(),
        expect: () => <MealplanState>[
          const MealplanState(
            status: MealplanStatus.requestFailure,
            errorMessage: 'Something went wrong. Please try again later.',
          ),
        ],
      );
    });

    group('loadMealplan', () {
      blocTest<MealplanCubit, MealplanState>(
        'emits [mealplanRequestSubmitted], emits [mealplanRequestSuccess] '
        'and loads thresholds',
        setUp: () {
          when(
            () => appRepository.getMealplanFormThree(),
          ).thenAnswer(
            (_) async => const Mealplan(infeasible: true, results: []),
          );
        },
        build: () => MealplanCubit(appRepository),
        act: (cubit) => cubit.loadMealplan(),
        expect: () => <MealplanState>[
          const MealplanState(
            status: MealplanStatus.mealplanRequestSubmitted,
          ),
          const MealplanState(
            status: MealplanStatus.mealplanRequestSuccess,
            mealplanInfeasible: true,
            mealplanResults: {},
            formThree: MealplanFormThree(mealTypes: {}, quantities: {}),
          ),
        ],
      );

      blocTest<MealplanCubit, MealplanState>(
        'emits [mealplanRequestSubmitted], emits [mealplanRequestFailure] '
        'and throws ',
        setUp: () {
          when(
            () => appRepository.getMealplanFormThree(),
          ).thenThrow(const GetMealplanFormThreeFailure());
        },
        build: () => MealplanCubit(appRepository),
        act: (cubit) => cubit.loadMealplan(),
        expect: () => <MealplanState>[
          const MealplanState(
            status: MealplanStatus.mealplanRequestSubmitted,
          ),
          const MealplanState(
            status: MealplanStatus.mealplanRequestFailure,
            errorMessage: 'Something went wrong. Please try again later.',
          ),
        ],
      );
    });

    group('saveMealplan', () {
      blocTest<MealplanCubit, MealplanState>(
        'emits [mealplanSaved]',
        setUp: () {
          when(
            () => appRepository.saveMealplanFormThree(
              values: any(named: 'values'),
            ),
          ).thenAnswer((_) async {});
        },
        build: () => MealplanCubit(appRepository),
        act: (cubit) => cubit.saveMealplan(),
        expect: () => <MealplanState>[
          const MealplanState(status: MealplanStatus.mealplanSaved),
        ],
      );

      blocTest<MealplanCubit, MealplanState>(
        'emits [requestFailure]',
        setUp: () {
          when(
            () => appRepository.saveMealplanFormThree(
              values: any(named: 'values'),
            ),
          ).thenThrow(const SaveMealplanFormThreeFailure());
        },
        build: () => MealplanCubit(appRepository),
        act: (cubit) => cubit.saveMealplan(),
        expect: () => <MealplanState>[
          const MealplanState(
            status: MealplanStatus.requestFailure,
            errorMessage: 'Something went wrong. Please try again later.',
          ),
        ],
      );
    });
  });
}
