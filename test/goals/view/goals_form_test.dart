import 'package:app_repository/app_repository.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/goals/goals.dart';

class MockUser extends Mock implements User {}

class MockGoalsCubit extends MockCubit<GoalsState> implements GoalsCubit {}

class MockAppRepository extends Mock implements AppRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AppRepository appRepository;
  late AuthRepository authRepository;
  late GoalsCubit goalsCubit;
  late User user;

  const rdis = <FDAGroup, Map<int, FdaRdi>>{FDAGroup.adult: {}};
  const preferences = <int, Preference>{};

  setUp(() {
    appRepository = MockAppRepository();
    authRepository = MockAuthRepository();
    user = MockUser();
    when(() => user.dateOfBirth)
        .thenReturn(DateTime.parse(constants.testDateOfBirth));
    when(() => user.isEmpty).thenReturn(false);
    when(() => authRepository.currentUser).thenReturn(user);

    goalsCubit = MockGoalsCubit();
    when(() => goalsCubit.loadPageData()).thenAnswer((_) async {});
  });

  group('GoalsForm', () {
    testWidgets('renders GoalsForm init state', (tester) async {
      when(() => goalsCubit.state).thenReturn(const GoalsState());
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: RepositoryProvider.value(
              value: authRepository,
              child: BlocProvider.value(
                value: goalsCubit,
                child: const GoalsForm(),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('request failure', (tester) async {
      when(() => goalsCubit.state).thenReturn(
        const GoalsState(
          status: GoalsStatus.requestFailure,
          errorMessage: 'error',
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: RepositoryProvider.value(
              value: authRepository,
              child: BlocProvider.value(
                value: goalsCubit,
                child: const GoalsForm(),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('form rendered', (tester) async {
      when(() => goalsCubit.state).thenReturn(
        const GoalsState(
          status: GoalsStatus.requestSuccess,
          fdaRDIs: rdis,
          // ignore: avoid_redundant_argument_values
          nutritionPreferences: preferences,
          formValues: <String, dynamic>{
            'date_of_birth': constants.testDateOfBirth
          },
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: RepositoryProvider.value(
              value: authRepository,
              child: BlocProvider.value(
                value: goalsCubit,
                child: const GoalsForm(),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.textContaining('Daily Nutrition Goals'), findsOneWidget);
    });
  });
}
