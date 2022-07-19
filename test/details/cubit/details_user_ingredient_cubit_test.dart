import 'package:app_repository/app_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/details/details.dart';

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

  group('DetailsUserIngredientCubit', () {
    late AppRepository appRepository;

    setUp(() {
      appRepository = MockAppRepository();
      when(() => appRepository.getUserIngredient(any()))
          .thenAnswer((_) async => userIngredient);
      when(() => appRepository.getConfigNutrition())
          .thenAnswer((_) async => rdis);
      when(() => appRepository.getNutritionPreferences())
          .thenAnswer((_) async => preferences);
    });

    test('initial state is DetailsState', () {
      expect(
        DetailsUserIngredientCubit(appRepository).state,
        const DetailsState(),
      );
    });

    group('loadPageData', () {
      blocTest<DetailsUserIngredientCubit, DetailsState>(
        'emits [requestSubmitted], emits [requestSuccess] and loads page data',
        build: () => DetailsUserIngredientCubit(appRepository),
        act: (cubit) => cubit.loadPageData(externalId: constants.testUUID),
        expect: () => <DetailsState>[
          const DetailsState(status: DetailsStatus.requestSubmitted),
          DetailsState(
            status: DetailsStatus.requestSuccess,
            userIngredient: userIngredient,
            selectedPortion: userIngredient.defaultPortion,
            fdaRDIs: rdis,
          ),
        ],
      );

      blocTest<DetailsUserIngredientCubit, DetailsState>(
        'emits [requestSubmitted], emits [requestFailure] '
        'and throws GetUserIngredientFailure',
        setUp: () {
          when(
            () => appRepository.getUserIngredient(any()),
          ).thenThrow(const GetUserIngredientFailure());
        },
        build: () => DetailsUserIngredientCubit(appRepository),
        act: (cubit) => cubit.loadPageData(externalId: constants.testUUID),
        expect: () => <DetailsState>[
          const DetailsState(status: DetailsStatus.requestSubmitted),
          const DetailsState(
            status: DetailsStatus.requestFailure,
            errorMessage: 'Something went wrong. Please try again later.',
          ),
        ],
      );

      blocTest<DetailsUserIngredientCubit, DetailsState>(
        'emits [requestSubmitted], emits [requestFailure] '
        'and throws GetConfigNutritionFailure',
        setUp: () {
          when(
            () => appRepository.getUserIngredient(any()),
          ).thenThrow(const GetConfigNutritionFailure());
        },
        build: () => DetailsUserIngredientCubit(appRepository),
        act: (cubit) => cubit.loadPageData(externalId: constants.testUUID),
        expect: () => <DetailsState>[
          const DetailsState(status: DetailsStatus.requestSubmitted),
          const DetailsState(
            status: DetailsStatus.requestFailure,
            errorMessage: 'Something went wrong. Please try again later.',
          ),
        ],
      );

      blocTest<DetailsUserIngredientCubit, DetailsState>(
        'emits [requestSubmitted], emits [requestFailure] '
        'and throws GetNutritionPreferencesFailure',
        setUp: () {
          when(
            () => appRepository.getUserIngredient(any()),
          ).thenThrow(const GetNutritionPreferencesFailure());
        },
        build: () => DetailsUserIngredientCubit(appRepository),
        act: (cubit) => cubit.loadPageData(externalId: constants.testUUID),
        expect: () => <DetailsState>[
          const DetailsState(status: DetailsStatus.requestSubmitted),
          const DetailsState(
            status: DetailsStatus.requestFailure,
            errorMessage: 'Something went wrong. Please try again later.',
          ),
        ],
      );
    });

    group('selectPortion', () {
      const portion = Portion(
        externalId: constants.testPortionExternalId,
        name: constants.testPortionName,
        servingSize: constants.testPortionSize,
        servingSizeUnit: constants.testPortionSizeUnit,
      );

      blocTest<DetailsUserIngredientCubit, DetailsState>(
        'emits [portionSelected]',
        build: () => DetailsUserIngredientCubit(appRepository),
        act: (cubit) => cubit.selectPortion(portion: portion),
        expect: () => <DetailsState>[
          const DetailsState(
            status: DetailsStatus.portionSelected,
            selectedPortion: portion,
          ),
        ],
      );
    });

    group('setQuantity', () {
      blocTest<DetailsUserIngredientCubit, DetailsState>(
        'emits [portionSelected]',
        build: () => DetailsUserIngredientCubit(appRepository),
        act: (cubit) => cubit.setQuantity(quantity: 2),
        expect: () => <DetailsState>[
          const DetailsState(
            status: DetailsStatus.portionSelected,
            quantity: 2,
          ),
        ],
      );
    });
  });
}
