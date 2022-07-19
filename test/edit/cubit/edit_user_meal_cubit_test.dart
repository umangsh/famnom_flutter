import 'package:app_repository/app_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/edit/edit.dart';

class MockAppRepository extends Mock implements AppRepository {}

void main() {
  const userMeal = UserMealMutable(
    externalId: constants.testUUID,
    mealType: constants.testMealType,
    mealDate: constants.testMealDate,
  );

  final mealForm = MealForm(
    externalId: constants.testUUID,
    mealType: constants.testMealType,
    mealDate: constants.testMealDate,
  );

  group('EditUserMealCubit', () {
    late AppRepository appRepository;

    setUp(() {
      appRepository = MockAppRepository();

      when(
        () => appRepository.getMutableUserMeal(
          externalId: any(named: 'externalId'),
        ),
      ).thenAnswer((_) async => userMeal);
      when(
        () => appRepository.saveUserMeal(
          values: any(named: 'values'),
        ),
      ).thenAnswer((_) async => constants.testUUID);

      when(
        () => appRepository.getAppConstants(),
      ).thenAnswer((_) async => const AppConstants());
    });

    test('initial state is EditUserMealState', () {
      expect(
        EditUserMealCubit(appRepository).state,
        const EditUserMealState(),
      );
    });

    group('fetchUserMeal', () {
      blocTest<EditUserMealCubit, EditUserMealState>(
        'emits [requestSubmitted], emits [requestSuccess] and fetches data',
        build: () => EditUserMealCubit(appRepository),
        act: (cubit) => cubit.fetchUserMeal(externalId: constants.testUUID),
        expect: () => <EditUserMealState>[
          const EditUserMealState(
            status: EditUserMealStatus.requestSubmitted,
          ),
          EditUserMealState(
            status: EditUserMealStatus.requestSuccess,
            userMeal: userMeal,
            appConstants: const AppConstants(),
            form: mealForm,
          ),
        ],
      );

      blocTest<EditUserMealCubit, EditUserMealState>(
        'emits [requestSubmitted], emits [requestFailure] and '
        'throws GetUserMealFailure',
        setUp: () {
          when(
            () => appRepository.getMutableUserMeal(
              externalId: any(named: 'externalId'),
            ),
          ).thenThrow(const GetUserMealFailure());
        },
        build: () => EditUserMealCubit(appRepository),
        act: (cubit) => cubit.fetchUserMeal(externalId: constants.testUUID),
        expect: () => <EditUserMealState>[
          const EditUserMealState(
            status: EditUserMealStatus.requestSubmitted,
          ),
          const EditUserMealState(
            status: EditUserMealStatus.requestFailure,
            errorMessage: 'Something went wrong. Please try again later.',
          ),
        ],
      );
    });

    group('saveUserMeal', () {
      blocTest<EditUserMealCubit, EditUserMealState>(
        'emits [saveRequestSubmitted], emits [saveRequestSuccess] '
        'and loads page data',
        build: () => EditUserMealCubit(appRepository),
        seed: () => EditUserMealState(form: mealForm),
        act: (cubit) => cubit.saveUserMeal(externalId: constants.testUUID),
        expect: () => <EditUserMealState>[
          EditUserMealState(
            status: EditUserMealStatus.saveRequestSubmitted,
            form: mealForm,
          ),
          EditUserMealState(
            status: EditUserMealStatus.saveRequestSuccess,
            redirectExternalId: constants.testUUID,
            form: mealForm,
          ),
        ],
      );

      blocTest<EditUserMealCubit, EditUserMealState>(
        'emits [saveRequestSubmitted], emits [saveRequestFailure] '
        'and throws GetUserMealFailure',
        setUp: () {
          when(
            () => appRepository.saveUserMeal(
              values: any(named: 'values'),
            ),
          ).thenThrow(const GetUserMealFailure());
        },
        build: () => EditUserMealCubit(appRepository),
        seed: () => EditUserMealState(form: mealForm),
        act: (cubit) => cubit.saveUserMeal(externalId: constants.testUUID),
        expect: () => <EditUserMealState>[
          EditUserMealState(
            status: EditUserMealStatus.saveRequestSubmitted,
            form: mealForm,
          ),
          EditUserMealState(
            status: EditUserMealStatus.saveRequestFailure,
            form: mealForm,
            errorMessage: 'Something went wrong. Please try again later.',
          ),
        ],
      );

      blocTest<EditUserMealCubit, EditUserMealState>(
        'emits [saveRequestSubmitted], emits [saveRequestFailure] '
        'on missing name',
        build: () => EditUserMealCubit(appRepository),
        act: (cubit) => cubit.saveUserMeal(externalId: constants.testUUID),
        expect: () => <EditUserMealState>[
          const EditUserMealState(
            status: EditUserMealStatus.saveRequestSubmitted,
          ),
          const EditUserMealState(
            status: EditUserMealStatus.saveRequestFailure,
            errorMessage: 'Name missing.',
          ),
        ],
      );
    });

    group('redrawPage', () {
      blocTest<EditUserMealCubit, EditUserMealState>(
        'emits [redrawRequested], emits [redrawDone]',
        build: () => EditUserMealCubit(appRepository),
        act: (cubit) => cubit.redrawPage(),
        expect: () => <EditUserMealState>[
          const EditUserMealState(
            status: EditUserMealStatus.redrawRequested,
          ),
          const EditUserMealState(status: EditUserMealStatus.redrawDone)
        ],
      );
    });
  });
}
