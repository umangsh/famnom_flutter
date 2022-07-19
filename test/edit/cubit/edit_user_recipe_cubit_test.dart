import 'package:app_repository/app_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/edit/edit.dart';

class MockAppRepository extends Mock implements AppRepository {}

void main() {
  const userRecipe = UserRecipeMutable(
    externalId: constants.testUUID,
    name: constants.testRecipeName,
    recipeDate: constants.testRecipeDate,
    portions: [
      UserFoodPortion(
        id: constants.testPortionId,
        externalId: constants.testPortionExternalId,
        servingSize: constants.testPortionSize,
        servingSizeUnit: constants.testPortionSizeUnit,
      ),
    ],
  );

  final recipeForm = RecipeForm(
    externalId: constants.testUUID,
    name: constants.testRecipeName,
    recipeDate: constants.testRecipeDate,
  );

  group('EditUserRecipeCubit', () {
    late AppRepository appRepository;

    setUp(() {
      appRepository = MockAppRepository();

      when(
        () => appRepository.getMutableUserRecipe(
          externalId: any(named: 'externalId'),
        ),
      ).thenAnswer((_) async => userRecipe);
      when(
        () => appRepository.saveUserRecipe(
          values: any(named: 'values'),
        ),
      ).thenAnswer((_) async => constants.testUUID);

      when(
        () => appRepository.getAppConstants(),
      ).thenAnswer((_) async => const AppConstants());
    });

    test('initial state is EditUserRecipeState', () {
      expect(
        EditUserRecipeCubit(appRepository).state,
        const EditUserRecipeState(),
      );
    });

    group('fetchUserRecipe', () {
      blocTest<EditUserRecipeCubit, EditUserRecipeState>(
        'emits [requestSubmitted], emits [requestSuccess] and fetches data',
        build: () => EditUserRecipeCubit(appRepository),
        act: (cubit) => cubit.fetchUserRecipe(externalId: constants.testUUID),
        expect: () => <EditUserRecipeState>[
          const EditUserRecipeState(
            status: EditUserRecipeStatus.requestSubmitted,
          ),
          EditUserRecipeState(
            status: EditUserRecipeStatus.requestSuccess,
            userRecipe: userRecipe,
            appConstants: const AppConstants(),
            form: recipeForm,
          ),
        ],
      );

      blocTest<EditUserRecipeCubit, EditUserRecipeState>(
        'emits [requestSubmitted], emits [requestFailure] and '
        'throws GetUserRecipeFailure',
        setUp: () {
          when(
            () => appRepository.getMutableUserRecipe(
              externalId: any(named: 'externalId'),
            ),
          ).thenThrow(const GetUserRecipeFailure());
        },
        build: () => EditUserRecipeCubit(appRepository),
        act: (cubit) => cubit.fetchUserRecipe(externalId: constants.testUUID),
        expect: () => <EditUserRecipeState>[
          const EditUserRecipeState(
            status: EditUserRecipeStatus.requestSubmitted,
          ),
          const EditUserRecipeState(
            status: EditUserRecipeStatus.requestFailure,
            errorMessage: 'Something went wrong. Please try again later.',
          ),
        ],
      );
    });

    group('saveUserRecipe', () {
      blocTest<EditUserRecipeCubit, EditUserRecipeState>(
        'emits [saveRequestSubmitted], emits [saveRequestSuccess] '
        'and loads page data',
        build: () => EditUserRecipeCubit(appRepository),
        seed: () => EditUserRecipeState(form: recipeForm),
        act: (cubit) => cubit.saveUserRecipe(externalId: constants.testUUID),
        expect: () => <EditUserRecipeState>[
          EditUserRecipeState(
            status: EditUserRecipeStatus.saveRequestSubmitted,
            form: recipeForm,
          ),
          EditUserRecipeState(
            status: EditUserRecipeStatus.saveRequestSuccess,
            redirectExternalId: constants.testUUID,
            form: recipeForm,
          ),
        ],
      );

      blocTest<EditUserRecipeCubit, EditUserRecipeState>(
        'emits [saveRequestSubmitted], emits [saveRequestFailure] '
        'and throws GetUserRecipeFailure',
        setUp: () {
          when(
            () => appRepository.saveUserRecipe(
              values: any(named: 'values'),
            ),
          ).thenThrow(const GetUserRecipeFailure());
        },
        build: () => EditUserRecipeCubit(appRepository),
        seed: () => EditUserRecipeState(form: recipeForm),
        act: (cubit) => cubit.saveUserRecipe(externalId: constants.testUUID),
        expect: () => <EditUserRecipeState>[
          EditUserRecipeState(
            status: EditUserRecipeStatus.saveRequestSubmitted,
            form: recipeForm,
          ),
          EditUserRecipeState(
            status: EditUserRecipeStatus.saveRequestFailure,
            form: recipeForm,
            errorMessage: 'Something went wrong. Please try again later.',
          ),
        ],
      );

      blocTest<EditUserRecipeCubit, EditUserRecipeState>(
        'emits [saveRequestSubmitted], emits [saveRequestFailure] '
        'on missing name',
        build: () => EditUserRecipeCubit(appRepository),
        act: (cubit) => cubit.saveUserRecipe(externalId: constants.testUUID),
        expect: () => <EditUserRecipeState>[
          const EditUserRecipeState(
            status: EditUserRecipeStatus.saveRequestSubmitted,
          ),
          const EditUserRecipeState(
            status: EditUserRecipeStatus.saveRequestFailure,
            errorMessage: 'Name missing.',
          ),
        ],
      );
    });

    group('redrawPage', () {
      blocTest<EditUserRecipeCubit, EditUserRecipeState>(
        'emits [redrawRequested], emits [redrawDone]',
        build: () => EditUserRecipeCubit(appRepository),
        act: (cubit) => cubit.redrawPage(),
        expect: () => <EditUserRecipeState>[
          const EditUserRecipeState(
            status: EditUserRecipeStatus.redrawRequested,
          ),
          const EditUserRecipeState(status: EditUserRecipeStatus.redrawDone)
        ],
      );
    });
  });
}
