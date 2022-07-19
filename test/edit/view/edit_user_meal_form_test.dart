import 'package:app_repository/app_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/edit/edit.dart';

class MockEditCubit extends MockCubit<EditUserMealState>
    implements EditUserMealCubit {}

class MockAppRepository extends Mock implements AppRepository {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  const userMeal = UserMealMutable(
    externalId: constants.testUUID,
    mealDate: constants.testMealDate,
    mealType: constants.testMealType,
  );

  late AppRepository appRepository;
  late EditUserMealCubit editCubit;

  setUp(() {
    appRepository = MockAppRepository();
    editCubit = MockEditCubit();
    when(() => editCubit.fetchUserMeal()).thenAnswer((_) async {});
    registerFallbackValue(FakeRoute());
  });

  group('EditUserMealForm', () {
    testWidgets('renders Form init state', (tester) async {
      when(() => editCubit.state).thenReturn(const EditUserMealState());
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: editCubit,
              child: const EditUserMealForm(),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders create form', (tester) async {
      when(() => editCubit.state).thenReturn(
        EditUserMealState(
          status: EditUserMealStatus.requestSuccess,
          appConstants: const AppConstants(),
          form: MealForm()
            ..ingredientMembers = []
            ..recipeMembers = [],
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: editCubit,
              child: const EditUserMealForm(),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Add Meal'), findsOneWidget);
      expect(find.text('Meal Type'), findsOneWidget);
      expect(find.text('Foods'), findsOneWidget);
      expect(find.text('Add Food'), findsOneWidget);
      expect(find.text('Recipes'), findsOneWidget);
      expect(find.text('Add Food'), findsOneWidget);
    });

    testWidgets('renders edit form', (tester) async {
      when(() => editCubit.state).thenReturn(
        EditUserMealState(
          status: EditUserMealStatus.requestSuccess,
          userMeal: userMeal,
          appConstants: const AppConstants(
            labelNutrients: {
              constants.ENERGY_NUTRIENT_ID: Nutrient(
                id: constants.ENERGY_NUTRIENT_ID,
                name: 'Calories (kcal)',
              ),
            },
          ),
          form: MealForm()
            ..userMeal = userMeal
            ..externalId = userMeal.externalId
            ..mealType = userMeal.mealType
            ..mealDate = userMeal.mealDate,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: editCubit,
              child: const EditUserMealForm(
                externalId: constants.testUUID,
              ),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Edit Meal'), findsOneWidget);
      expect(find.text('Meal Type'), findsOneWidget);
      expect(find.text(userMeal.mealType), findsOneWidget);
      expect(find.text('SAVE'), findsOneWidget);
    });

    testWidgets('request failure', (tester) async {
      when(() => editCubit.state).thenReturn(
        const EditUserMealState(
          status: EditUserMealStatus.requestFailure,
          errorMessage: 'error',
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: editCubit,
              child: const EditUserMealForm(),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('save request success', (tester) async {
      when(() => editCubit.state).thenReturn(
        const EditUserMealState(
          status: EditUserMealStatus.saveRequestSuccess,
          redirectExternalId: constants.testUUID,
        ),
      );
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [mockObserver],
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: editCubit,
              child: const EditUserMealForm(),
            ),
          ),
        ),
      );
      verify(() => mockObserver.didPush(any(), any())).called(1);
    });

    testWidgets('save request failure', (tester) async {
      when(() => editCubit.state).thenReturn(
        const EditUserMealState(
          status: EditUserMealStatus.saveRequestFailure,
          errorMessage: 'error',
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RepositoryProvider.value(
              value: appRepository,
              child: BlocProvider.value(
                value: editCubit,
                child: const EditUserMealForm(),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Add Meal'), findsOneWidget);
    });
  });
}
