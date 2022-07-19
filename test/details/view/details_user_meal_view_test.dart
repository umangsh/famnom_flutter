import 'package:app_repository/app_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/details/details.dart';

class MockDetailsUserMealCubit extends MockCubit<DetailsState>
    implements DetailsUserMealCubit {}

class MockAppRepository extends Mock implements AppRepository {}

void main() {
  const userMeal = UserMealDisplay(
    externalId: constants.testUUID,
    mealType: constants.testMealType,
    mealDate: constants.testMealDate,
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
    memberIngredients: [
      UserMemberIngredientDisplay(
        externalId: constants.testUUID,
        ingredient: UserIngredientDisplay(
          externalId: constants.testUUID,
          name: constants.testFoodName,
        ),
        portion: Portion(
          externalId: constants.testPortionExternalId,
          name: constants.testPortionName,
          servingSize: constants.testPortionSize,
          servingSizeUnit: constants.testPortionSizeUnit,
        ),
      )
    ],
    memberRecipes: [
      UserMemberRecipeDisplay(
        externalId: constants.testUUID,
        recipe: UserRecipeDisplay(
          externalId: constants.testUUID,
          name: constants.testRecipeName,
          recipeDate: constants.testRecipeDate,
        ),
        portion: Portion(
          externalId: constants.testPortionExternalId,
          name: constants.testPortionName,
          servingSize: constants.testPortionSize,
          servingSizeUnit: constants.testPortionSizeUnit,
        ),
      )
    ],
  );

  late AppRepository appRepository;
  late DetailsUserMealCubit detailsCubit;

  setUp(() {
    appRepository = MockAppRepository();
    detailsCubit = MockDetailsUserMealCubit();
    when(() => detailsCubit.loadPageData(externalId: any(named: 'externalId')))
        .thenAnswer((_) async => userMeal);
  });

  group('DetailsUserMealView', () {
    testWidgets('renders DetailsCubit init state', (tester) async {
      when(() => detailsCubit.state).thenReturn(const DetailsState());
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: detailsCubit,
              child: const DetailsUserMealView(
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
              child: const DetailsUserMealView(
                externalId: constants.testUUID,
              ),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('user meal present', (tester) async {
      when(() => detailsCubit.state).thenReturn(
        const DetailsState(
          status: DetailsStatus.requestSuccess,
          userMeal: userMeal,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: detailsCubit,
              child: const DetailsUserMealView(
                externalId: constants.testUUID,
              ),
            ),
          ),
        ),
      );
      expect(find.text(userMeal.mealType), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.textContaining('Nutrition Facts'), findsOneWidget);
      expect(find.text('Foods'), findsOneWidget);
      expect(find.text('Recipes'), findsOneWidget);
      expect(
        find.widgetWithIcon(IconButton, Icons.delete_forever_outlined),
        findsOneWidget,
      );
    });

    testWidgets('user meal present with all values', (tester) async {
      const appUserMeal = UserMealDisplay(
        externalId: constants.testUUID,
        mealType: constants.testMealType,
        mealDate: constants.testMealDate,
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
        memberIngredients: [
          UserMemberIngredientDisplay(
            externalId: constants.testUUID,
            ingredient: UserIngredientDisplay(
              externalId: constants.testUUID,
              name: constants.testFoodName,
            ),
            portion: Portion(
              externalId: constants.testPortionExternalId,
              name: constants.testPortionName,
              servingSize: constants.testPortionSize,
              servingSizeUnit: constants.testPortionSizeUnit,
            ),
          )
        ],
        memberRecipes: [
          UserMemberRecipeDisplay(
            externalId: constants.testUUID,
            recipe: UserRecipeDisplay(
              externalId: constants.testUUID,
              name: constants.testRecipeName,
              recipeDate: constants.testRecipeDate,
            ),
            portion: Portion(
              externalId: constants.testPortionExternalId,
              name: constants.testPortionName,
              servingSize: constants.testPortionSize,
              servingSizeUnit: constants.testPortionSizeUnit,
            ),
          )
        ],
      );

      when(() => detailsCubit.state).thenReturn(
        const DetailsState(
          status: DetailsStatus.requestSuccess,
          userMeal: appUserMeal,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: detailsCubit,
              child: const DetailsUserMealView(
                externalId: constants.testUUID,
              ),
            ),
          ),
        ),
      );

      expect(find.text(appUserMeal.mealType), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.textContaining('Nutrition Facts'), findsOneWidget);
      expect(find.text('Foods'), findsOneWidget);
      expect(find.text('Recipes'), findsOneWidget);
      expect(
        find.widgetWithIcon(IconButton, Icons.delete_forever_outlined),
        findsOneWidget,
      );
    });
  });
}
