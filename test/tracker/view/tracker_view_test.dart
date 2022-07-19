import 'package:app_repository/app_repository.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/tracker/tracker.dart';

class MockUser extends Mock implements User {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockTrackerCubit extends MockCubit<TrackerState> implements TrackerCubit {
}

void main() {
  const tracker = Tracker(
    meals: [
      UserMealDisplay(
        externalId: constants.testUUID,
        mealType: constants.testMealType,
        mealDate: constants.testMealDate,
      )
    ],
    nutrients: Nutrients(
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

  late TrackerCubit trackerCubit;
  late AuthRepository authRepository;
  final date = DateTime.now();
  late User user;

  setUp(() {
    trackerCubit = MockTrackerCubit();
    authRepository = MockAuthRepository();

    when(() => trackerCubit.getTracker(date: any(named: 'date')))
        .thenAnswer((_) async {});
    user = MockUser();
    when(() => authRepository.user).thenAnswer(
      (_) => const Stream.empty(),
    );
    when(() => authRepository.currentUser).thenReturn(user);
    when(() => user.isNotEmpty).thenReturn(true);
    when(() => user.isEmpty).thenReturn(false);
    when(() => user.email).thenReturn(constants.testEmail);
    when(() => user.displayName).thenReturn(constants.testEmail);
  });

  group('TrackerView', () {
    testWidgets('renders TrackerCubit init state', (tester) async {
      when(() => trackerCubit.state).thenReturn(const TrackerState());
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: authRepository,
            child: BlocProvider.value(
              value: trackerCubit,
              child: const Scaffold(
                body: TrackerView(),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('request failure', (tester) async {
      when(() => trackerCubit.state).thenReturn(
        const TrackerState(
          status: TrackerStatus.requestFailure,
          errorMessage: 'error',
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: authRepository,
            child: BlocProvider.value(
              value: trackerCubit,
              child: const Scaffold(
                body: TrackerView(),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('tracker present', (tester) async {
      when(() => trackerCubit.state).thenReturn(
        TrackerState(
          status: TrackerStatus.requestSuccess,
          tracker: tracker,
          date: date,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: authRepository,
            child: BlocProvider.value(
              value: trackerCubit,
              child: const Scaffold(
                body: TrackerView(),
              ),
            ),
          ),
        ),
      );
      expect(find.text(constants.testMealType), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.textContaining('Welcome'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });
  });
}
