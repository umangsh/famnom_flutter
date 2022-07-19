import 'package:app_repository/app_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/browse/browse.dart';

class MockAppRepository extends Mock implements AppRepository {}

void main() {
  const userRecipe = UserRecipeDisplay(
    externalId: constants.testUUID,
    name: constants.testRecipeName,
  );

  const rdis = <FDAGroup, Map<int, FdaRdi>>{};
  const preferences = <int, Preference>{};

  group('BrowseMyRecipesCubit', () {
    late AppRepository appRepository;

    setUp(() {
      appRepository = MockAppRepository();
      when(() => appRepository.myRecipesWithQuery(query: any(named: 'query')))
          .thenAnswer((_) async => [userRecipe]);
      when(() => appRepository.myRecipesWithURI())
          .thenAnswer((_) async => [userRecipe]);
      when(() => appRepository.getConfigNutrition())
          .thenAnswer((_) async => rdis);
      when(() => appRepository.getNutritionPreferences())
          .thenAnswer((_) async => preferences);
    });

    test('initial state is BrowseState', () {
      expect(BrowseMyRecipesCubit(appRepository).state, const BrowseState());
    });

    group('getResultsWithQuery', () {
      blocTest<BrowseMyRecipesCubit, BrowseState>(
        'emits [requestSubmitted], emits [requestFinishedWithResults] '
        'and gets results',
        build: () => BrowseMyRecipesCubit(appRepository),
        act: (cubit) => cubit.getResultsWithQuery(constants.testQuery),
        expect: () => <BrowseState>[
          const BrowseState(status: BrowseStatus.requestSubmitted),
          const BrowseState(
            status: BrowseStatus.requestFinishedWithResults,
            recipeResults: [userRecipe],
          ),
        ],
      );

      blocTest<BrowseMyRecipesCubit, BrowseState>(
        'emits [requestSubmitted], emits [requestFinishedEmptyResults] '
        'and throws GetDBFoodFailure',
        setUp: () {
          when(
            () => appRepository.myRecipesWithQuery(query: any(named: 'query')),
          ).thenAnswer((_) async => []);
        },
        build: () => BrowseMyRecipesCubit(appRepository),
        act: (cubit) => cubit.getResultsWithQuery(constants.testQuery),
        expect: () => <BrowseState>[
          const BrowseState(status: BrowseStatus.requestSubmitted),
          const BrowseState(
            status: BrowseStatus.requestFinishedEmptyResults,
          ),
        ],
      );

      blocTest<BrowseMyRecipesCubit, BrowseState>(
        'emits [requestSubmitted], emits [requestFailure] '
        'and throws MyRecipesFailure',
        setUp: () {
          when(
            () => appRepository.myRecipesWithQuery(query: any(named: 'query')),
          ).thenThrow(const MyRecipesFailure());
        },
        build: () => BrowseMyRecipesCubit(appRepository),
        act: (cubit) => cubit.getResultsWithQuery(constants.testQuery),
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
      blocTest<BrowseMyRecipesCubit, BrowseState>(
        'emits [requestMoreFinishedWithResults] and gets results',
        build: () => BrowseMyRecipesCubit(appRepository),
        act: (cubit) => cubit.getMoreResults(),
        expect: () => <BrowseState>[
          const BrowseState(
            status: BrowseStatus.requestMoreFinishedWithResults,
            recipeResults: [userRecipe],
          ),
        ],
      );

      blocTest<BrowseMyRecipesCubit, BrowseState>(
        'emits [requestMoreFinishedEmptyResults] and throws GetDBFoodFailure',
        setUp: () {
          when(() => appRepository.myRecipesWithURI())
              .thenAnswer((_) async => []);
        },
        build: () => BrowseMyRecipesCubit(appRepository),
        act: (cubit) => cubit.getMoreResults(),
        expect: () => <BrowseState>[
          const BrowseState(
            status: BrowseStatus.requestMoreFinishedEmptyResults,
          ),
        ],
      );

      blocTest<BrowseMyRecipesCubit, BrowseState>(
        'emits [requestFailure] and throws MyRecipesFailure',
        setUp: () {
          when(
            () => appRepository.myRecipesWithURI(),
          ).thenThrow(const MyRecipesFailure());
        },
        build: () => BrowseMyRecipesCubit(appRepository),
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
      blocTest<BrowseMyRecipesCubit, BrowseState>(
        'emits [init]',
        build: () => BrowseMyRecipesCubit(appRepository),
        act: (cubit) => cubit.clearSearchBar(),
        expect: () => <BrowseState>[
          const BrowseState(),
        ],
      );
    });
  });
}
