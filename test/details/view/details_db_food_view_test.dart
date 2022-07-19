import 'package:app_repository/app_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/details/details.dart';

class MockDetailsDBFoodCubit extends MockCubit<DetailsState>
    implements DetailsDBFoodCubit {}

class MockAppRepository extends Mock implements AppRepository {}

void main() {
  const dbFood = DBFood(
    externalId: constants.testUUID,
    name: constants.testFoodName,
    portions: [
      Portion(
        externalId: constants.testPortionExternalId,
        name: constants.testPortionName,
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
  late DetailsDBFoodCubit detailsCubit;

  setUp(() {
    appRepository = MockAppRepository();
    when(
      () => appRepository.logDBFood(
        externalId: any(named: 'externalId'),
        mealType: any(named: 'mealType'),
        mealDate: any(named: 'mealDate'),
        serving: any(named: 'serving'),
      ),
    ).thenAnswer((_) async {});

    detailsCubit = MockDetailsDBFoodCubit();
    when(() => detailsCubit.loadPageData(externalId: any(named: 'externalId')))
        .thenAnswer((_) async => dbFood);
  });

  group('DetailsDBFoodView', () {
    testWidgets('renders DetailsCubit init state', (tester) async {
      when(() => detailsCubit.state).thenReturn(const DetailsState());
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: detailsCubit,
              child: const DetailsDBFoodView(externalId: constants.testUUID),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('request failure', (tester) async {
      when(() => detailsCubit.state).thenReturn(
        const DetailsState(
          status: DetailsStatus.requestFailure,
          errorMessage: 'error',
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: detailsCubit,
              child: const DetailsDBFoodView(externalId: constants.testUUID),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('dbfood present', (tester) async {
      when(() => detailsCubit.state).thenReturn(
        DetailsState(
          status: DetailsStatus.requestSuccess,
          dbFood: dbFood,
          selectedPortion: dbFood.defaultPortion,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: detailsCubit,
              child: const DetailsDBFoodView(externalId: constants.testUUID),
            ),
          ),
        ),
      );
      expect(find.text(dbFood.name), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.textContaining('Brand'), findsNothing);
      expect(find.textContaining('Serving size'), findsOneWidget);
      expect(find.textContaining('Quantity'), findsOneWidget);
      expect(find.textContaining('Nutrition Facts'), findsOneWidget);
      expect(find.textContaining('Add to Kitchen'), findsOneWidget);
      expect(
        find.widgetWithIcon(IconButton, Icons.delete_forever_outlined),
        findsNothing,
      );
    });

    testWidgets('dbfood present with all values', (tester) async {
      const appDBFood = DBFood(
        externalId: constants.testUUID,
        name: constants.testFoodName,
        brand: Brand(
          brandName: constants.testBrandName,
          brandOwner: constants.testBrandOwner,
        ),
        portions: [
          Portion(
            externalId: constants.testPortionExternalId,
            name: constants.testPortionName,
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
        lfoodExternalId: constants.testUUID,
      );

      when(() => detailsCubit.state).thenReturn(
        DetailsState(
          status: DetailsStatus.requestSuccess,
          dbFood: appDBFood,
          selectedPortion: appDBFood.defaultPortion,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: detailsCubit,
              child: const DetailsDBFoodView(externalId: constants.testUUID),
            ),
          ),
        ),
      );

      expect(find.text(appDBFood.name), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(FloatingActionButton), findsNothing);
      expect(find.textContaining('Brand'), findsNWidgets(2));
      expect(find.textContaining('Serving size'), findsOneWidget);
      expect(find.textContaining('Quantity'), findsOneWidget);
      expect(
        find.textContaining('Nutrition Facts', skipOffstage: false),
        findsOneWidget,
      );
      expect(find.textContaining('Add to Kitchen'), findsNothing);
      expect(find.textContaining('Meal date'), findsOneWidget);
      expect(find.textContaining('Meal type'), findsOneWidget);
      expect(find.text('LOG'), findsOneWidget);
      expect(
        find.widgetWithIcon(IconButton, Icons.delete_forever_outlined),
        findsNothing,
      );
    });

    testWidgets('save dbfood success', (tester) async {
      when(() => detailsCubit.state).thenReturn(
        DetailsState(
          status: DetailsStatus.saveRequestSuccess,
          dbFood: dbFood,
          selectedPortion: dbFood.defaultPortion,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: detailsCubit,
              child: const DetailsDBFoodView(externalId: constants.testUUID),
            ),
          ),
        ),
      );
      expect(find.text(dbFood.name), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.textContaining('Brand'), findsNothing);
      expect(find.textContaining('Serving size'), findsOneWidget);
      expect(find.textContaining('Quantity'), findsOneWidget);
      expect(find.textContaining('Nutrition Facts'), findsOneWidget);
      expect(find.textContaining('Add to Kitchen'), findsNothing);
      expect(find.text('Added!'), findsOneWidget);
    });
  });
}
