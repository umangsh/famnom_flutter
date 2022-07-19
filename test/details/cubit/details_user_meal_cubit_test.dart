import 'package:app_repository/app_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/details/details.dart';

class MockAppRepository extends Mock implements AppRepository {}

void main() {
  const userMeal = UserMealDisplay(
    externalId: constants.testUUID,
    mealType: constants.testMealType,
    mealDate: constants.testMealDate,
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
    memberIngredients: [
      UserMemberIngredientDisplay(
        externalId: constants.testUUID,
        ingredient: UserIngredientDisplay(
          externalId: constants.testUUID,
          name: constants.testFoodName,
        ),
      )
    ],
    memberRecipes: [
      UserMemberRecipeDisplay(
        externalId: constants.testUUID,
        recipe: UserRecipeDisplay(
          externalId: constants.testUUID,
          name: constants.testFoodName,
        ),
      )
    ],
  );

  const rdis = <FDAGroup, Map<int, FdaRdi>>{};
  const preferences = <int, Preference>{};

  group('DetailsUserMealCubit', () {
    late AppRepository appRepository;

    setUp(() {
      appRepository = MockAppRepository();
      when(() => appRepository.getUserMeal(any()))
          .thenAnswer((_) async => userMeal);
      when(() => appRepository.getConfigNutrition())
          .thenAnswer((_) async => rdis);
      when(() => appRepository.getNutritionPreferences())
          .thenAnswer((_) async => preferences);
    });

    test('initial state is DetailsState', () {
      expect(
        DetailsUserMealCubit(appRepository).state,
        const DetailsState(),
      );
    });

    group('loadPageData', () {
      blocTest<DetailsUserMealCubit, DetailsState>(
        'emits [requestSubmitted], emits [requestSuccess] and loads page data',
        build: () => DetailsUserMealCubit(appRepository),
        act: (cubit) => cubit.loadPageData(externalId: constants.testUUID),
        expect: () => <DetailsState>[
          const DetailsState(status: DetailsStatus.requestSubmitted),
          const DetailsState(
            status: DetailsStatus.requestSuccess,
            userMeal: userMeal,
            fdaRDIs: rdis,
          ),
        ],
      );

      blocTest<DetailsUserMealCubit, DetailsState>(
        'emits [requestSubmitted], emits [requestFailure] '
        'and throws GetUserMealFailure',
        setUp: () {
          when(
            () => appRepository.getUserMeal(any()),
          ).thenThrow(const GetUserMealFailure());
        },
        build: () => DetailsUserMealCubit(appRepository),
        act: (cubit) => cubit.loadPageData(externalId: constants.testUUID),
        expect: () => <DetailsState>[
          const DetailsState(status: DetailsStatus.requestSubmitted),
          const DetailsState(
            status: DetailsStatus.requestFailure,
            errorMessage: 'Something went wrong. Please try again later.',
          ),
        ],
      );

      blocTest<DetailsUserMealCubit, DetailsState>(
        'emits [requestSubmitted], emits [requestFailure] '
        'and throws GetConfigNutritionFailure',
        setUp: () {
          when(
            () => appRepository.getUserMeal(any()),
          ).thenThrow(const GetConfigNutritionFailure());
        },
        build: () => DetailsUserMealCubit(appRepository),
        act: (cubit) => cubit.loadPageData(externalId: constants.testUUID),
        expect: () => <DetailsState>[
          const DetailsState(status: DetailsStatus.requestSubmitted),
          const DetailsState(
            status: DetailsStatus.requestFailure,
            errorMessage: 'Something went wrong. Please try again later.',
          ),
        ],
      );

      blocTest<DetailsUserMealCubit, DetailsState>(
        'emits [requestSubmitted], emits [requestFailure] '
        'and throws GetNutritionPreferencesFailure',
        setUp: () {
          when(
            () => appRepository.getUserMeal(any()),
          ).thenThrow(const GetNutritionPreferencesFailure());
        },
        build: () => DetailsUserMealCubit(appRepository),
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

      blocTest<DetailsUserMealCubit, DetailsState>(
        'emits [portionSelected]',
        build: () => DetailsUserMealCubit(appRepository),
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
      blocTest<DetailsUserMealCubit, DetailsState>(
        'emits [portionSelected]',
        build: () => DetailsUserMealCubit(appRepository),
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
