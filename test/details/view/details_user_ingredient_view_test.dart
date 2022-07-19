import 'package:app_repository/app_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/details/details.dart';

class MockDetailsUserIngredientCubit extends MockCubit<DetailsState>
    implements DetailsUserIngredientCubit {}

class MockAppRepository extends Mock implements AppRepository {}

void main() {
  const userIngredient = UserIngredientDisplay(
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
  late DetailsUserIngredientCubit detailsCubit;

  setUp(() {
    appRepository = MockAppRepository();
    when(
      () => appRepository.logUserIngredient(
        externalId: any(named: 'externalId'),
        mealType: any(named: 'mealType'),
        mealDate: any(named: 'mealDate'),
        serving: any(named: 'serving'),
      ),
    ).thenAnswer((_) async {});

    detailsCubit = MockDetailsUserIngredientCubit();
    when(() => detailsCubit.loadPageData(externalId: any(named: 'externalId')))
        .thenAnswer((_) async => userIngredient);
  });

  group('DetailsUserIngredientView', () {
    testWidgets('renders DetailsCubit init state', (tester) async {
      when(() => detailsCubit.state).thenReturn(const DetailsState());
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: detailsCubit,
              child: const DetailsUserIngredientView(
                externalId: constants.testUUID,
              ),
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
              child: const DetailsUserIngredientView(
                externalId: constants.testUUID,
              ),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('user ingredient present', (tester) async {
      when(() => detailsCubit.state).thenReturn(
        DetailsState(
          status: DetailsStatus.requestSuccess,
          userIngredient: userIngredient,
          selectedPortion: userIngredient.defaultPortion,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: detailsCubit,
              child: const DetailsUserIngredientView(
                externalId: constants.testUUID,
              ),
            ),
          ),
        ),
      );
      expect(find.text(userIngredient.name), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.textContaining('Brand'), findsNothing);
      expect(find.textContaining('Serving size'), findsOneWidget);
      expect(find.textContaining('Quantity'), findsOneWidget);
      expect(find.textContaining('Nutrition Facts'), findsOneWidget);
      expect(find.textContaining('Add to Kitchen'), findsNothing);
      expect(
        find.widgetWithIcon(IconButton, Icons.delete_forever_outlined),
        findsOneWidget,
      );
    });

    testWidgets('user ingredient present with all values', (tester) async {
      const appUserIngredient = UserIngredientDisplay(
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
        category: constants.testCategoryName,
      );

      when(() => detailsCubit.state).thenReturn(
        DetailsState(
          status: DetailsStatus.requestSuccess,
          userIngredient: appUserIngredient,
          selectedPortion: appUserIngredient.defaultPortion,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: detailsCubit,
              child: const DetailsUserIngredientView(
                externalId: constants.testUUID,
              ),
            ),
          ),
        ),
      );

      expect(find.text(appUserIngredient.name), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(FloatingActionButton), findsOneWidget);
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
        findsOneWidget,
      );
    });
  });
}
