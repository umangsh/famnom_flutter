import 'package:app_repository/app_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/details/details.dart';

class MockAppRepository extends Mock implements AppRepository {}

void main() {
  const userRecipe = UserRecipeDisplay(
    externalId: constants.testUUID,
    name: constants.testRecipeName,
    recipeDate: constants.testRecipeDate,
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

  group('DetailsUserRecipeCubit', () {
    late AppRepository appRepository;

    setUp(() {
      appRepository = MockAppRepository();
      when(() => appRepository.getUserRecipe(any()))
          .thenAnswer((_) async => userRecipe);
      when(() => appRepository.getConfigNutrition())
          .thenAnswer((_) async => rdis);
      when(() => appRepository.getNutritionPreferences())
          .thenAnswer((_) async => preferences);
    });

    test('initial state is DetailsState', () {
      expect(
        DetailsUserRecipeCubit(appRepository).state,
        const DetailsState(),
      );
    });

    group('loadPageData', () {
      blocTest<DetailsUserRecipeCubit, DetailsState>(
        'emits [requestSubmitted], emits [requestSuccess] and loads page data',
        build: () => DetailsUserRecipeCubit(appRepository),
        act: (cubit) => cubit.loadPageData(externalId: constants.testUUID),
        expect: () => <DetailsState>[
          const DetailsState(status: DetailsStatus.requestSubmitted),
          DetailsState(
            status: DetailsStatus.requestSuccess,
            userRecipe: userRecipe,
            selectedPortion: userRecipe.defaultPortion,
            fdaRDIs: rdis,
          ),
        ],
      );

      blocTest<DetailsUserRecipeCubit, DetailsState>(
        'emits [requestSubmitted], emits [requestFailure] '
        'and throws GetUserRecipeFailure',
        setUp: () {
          when(
            () => appRepository.getUserRecipe(any()),
          ).thenThrow(const GetUserRecipeFailure());
        },
        build: () => DetailsUserRecipeCubit(appRepository),
        act: (cubit) => cubit.loadPageData(externalId: constants.testUUID),
        expect: () => <DetailsState>[
          const DetailsState(status: DetailsStatus.requestSubmitted),
          const DetailsState(
            status: DetailsStatus.requestFailure,
            errorMessage: 'Something went wrong. Please try again later.',
          ),
        ],
      );

      blocTest<DetailsUserRecipeCubit, DetailsState>(
        'emits [requestSubmitted], emits [requestFailure] '
        'and throws GetConfigNutritionFailure',
        setUp: () {
          when(
            () => appRepository.getUserRecipe(any()),
          ).thenThrow(const GetConfigNutritionFailure());
        },
        build: () => DetailsUserRecipeCubit(appRepository),
        act: (cubit) => cubit.loadPageData(externalId: constants.testUUID),
        expect: () => <DetailsState>[
          const DetailsState(status: DetailsStatus.requestSubmitted),
          const DetailsState(
            status: DetailsStatus.requestFailure,
            errorMessage: 'Something went wrong. Please try again later.',
          ),
        ],
      );

      blocTest<DetailsUserRecipeCubit, DetailsState>(
        'emits [requestSubmitted], emits [requestFailure] '
        'and throws GetNutritionPreferencesFailure',
        setUp: () {
          when(
            () => appRepository.getUserRecipe(any()),
          ).thenThrow(const GetNutritionPreferencesFailure());
        },
        build: () => DetailsUserRecipeCubit(appRepository),
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

      blocTest<DetailsUserRecipeCubit, DetailsState>(
        'emits [portionSelected]',
        build: () => DetailsUserRecipeCubit(appRepository),
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
      blocTest<DetailsUserRecipeCubit, DetailsState>(
        'emits [portionSelected]',
        build: () => DetailsUserRecipeCubit(appRepository),
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
