import 'package:app_repository/app_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/details/details.dart';

class MockAppRepository extends Mock implements AppRepository {}

void main() {
  const dbFood = DBFood(
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

  group('DetailsDBFoodCubit', () {
    late AppRepository appRepository;

    setUp(() {
      appRepository = MockAppRepository();
      when(() => appRepository.getDBFood(any()))
          .thenAnswer((_) async => dbFood);
      when(() => appRepository.getConfigNutrition())
          .thenAnswer((_) async => rdis);
      when(() => appRepository.getNutritionPreferences())
          .thenAnswer((_) async => preferences);
    });

    test('initial state is DetailsState', () {
      expect(DetailsDBFoodCubit(appRepository).state, const DetailsState());
    });

    group('loadPageData', () {
      blocTest<DetailsDBFoodCubit, DetailsState>(
        'emits [requestSubmitted], emits [requestSuccess] and loads page data',
        build: () => DetailsDBFoodCubit(appRepository),
        act: (cubit) => cubit.loadPageData(externalId: constants.testUUID),
        expect: () => <DetailsState>[
          const DetailsState(status: DetailsStatus.requestSubmitted),
          DetailsState(
            status: DetailsStatus.requestSuccess,
            dbFood: dbFood,
            selectedPortion: dbFood.defaultPortion,
            fdaRDIs: rdis,
          ),
        ],
      );

      blocTest<DetailsDBFoodCubit, DetailsState>(
        'emits [requestSubmitted], emits [requestFailure] '
        'and throws GetDBFoodFailure',
        setUp: () {
          when(
            () => appRepository.getDBFood(any()),
          ).thenThrow(const GetDBFoodFailure());
        },
        build: () => DetailsDBFoodCubit(appRepository),
        act: (cubit) => cubit.loadPageData(externalId: constants.testUUID),
        expect: () => <DetailsState>[
          const DetailsState(status: DetailsStatus.requestSubmitted),
          const DetailsState(
            status: DetailsStatus.requestFailure,
            errorMessage: 'Something went wrong. Please try again later.',
          ),
        ],
      );

      blocTest<DetailsDBFoodCubit, DetailsState>(
        'emits [requestSubmitted], emits [requestFailure] '
        'and throws GetConfigNutritionFailure',
        setUp: () {
          when(
            () => appRepository.getDBFood(any()),
          ).thenThrow(const GetConfigNutritionFailure());
        },
        build: () => DetailsDBFoodCubit(appRepository),
        act: (cubit) => cubit.loadPageData(externalId: constants.testUUID),
        expect: () => <DetailsState>[
          const DetailsState(status: DetailsStatus.requestSubmitted),
          const DetailsState(
            status: DetailsStatus.requestFailure,
            errorMessage: 'Something went wrong. Please try again later.',
          ),
        ],
      );

      blocTest<DetailsDBFoodCubit, DetailsState>(
        'emits [requestSubmitted], emits [requestFailure] '
        'and throws GetNutritionPreferencesFailure',
        setUp: () {
          when(
            () => appRepository.getDBFood(any()),
          ).thenThrow(const GetNutritionPreferencesFailure());
        },
        build: () => DetailsDBFoodCubit(appRepository),
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

      blocTest<DetailsDBFoodCubit, DetailsState>(
        'emits [portionSelected]',
        build: () => DetailsDBFoodCubit(appRepository),
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
      blocTest<DetailsDBFoodCubit, DetailsState>(
        'emits [portionSelected]',
        build: () => DetailsDBFoodCubit(appRepository),
        act: (cubit) => cubit.setQuantity(quantity: 2),
        expect: () => <DetailsState>[
          const DetailsState(
            status: DetailsStatus.portionSelected,
            quantity: 2,
          ),
        ],
      );
    });

    group('saveDBFood', () {
      blocTest<DetailsDBFoodCubit, DetailsState>(
        'emits [saveRequestSubmitted], emits [saveRequestSuccess]',
        setUp: () {
          when(
            () => appRepository.saveDBFood(any()),
          ).thenAnswer((_) async {});
        },
        build: () => DetailsDBFoodCubit(appRepository),
        act: (cubit) => cubit.saveDBFood(externalId: constants.testUUID),
        expect: () => <DetailsState>[
          const DetailsState(status: DetailsStatus.saveRequestSubmitted),
          const DetailsState(status: DetailsStatus.saveRequestSuccess),
        ],
      );

      blocTest<DetailsDBFoodCubit, DetailsState>(
        'emits [saveRequestSubmitted], emits [saveRequestFailure] '
        'and throws SaveDBFoodFailure',
        setUp: () {
          when(
            () => appRepository.saveDBFood(any()),
          ).thenThrow(const SaveDBFoodFailure());
        },
        build: () => DetailsDBFoodCubit(appRepository),
        act: (cubit) => cubit.saveDBFood(externalId: constants.testUUID),
        expect: () => <DetailsState>[
          const DetailsState(status: DetailsStatus.saveRequestSubmitted),
          const DetailsState(
            status: DetailsStatus.saveRequestFailure,
            errorMessage: 'Something went wrong. Please try again later.',
          ),
        ],
      );
    });
  });
}
