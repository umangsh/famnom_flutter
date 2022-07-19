import 'package:app_repository/app_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/edit/edit.dart';
import 'package:search_repository/search_repository.dart';

class MockAppRepository extends Mock implements AppRepository {}

class MockSearchRepository extends Mock implements SearchRepository {}

void main() {
  const userIngredient = UserIngredientMutable(
    externalId: constants.testUUID,
    name: constants.testFoodName,
    portions: [
      UserFoodPortion(
        id: constants.testPortionId,
        externalId: constants.testPortionExternalId,
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

  const searchResult = SearchResult(
    externalId: constants.testUUID,
    name: constants.testSearchResultName,
    url: constants.testSearchResultURI,
  );

  final foodForm = FoodForm(
    externalId: constants.testUUID,
    name: constants.testFoodName,
    nutrients: const {
      constants.ENERGY_NUTRIENT_ID: '${constants.testNutrientAmount}'
    },
  );

  group('EditUserIngredientCubit', () {
    late AppRepository appRepository;
    late SearchRepository searchRepository;

    setUp(() {
      appRepository = MockAppRepository();
      searchRepository = MockSearchRepository();

      when(
        () => appRepository.getMutableUserIngredient(
          externalId: any(named: 'externalId'),
        ),
      ).thenAnswer((_) async => userIngredient);
      when(
        () => appRepository.getAppConstants(),
      ).thenAnswer((_) async => const AppConstants());
      when(
        () => appRepository.saveUserIngredient(
          values: any(named: 'values'),
        ),
      ).thenAnswer((_) async => constants.testUUID);
      when(
        () => searchRepository.searchWithQuery(
          query: any(named: 'query'),
        ),
      ).thenAnswer((_) async => [searchResult]);
    });

    test('initial state is EditUserIngredientState', () {
      expect(
        EditUserIngredientCubit(appRepository, searchRepository).state,
        const EditUserIngredientState(),
      );
    });

    group('fetchUserIngredient', () {
      blocTest<EditUserIngredientCubit, EditUserIngredientState>(
        'emits [requestSubmitted], emits [requestSuccess] and loads page data',
        build: () => EditUserIngredientCubit(appRepository, searchRepository),
        act: (cubit) =>
            cubit.fetchUserIngredient(externalId: constants.testUUID),
        expect: () => <EditUserIngredientState>[
          const EditUserIngredientState(
            status: EditUserIngredientStatus.requestSubmitted,
          ),
          EditUserIngredientState(
            status: EditUserIngredientStatus.requestSuccess,
            userIngredient: userIngredient,
            form: foodForm,
            appConstants: const AppConstants(),
          ),
        ],
      );

      blocTest<EditUserIngredientCubit, EditUserIngredientState>(
        'emits [requestSubmitted], emits [requestFailure] '
        'and throws GetUserIngredientFailure',
        setUp: () {
          when(
            () => appRepository.getMutableUserIngredient(
              externalId: any(named: 'externalId'),
            ),
          ).thenThrow(const GetUserIngredientFailure());
        },
        build: () => EditUserIngredientCubit(appRepository, searchRepository),
        act: (cubit) =>
            cubit.fetchUserIngredient(externalId: constants.testUUID),
        expect: () => <EditUserIngredientState>[
          const EditUserIngredientState(
            status: EditUserIngredientStatus.requestSubmitted,
          ),
          const EditUserIngredientState(
            status: EditUserIngredientStatus.requestFailure,
            errorMessage: 'Something went wrong. Please try again later.',
          ),
        ],
      );
    });

    group('saveUserIngredient', () {
      blocTest<EditUserIngredientCubit, EditUserIngredientState>(
        'emits [saveRequestSubmitted], emits [saveRequestSuccess] '
        'and loads page data',
        build: () => EditUserIngredientCubit(appRepository, searchRepository),
        seed: () => EditUserIngredientState(form: foodForm),
        act: (cubit) =>
            cubit.saveUserIngredient(externalId: constants.testUUID),
        expect: () => <EditUserIngredientState>[
          EditUserIngredientState(
            status: EditUserIngredientStatus.saveRequestSubmitted,
            form: foodForm,
          ),
          EditUserIngredientState(
            status: EditUserIngredientStatus.saveRequestSuccess,
            redirectExternalId: constants.testUUID,
            form: foodForm,
          ),
        ],
      );

      blocTest<EditUserIngredientCubit, EditUserIngredientState>(
        'emits [saveRequestSubmitted], emits [saveRequestFailure] '
        'and throws GetUserIngredientFailure',
        setUp: () {
          when(
            () => appRepository.saveUserIngredient(
              values: any(named: 'values'),
            ),
          ).thenThrow(const GetUserIngredientFailure());
        },
        build: () => EditUserIngredientCubit(appRepository, searchRepository),
        seed: () => EditUserIngredientState(form: foodForm),
        act: (cubit) =>
            cubit.saveUserIngredient(externalId: constants.testUUID),
        expect: () => <EditUserIngredientState>[
          EditUserIngredientState(
            status: EditUserIngredientStatus.saveRequestSubmitted,
            form: foodForm,
          ),
          EditUserIngredientState(
            status: EditUserIngredientStatus.saveRequestFailure,
            form: foodForm,
            errorMessage: 'Something went wrong. Please try again later.',
          ),
        ],
      );

      blocTest<EditUserIngredientCubit, EditUserIngredientState>(
        'emits [saveRequestSubmitted], emits [saveRequestFailure] '
        'on missing name',
        build: () => EditUserIngredientCubit(appRepository, searchRepository),
        act: (cubit) =>
            cubit.saveUserIngredient(externalId: constants.testUUID),
        expect: () => <EditUserIngredientState>[
          const EditUserIngredientState(
            status: EditUserIngredientStatus.saveRequestSubmitted,
          ),
          const EditUserIngredientState(
            status: EditUserIngredientStatus.saveRequestFailure,
            errorMessage: 'Name missing.',
          ),
        ],
      );

      blocTest<EditUserIngredientCubit, EditUserIngredientState>(
        'emits [saveRequestSubmitted], emits [saveRequestFailure] '
        'on missing calories',
        build: () => EditUserIngredientCubit(appRepository, searchRepository),
        seed: () => EditUserIngredientState(
          form: FoodForm(name: constants.testFoodName),
        ),
        act: (cubit) =>
            cubit.saveUserIngredient(externalId: constants.testUUID),
        expect: () => <EditUserIngredientState>[
          EditUserIngredientState(
            status: EditUserIngredientStatus.saveRequestSubmitted,
            form: FoodForm(name: constants.testFoodName),
          ),
          EditUserIngredientState(
            status: EditUserIngredientStatus.saveRequestFailure,
            errorMessage: 'Calories (kcal) missing.',
            form: FoodForm(name: constants.testFoodName),
          ),
        ],
      );
    });

    group('scanInit', () {
      blocTest<EditUserIngredientCubit, EditUserIngredientState>(
        'emits [barcodeRequest]',
        build: () => EditUserIngredientCubit(appRepository, searchRepository),
        act: (cubit) => cubit.scanInit(),
        expect: () => <EditUserIngredientState>[
          const EditUserIngredientState(
            status: EditUserIngredientStatus.barcodeRequest,
          )
        ],
      );
    });

    group('scanBarcode', () {
      blocTest<EditUserIngredientCubit, EditUserIngredientState>(
        'emits [barcodeFound] and redirect external ID',
        build: () => EditUserIngredientCubit(appRepository, searchRepository),
        act: (cubit) => cubit.scanBarcode(barcode: 'ABC'),
        expect: () => <EditUserIngredientState>[
          const EditUserIngredientState(
            status: EditUserIngredientStatus.barcodeFound,
            redirectExternalId: constants.testUUID,
          ),
        ],
      );

      blocTest<EditUserIngredientCubit, EditUserIngredientState>(
        'emits [barcodeNotFoundOrFailed] with empty results',
        setUp: () {
          when(
            () => searchRepository.searchWithQuery(query: any(named: 'query')),
          ).thenAnswer((_) async => []);
        },
        build: () => EditUserIngredientCubit(appRepository, searchRepository),
        act: (cubit) => cubit.scanBarcode(barcode: 'ABC'),
        expect: () => <EditUserIngredientState>[
          const EditUserIngredientState(
            status: EditUserIngredientStatus.barcodeNotFoundOrFailed,
          ),
        ],
      );

      blocTest<EditUserIngredientCubit, EditUserIngredientState>(
        'emits [barcodeNotFoundOrFailed] on exception',
        setUp: () {
          when(
            () => searchRepository.searchWithQuery(query: any(named: 'query')),
          ).thenThrow(const SearchFailure());
        },
        build: () => EditUserIngredientCubit(appRepository, searchRepository),
        act: (cubit) => cubit.scanBarcode(barcode: 'ABC'),
        expect: () => <EditUserIngredientState>[
          const EditUserIngredientState(
            status: EditUserIngredientStatus.barcodeNotFoundOrFailed,
          ),
        ],
      );
    });

    group('scanClose', () {
      blocTest<EditUserIngredientCubit, EditUserIngredientState>(
        'emits [barcodeCancelled]',
        build: () => EditUserIngredientCubit(appRepository, searchRepository),
        act: (cubit) => cubit.scanClose(),
        expect: () => <EditUserIngredientState>[
          const EditUserIngredientState(
            status: EditUserIngredientStatus.barcodeCancelled,
          )
        ],
      );
    });

    group('servingChanged', () {
      blocTest<EditUserIngredientCubit, EditUserIngredientState>(
        'emits nothing when userIngredient present',
        build: () => EditUserIngredientCubit(appRepository, searchRepository),
        seed: () => const EditUserIngredientState(
          userIngredient: userIngredient,
        ),
        act: (cubit) => cubit.servingChanged(),
        expect: () => <EditUserIngredientState>[],
      );

      blocTest<EditUserIngredientCubit, EditUserIngredientState>(
        'emits updated serving',
        build: () => EditUserIngredientCubit(appRepository, searchRepository),
        seed: () => const EditUserIngredientState(
          nutritionServing: 'ABC',
        ),
        act: (cubit) => cubit.servingChanged(),
        expect: () => <EditUserIngredientState>[
          const EditUserIngredientState(
            // ignore: avoid_redundant_argument_values
            nutritionServing: '100g',
          )
        ],
      );

      blocTest<EditUserIngredientCubit, EditUserIngredientState>(
        'emits nothing on unchanged serving',
        build: () => EditUserIngredientCubit(appRepository, searchRepository),
        seed: () => const EditUserIngredientState(
          // ignore: avoid_redundant_argument_values
          nutritionServing: '100g',
        ),
        act: (cubit) => cubit.servingChanged(),
        expect: () => <EditUserIngredientState>[],
      );
    });
  });
}
