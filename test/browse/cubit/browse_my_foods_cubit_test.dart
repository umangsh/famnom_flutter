import 'package:app_repository/app_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/browse/browse.dart';

class MockAppRepository extends Mock implements AppRepository {}

void main() {
  const userIngredient = UserIngredientDisplay(
    externalId: constants.testUUID,
    name: constants.testFoodName,
    portions: [
      Portion(
        externalId: constants.testPortionExternalId,
        name: constants.testPortionName,
        servingSize: constants.testPortionSize,
        servingSizeUnit: constants.testPortionSizeUnit,
      ),
    ],
    nutrients: Nutrients(
      servingSize: constants.testNutrientServingSize,
      servingSizeUnit: constants.testNutrientServingSizeUnit,
      values: {
        constants.testNutrientId: Nutrient(
          id: constants.testNutrientId,
          name: constants.testNutrientName,
          amount: constants.testNutrientAmount,
          unit: constants.testNutrientUnit,
        )
      },
    ),
  );

  const rdis = <FDAGroup, Map<int, FdaRdi>>{};
  const preferences = <int, Preference>{};

  group('BrowseMyFoodsCubit', () {
    late AppRepository appRepository;

    setUp(() {
      appRepository = MockAppRepository();
      when(() => appRepository.myFoodsWithQuery(query: any(named: 'query')))
          .thenAnswer((_) async => [userIngredient]);
      when(() => appRepository.myFoodsWithURI())
          .thenAnswer((_) async => [userIngredient]);
      when(() => appRepository.getConfigNutrition())
          .thenAnswer((_) async => rdis);
      when(() => appRepository.getNutritionPreferences())
          .thenAnswer((_) async => preferences);
    });

    test('initial state is BrowseState', () {
      expect(BrowseMyFoodsCubit(appRepository).state, const BrowseState());
    });

    group('getResultsWithQuery', () {
      blocTest<BrowseMyFoodsCubit, BrowseState>(
        'emits [requestSubmitted], emits [requestFinishedWithResults] '
        'and gets results',
        build: () => BrowseMyFoodsCubit(appRepository),
        act: (cubit) => cubit.getResultsWithQuery(constants.testQuery),
        expect: () => <BrowseState>[
          const BrowseState(status: BrowseStatus.requestSubmitted),
          const BrowseState(
            status: BrowseStatus.requestFinishedWithResults,
            ingredientResults: [userIngredient],
          ),
        ],
      );

      blocTest<BrowseMyFoodsCubit, BrowseState>(
        'emits [requestSubmitted], emits [requestFinishedEmptyResults] '
        'and throws GetDBFoodFailure',
        setUp: () {
          when(() => appRepository.myFoodsWithQuery(query: any(named: 'query')))
              .thenAnswer((_) async => []);
        },
        build: () => BrowseMyFoodsCubit(appRepository),
        act: (cubit) => cubit.getResultsWithQuery(constants.testQuery),
        expect: () => <BrowseState>[
          const BrowseState(status: BrowseStatus.requestSubmitted),
          const BrowseState(
            status: BrowseStatus.requestFinishedEmptyResults,
          ),
        ],
      );

      blocTest<BrowseMyFoodsCubit, BrowseState>(
        'emits [requestSubmitted], emits [requestFailure] '
        'and throws MyFoodsFailure',
        setUp: () {
          when(
            () => appRepository.myFoodsWithQuery(query: any(named: 'query')),
          ).thenThrow(const MyFoodsFailure());
        },
        build: () => BrowseMyFoodsCubit(appRepository),
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
      blocTest<BrowseMyFoodsCubit, BrowseState>(
        'emits [requestMoreFinishedWithResults] and gets results',
        build: () => BrowseMyFoodsCubit(appRepository),
        act: (cubit) => cubit.getMoreResults(),
        expect: () => <BrowseState>[
          const BrowseState(
            status: BrowseStatus.requestMoreFinishedWithResults,
            ingredientResults: [userIngredient],
          ),
        ],
      );

      blocTest<BrowseMyFoodsCubit, BrowseState>(
        'emits [requestMoreFinishedEmptyResults] and throws GetDBFoodFailure',
        setUp: () {
          when(() => appRepository.myFoodsWithURI())
              .thenAnswer((_) async => []);
        },
        build: () => BrowseMyFoodsCubit(appRepository),
        act: (cubit) => cubit.getMoreResults(),
        expect: () => <BrowseState>[
          const BrowseState(
            status: BrowseStatus.requestMoreFinishedEmptyResults,
          ),
        ],
      );

      blocTest<BrowseMyFoodsCubit, BrowseState>(
        'emits [requestFailure] and throws MyFoodsFailure',
        setUp: () {
          when(
            () => appRepository.myFoodsWithURI(),
          ).thenThrow(const MyFoodsFailure());
        },
        build: () => BrowseMyFoodsCubit(appRepository),
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
      blocTest<BrowseMyFoodsCubit, BrowseState>(
        'emits [init]',
        build: () => BrowseMyFoodsCubit(appRepository),
        act: (cubit) => cubit.clearSearchBar(),
        expect: () => <BrowseState>[
          const BrowseState(),
        ],
      );
    });

    group('scannerInit', () {
      blocTest<BrowseMyFoodsCubit, BrowseState>(
        'emits [barcodeRequest]',
        build: () => BrowseMyFoodsCubit(appRepository),
        act: (cubit) => cubit.scannerInit(),
        expect: () => <BrowseState>[
          const BrowseState(status: BrowseStatus.barcodeRequest),
        ],
      );
    });
  });
}
