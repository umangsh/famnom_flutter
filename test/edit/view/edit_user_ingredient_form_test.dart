import 'package:app_repository/app_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/edit/edit.dart';
import 'package:famnom_flutter/widgets/widgets.dart';
import 'package:search_repository/search_repository.dart';

class MockEditCubit extends MockCubit<EditUserIngredientState>
    implements EditUserIngredientCubit {}

class MockAppRepository extends Mock implements AppRepository {}

class MockSearchRepository extends Mock implements SearchRepository {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route<dynamic> {}

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

  late AppRepository appRepository;
  late SearchRepository searchRepository;
  late EditUserIngredientCubit editCubit;

  setUp(() {
    appRepository = MockAppRepository();
    searchRepository = MockSearchRepository();
    editCubit = MockEditCubit();
    when(() => editCubit.fetchUserIngredient()).thenAnswer((_) async {});
    registerFallbackValue(FakeRoute());
  });

  group('EditUserIngredientForm', () {
    testWidgets('renders Form init state', (tester) async {
      when(() => editCubit.state).thenReturn(const EditUserIngredientState());
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: RepositoryProvider.value(
              value: searchRepository,
              child: BlocProvider.value(
                value: editCubit,
                child: const EditUserIngredientForm(),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders create form', (tester) async {
      when(() => editCubit.state).thenReturn(
        EditUserIngredientState(
          status: EditUserIngredientStatus.requestSuccess,
          appConstants: const AppConstants(),
          form: FoodForm()
            ..nutrients = {}
            ..portions = [],
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: RepositoryProvider.value(
              value: searchRepository,
              child: BlocProvider.value(
                value: editCubit,
                child: const EditUserIngredientForm(),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Add Food'), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Servings'), findsOneWidget);
      expect(
        find.text('Servings per container', skipOffstage: false),
        findsOneWidget,
      );

      final expectedWidget =
          find.text('Nutrition details', skipOffstage: false);
      await tester.dragUntilVisible(
        expectedWidget,
        find.byType(ListView),
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Nutrition details', skipOffstage: false),
        findsOneWidget,
      );
      expect(
        find.text('per 100g serving', skipOffstage: false),
        findsOneWidget,
      );
      expect(find.text('SAVE'), findsOneWidget);
    });

    testWidgets('renders edit form', (tester) async {
      when(() => editCubit.state).thenReturn(
        EditUserIngredientState(
          status: EditUserIngredientStatus.requestSuccess,
          userIngredient: userIngredient,
          appConstants: const AppConstants(
            labelNutrients: {
              constants.ENERGY_NUTRIENT_ID: Nutrient(
                id: constants.ENERGY_NUTRIENT_ID,
                name: 'Calories (kcal)',
              ),
            },
          ),
          form: FoodForm()
            ..userIngredient = userIngredient
            ..externalId = userIngredient.externalId
            ..name = userIngredient.name
            ..nutrients = {
              constants.ENERGY_NUTRIENT_ID:
                  constants.testNutrientAmount.toString(),
            }
            ..portions = [
              FoodPortionForm(
                id: constants.testPortionId,
                servingsPerContainer:
                    constants.testPortionServingsPerContainer.toString(),
              )
            ],
          nutritionServing: '85g',
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: RepositoryProvider.value(
              value: searchRepository,
              child: BlocProvider.value(
                value: editCubit,
                child: const EditUserIngredientForm(
                  externalId: constants.testUUID,
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Edit Food'), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);
      expect(find.text(userIngredient.name), findsOneWidget);
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

      final expectedWidget =
          find.text('Nutrition details', skipOffstage: false);
      await tester.dragUntilVisible(
        expectedWidget,
        find.byType(ListView),
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Nutrition details', skipOffstage: false),
        findsOneWidget,
      );
      expect(
        find.text('per 85g serving', skipOffstage: false),
        findsOneWidget,
      );
      expect(
        find.text('Calories (kcal)', skipOffstage: false),
        findsOneWidget,
      );
      expect(
        find.text(constants.testNutrientAmount.toString(), skipOffstage: false),
        findsOneWidget,
      );
      expect(find.text('SAVE'), findsOneWidget);
    });

    testWidgets('request failure', (tester) async {
      when(() => editCubit.state).thenReturn(
        const EditUserIngredientState(
          status: EditUserIngredientStatus.requestFailure,
          errorMessage: 'error',
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: RepositoryProvider.value(
              value: searchRepository,
              child: BlocProvider.value(
                value: editCubit,
                child: const EditUserIngredientForm(),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders barcode request state', (tester) async {
      when(() => editCubit.state).thenReturn(
        const EditUserIngredientState(
          status: EditUserIngredientStatus.barcodeRequest,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: RepositoryProvider.value(
              value: searchRepository,
              child: BlocProvider.value(
                value: editCubit,
                child: const EditUserIngredientForm(),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(EditScanner), findsOneWidget);
    });

    testWidgets('renders barcode cancelled state', (tester) async {
      when(() => editCubit.state).thenReturn(
        const EditUserIngredientState(
          status: EditUserIngredientStatus.barcodeCancelled,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: RepositoryProvider.value(
              value: searchRepository,
              child: BlocProvider.value(
                value: editCubit,
                child: const EditUserIngredientForm(),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(EditScanner), findsNothing);
    });

    testWidgets('renders barcode found state', (tester) async {
      when(() => editCubit.state).thenReturn(
        const EditUserIngredientState(
          status: EditUserIngredientStatus.barcodeFound,
          redirectExternalId: constants.testUUID,
        ),
      );
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [mockObserver],
          home: RepositoryProvider.value(
            value: appRepository,
            child: RepositoryProvider.value(
              value: searchRepository,
              child: BlocProvider.value(
                value: editCubit,
                child: const EditUserIngredientForm(),
              ),
            ),
          ),
        ),
      );
      verify(() => mockObserver.didPush(any(), any())).called(1);
    });

    testWidgets('renders barcode not found or failed state', (tester) async {
      when(() => editCubit.state).thenReturn(
        EditUserIngredientState(
          status: EditUserIngredientStatus.barcodeNotFoundOrFailed,
          form: FoodForm()..gtinUpc = 'barcode',
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: RepositoryProvider.value(
              value: searchRepository,
              child: BlocProvider.value(
                value: editCubit,
                child: const EditUserIngredientForm(),
              ),
            ),
          ),
        ),
      );
      expect(find.text('Add Food'), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('barcode'), findsOneWidget);
    });

    testWidgets('save request success', (tester) async {
      when(() => editCubit.state).thenReturn(
        const EditUserIngredientState(
          status: EditUserIngredientStatus.saveRequestSuccess,
          redirectExternalId: constants.testUUID,
        ),
      );
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [mockObserver],
          home: RepositoryProvider.value(
            value: appRepository,
            child: RepositoryProvider.value(
              value: searchRepository,
              child: BlocProvider.value(
                value: editCubit,
                child: const EditUserIngredientForm(),
              ),
            ),
          ),
        ),
      );
      verify(() => mockObserver.didPush(any(), any())).called(1);
    });

    testWidgets('save request failure', (tester) async {
      when(() => editCubit.state).thenReturn(
        const EditUserIngredientState(
          status: EditUserIngredientStatus.saveRequestFailure,
          errorMessage: 'error',
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RepositoryProvider.value(
              value: appRepository,
              child: RepositoryProvider.value(
                value: searchRepository,
                child: BlocProvider.value(
                  value: editCubit,
                  child: const EditUserIngredientForm(),
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Add Food'), findsOneWidget);
    });
  });
}
