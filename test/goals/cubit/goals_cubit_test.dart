import 'package:app_repository/app_repository.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/goals/goals.dart';

class MockUser extends Mock implements User {}

class MockAppRepository extends Mock implements AppRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  const rdis = <FDAGroup, Map<int, FdaRdi>>{};
  const preferences = <int, Preference>{};

  group('GoalsCubit', () {
    late AppRepository appRepository;
    late AuthRepository authRepository;
    late User user;

    setUp(() {
      appRepository = MockAppRepository();
      authRepository = MockAuthRepository();

      when(() => appRepository.getConfigNutrition())
          .thenAnswer((_) async => rdis);
      when(
        () => appRepository.getNutritionPreferences(
          skipCache: any(named: 'skipCache'),
        ),
      ).thenAnswer((_) async => preferences);
      when(
        () => appRepository.saveNutritionPreferences(any()),
      ).thenAnswer((_) async {});

      user = MockUser();
      when(() => user.dateOfBirth)
          .thenReturn(DateTime.parse(constants.testDateOfBirth));
      when(() => user.isEmpty).thenReturn(false);
      when(() => authRepository.currentUser).thenReturn(user);
    });

    test('initial state is GoalsState', () {
      expect(
        GoalsCubit(appRepository, authRepository).state,
        const GoalsState(),
      );
    });

    group('loadPageData', () {
      blocTest<GoalsCubit, GoalsState>(
        'emits [requestSubmitted], emits [requestSuccess] and loads page data',
        build: () => GoalsCubit(appRepository, authRepository),
        act: (cubit) => cubit.loadPageData(),
        expect: () => <GoalsState>[
          const GoalsState(status: GoalsStatus.requestSubmitted),
          const GoalsState(
            status: GoalsStatus.requestSuccess,
            fdaRDIs: rdis,
            // ignore: avoid_redundant_argument_values
            nutritionPreferences: preferences,
            formValues: <String, dynamic>{
              'date_of_birth': constants.testDateOfBirth
            },
          ),
        ],
      );

      blocTest<GoalsCubit, GoalsState>(
        'emits [requestSubmitted], emits [requestFailure] and throws ',
        setUp: () {
          when(
            () => appRepository.getConfigNutrition(),
          ).thenThrow(const GetConfigNutritionFailure());
        },
        build: () => GoalsCubit(appRepository, authRepository),
        act: (cubit) => cubit.loadPageData(),
        expect: () => <GoalsState>[
          const GoalsState(status: GoalsStatus.requestSubmitted),
          const GoalsState(
            status: GoalsStatus.requestFailure,
            errorMessage: 'Something went wrong. Please try again later.',
          ),
        ],
      );
    });

    group('populateDefaults', () {
      blocTest<GoalsCubit, GoalsState>(
        'emits [populateDefaults]',
        build: () => GoalsCubit(appRepository, authRepository),
        act: (cubit) => cubit.populateDefaults(),
        expect: () => <GoalsState>[
          const GoalsState(status: GoalsStatus.populateDefaults)
        ],
      );
    });

    group('saveGoals', () {
      blocTest<GoalsCubit, GoalsState>(
        'emits [submissionSubmitted], emits [submissionSuccess] and saves data',
        build: () => GoalsCubit(appRepository, authRepository),
        act: (cubit) => cubit.saveGoals(),
        expect: () => <GoalsState>[
          const GoalsState(status: GoalsStatus.submissionSubmitted),
          const GoalsState(
            status: GoalsStatus.submissionSuccess,
            // ignore: avoid_redundant_argument_values
            nutritionPreferences: preferences,
            formValues: <String, dynamic>{
              'date_of_birth': constants.testDateOfBirth
            },
          ),
        ],
      );

      blocTest<GoalsCubit, GoalsState>(
        'emits [submissionSubmitted], emits [requestFailure] and throws ',
        setUp: () {
          when(
            () => appRepository.saveNutritionPreferences(any()),
          ).thenThrow(const SaveNutritionPreferencesFailure());
        },
        build: () => GoalsCubit(appRepository, authRepository),
        act: (cubit) => cubit.saveGoals(),
        expect: () => <GoalsState>[
          const GoalsState(status: GoalsStatus.submissionSubmitted),
          const GoalsState(
            status: GoalsStatus.requestFailure,
            errorMessage: 'Something went wrong. Please try again later.',
          ),
        ],
      );
    });

    group('refreshPage', () {
      blocTest<GoalsCubit, GoalsState>(
        'calls loadPageData',
        build: () => GoalsCubit(appRepository, authRepository),
        act: (cubit) => cubit.refreshPage(),
        expect: () => <GoalsState>[
          const GoalsState(status: GoalsStatus.requestSubmitted),
          const GoalsState(
            status: GoalsStatus.requestSuccess,
            fdaRDIs: rdis,
            // ignore: avoid_redundant_argument_values
            nutritionPreferences: preferences,
            formValues: <String, dynamic>{
              'date_of_birth': constants.testDateOfBirth
            },
          ),
        ],
      );
    });
  });
}
