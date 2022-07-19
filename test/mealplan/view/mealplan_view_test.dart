import 'package:app_repository/app_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/mealplan/mealplan.dart';

class MockMealplanCubit extends MockCubit<MealplanState>
    implements MealplanCubit {}

class MockAppRepository extends Mock implements AppRepository {}

void main() {
  late AppRepository appRepository;
  late MealplanCubit mealplanCubit;

  setUp(() {
    appRepository = MockAppRepository();
    mealplanCubit = MockMealplanCubit();
    when(() => mealplanCubit.loadItems()).thenAnswer((_) async {});
  });

  group('MealplanView', () {
    testWidgets('renders MealplanView init state', (tester) async {
      when(() => mealplanCubit.state).thenReturn(const MealplanState());
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: mealplanCubit,
              child: const MealplanView(),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('load request failure', (tester) async {
      when(() => mealplanCubit.state).thenReturn(
        const MealplanState(
          status: MealplanStatus.loadRequestFailure,
          errorMessage: 'error',
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: mealplanCubit,
              child: const MealplanView(),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('form rendered', (tester) async {
      when(() => mealplanCubit.state).thenReturn(
        MealplanState(
          status: MealplanStatus.loadRequestSuccess,
          formOne: MealplanFormOne(
            availableFoods: const [],
            availableRecipes: const [],
          ),
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: mealplanCubit,
              child: const Scaffold(body: MealplanView()),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Meal Planner'), findsOneWidget);
    });
  });
}
