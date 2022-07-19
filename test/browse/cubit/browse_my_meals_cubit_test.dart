import 'package:app_repository/app_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/browse/browse.dart';

class MockAppRepository extends Mock implements AppRepository {}

void main() {
  const userMeal = UserMealDisplay(
    externalId: constants.testUUID,
    mealType: constants.testMealType,
    mealDate: constants.testMealDate,
  );

  const rdis = <FDAGroup, Map<int, FdaRdi>>{};
  const preferences = <int, Preference>{};

  group('BrowseMyMealsCubit', () {
    late AppRepository appRepository;

    setUp(() {
      appRepository = MockAppRepository();
      when(() => appRepository.myMeals()).thenAnswer((_) async => [userMeal]);
      when(() => appRepository.myMealsWithURI())
          .thenAnswer((_) async => [userMeal]);
      when(() => appRepository.getConfigNutrition())
          .thenAnswer((_) async => rdis);
      when(() => appRepository.getNutritionPreferences())
          .thenAnswer((_) async => preferences);
    });

    test('initial state is BrowseState', () {
      expect(BrowseMyMealsCubit(appRepository).state, const BrowseState());
    });

    group('getResultsWithQuery', () {
      blocTest<BrowseMyMealsCubit, BrowseState>(
        'emits [requestSubmitted], emits [requestFinishedWithResults] '
        'and gets results',
        build: () => BrowseMyMealsCubit(appRepository),
        act: (cubit) => cubit.getResults(),
        expect: () => <BrowseState>[
          const BrowseState(status: BrowseStatus.requestSubmitted),
          const BrowseState(
            status: BrowseStatus.requestFinishedWithResults,
            mealResults: [userMeal],
          ),
        ],
      );

      blocTest<BrowseMyMealsCubit, BrowseState>(
        'emits [requestSubmitted], emits [requestFinishedEmptyResults] '
        'and throws GetDBFoodFailure',
        setUp: () {
          when(() => appRepository.myMeals()).thenAnswer((_) async => []);
        },
        build: () => BrowseMyMealsCubit(appRepository),
        act: (cubit) => cubit.getResults(),
        expect: () => <BrowseState>[
          const BrowseState(status: BrowseStatus.requestSubmitted),
          const BrowseState(
            status: BrowseStatus.requestFinishedEmptyResults,
          ),
        ],
      );

      blocTest<BrowseMyMealsCubit, BrowseState>(
        'emits [requestSubmitted], emits [requestFailure] '
        'and throws MyMealsFailure',
        setUp: () {
          when(() => appRepository.myMeals()).thenThrow(const MyMealsFailure());
        },
        build: () => BrowseMyMealsCubit(appRepository),
        act: (cubit) => cubit.getResults(),
        expect: () => <BrowseState>[
          const BrowseState(status: BrowseStatus.requestSubmitted),
          const BrowseState(
            status: BrowseStatus.requestFailure,
            errorMessage: 'Something went wrong. Please try again later.',
          ),
        ],
      );
    });

    group('getMoreResults', () {
      blocTest<BrowseMyMealsCubit, BrowseState>(
        'emits [requestMoreFinishedWithResults] and gets results',
        build: () => BrowseMyMealsCubit(appRepository),
        act: (cubit) => cubit.getMoreResults(),
        expect: () => <BrowseState>[
          const BrowseState(
            status: BrowseStatus.requestMoreFinishedWithResults,
            mealResults: [userMeal],
          ),
        ],
      );

      blocTest<BrowseMyMealsCubit, BrowseState>(
        'emits [requestMoreFinishedEmptyResults] and throws GetDBFoodFailure',
        setUp: () {
          when(() => appRepository.myMealsWithURI())
              .thenAnswer((_) async => []);
        },
        build: () => BrowseMyMealsCubit(appRepository),
        act: (cubit) => cubit.getMoreResults(),
        expect: () => <BrowseState>[
          const BrowseState(
            status: BrowseStatus.requestMoreFinishedEmptyResults,
          ),
        ],
      );

      blocTest<BrowseMyMealsCubit, BrowseState>(
        'emits [requestFailure] and throws MyMealsFailure',
        setUp: () {
          when(
            () => appRepository.myMealsWithURI(),
          ).thenThrow(const MyMealsFailure());
        },
        build: () => BrowseMyMealsCubit(appRepository),
        act: (cubit) => cubit.getMoreResults(),
        expect: () => <BrowseState>[
          const BrowseState(
            status: BrowseStatus.requestFailure,
            errorMessage: 'Something went wrong. Please try again later.',
          ),
        ],
      );
    });

    group('clearSearchBar', () {
      blocTest<BrowseMyMealsCubit, BrowseState>(
        'emits [init]',
        build: () => BrowseMyMealsCubit(appRepository),
        act: (cubit) => cubit.clearSearchBar(),
        expect: () => <BrowseState>[
          const BrowseState(),
        ],
      );
    });
  });
}
