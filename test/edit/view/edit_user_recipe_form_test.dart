import 'package:app_repository/app_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/edit/edit.dart';

class MockEditCubit extends MockCubit<EditUserRecipeState>
    implements EditUserRecipeCubit {}

class MockAppRepository extends Mock implements AppRepository {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route<dynamic> {}

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

  late AppRepository appRepository;
  late EditUserRecipeCubit editCubit;

  setUp(() {
    appRepository = MockAppRepository();
    editCubit = MockEditCubit();
    when(() => editCubit.fetchUserRecipe()).thenAnswer((_) async {});
    registerFallbackValue(FakeRoute());
  });

  group('EditUserRecipeForm', () {
    testWidgets('renders Form init state', (tester) async {
      when(() => editCubit.state).thenReturn(const EditUserRecipeState());
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: editCubit,
              child: const EditUserRecipeForm(),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders create form', (tester) async {
      when(() => editCubit.state).thenReturn(
        EditUserRecipeState(
          status: EditUserRecipeStatus.requestSuccess,
          appConstants: const AppConstants(),
          form: RecipeForm()
            ..ingredientMembers = []
            ..recipeMembers = []
            ..portions = [],
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: editCubit,
              child: const EditUserRecipeForm(),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Add Recipe'), findsNWidgets(2));
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Foods'), findsOneWidget);
      expect(find.text('Add Food'), findsOneWidget);
      expect(find.text('Recipes'), findsOneWidget);
      expect(find.text('Servings'), findsOneWidget);
    });

    testWidgets('renders edit form', (tester) async {
      when(() => editCubit.state).thenReturn(
        EditUserRecipeState(
          status: EditUserRecipeStatus.requestSuccess,
          userRecipe: userRecipe,
          appConstants: const AppConstants(
            labelNutrients: {
              constants.ENERGY_NUTRIENT_ID: Nutrient(
                id: constants.ENERGY_NUTRIENT_ID,
                name: 'Calories (kcal)',
              ),
            },
          ),
          form: RecipeForm()
            ..userRecipe = userRecipe
            ..externalId = userRecipe.externalId
            ..name = userRecipe.name
            ..recipeDate = userRecipe.recipeDate
            ..portions = [
              FoodPortionForm(
                id: constants.testPortionId,
                servingsPerContainer:
                    constants.testPortionServingsPerContainer.toString(),
              )
            ],
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: editCubit,
              child: const EditUserRecipeForm(
                externalId: constants.testUUID,
              ),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Edit Recipe'), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);
      expect(find.text(userRecipe.name), findsOneWidget);
      expect(find.text('Servings'), findsOneWidget);
      expect(
        find.text('Servings per container', skipOffstage: false),
        findsOneWidget,
      );
      expect(
        find.text(
          constants.testPortionServingsPerContainer.toString(),
          skipOffstage: false,
        ),
        findsOneWidget,
      );

      expect(find.text('SAVE'), findsOneWidget);
    });

    testWidgets('request failure', (tester) async {
      when(() => editCubit.state).thenReturn(
        const EditUserRecipeState(
          status: EditUserRecipeStatus.requestFailure,
          errorMessage: 'error',
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: editCubit,
              child: const EditUserRecipeForm(),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('save request success', (tester) async {
      when(() => editCubit.state).thenReturn(
        const EditUserRecipeState(
          status: EditUserRecipeStatus.saveRequestSuccess,
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
              child: const EditUserRecipeForm(),
            ),
          ),
        ),
      );
      verify(() => mockObserver.didPush(any(), any())).called(1);
    });

    testWidgets('save request failure', (tester) async {
      when(() => editCubit.state).thenReturn(
        const EditUserRecipeState(
          status: EditUserRecipeStatus.saveRequestFailure,
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
                child: const EditUserRecipeForm(),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Add Recipe'), findsNWidgets(2));
    });
  });
}
