import 'package:app_repository/app_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/details/details.dart';

class MockDetailsUserRecipeCubit extends MockCubit<DetailsState>
    implements DetailsUserRecipeCubit {}

class MockAppRepository extends Mock implements AppRepository {}

void main() {
  const userRecipe = UserRecipeDisplay(
    externalId: constants.testUUID,
    name: constants.testRecipeName,
    recipeDate: constants.testRecipeDate,
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
  late DetailsUserRecipeCubit detailsCubit;

  setUp(() {
    appRepository = MockAppRepository();
    when(
      () => appRepository.logUserRecipe(
        externalId: any(named: 'externalId'),
        mealType: any(named: 'mealType'),
        mealDate: any(named: 'mealDate'),
        serving: any(named: 'serving'),
      ),
    ).thenAnswer((_) async {});

    detailsCubit = MockDetailsUserRecipeCubit();
    when(() => detailsCubit.loadPageData(externalId: any(named: 'externalId')))
        .thenAnswer((_) async => userRecipe);
  });

  group('DetailsUserRecipeView', () {
    testWidgets('renders DetailsCubit init state', (tester) async {
      when(() => detailsCubit.state).thenReturn(const DetailsState());
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: detailsCubit,
              child: const DetailsUserRecipeView(
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
              child: const DetailsUserRecipeView(
                externalId: constants.testUUID,
              ),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('user recipe present', (tester) async {
      when(() => detailsCubit.state).thenReturn(
        DetailsState(
          status: DetailsStatus.requestSuccess,
          userRecipe: userRecipe,
          selectedPortion: userRecipe.defaultPortion,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: detailsCubit,
              child: const DetailsUserRecipeView(
                externalId: constants.testUUID,
              ),
            ),
          ),
        ),
      );
      expect(find.text(userRecipe.name), findsNWidgets(2));
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.textContaining('Serving size'), findsOneWidget);
      expect(find.textContaining('Quantity'), findsOneWidget);
      expect(
        find.textContaining('Nutrition Facts', skipOffstage: false),
        findsOneWidget,
      );
      expect(find.text('Foods'), findsOneWidget);
      expect(find.text('Recipes'), findsOneWidget);
      expect(
        find.widgetWithIcon(IconButton, Icons.delete_forever_outlined),
        findsOneWidget,
      );
    });

    testWidgets('user recipe present with all values', (tester) async {
      const appUserRecipe = UserRecipeDisplay(
        externalId: constants.testUUID,
        name: constants.testRecipeName,
        recipeDate: constants.testRecipeDate,
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
        DetailsState(
          status: DetailsStatus.requestSuccess,
          userRecipe: appUserRecipe,
          selectedPortion: appUserRecipe.defaultPortion,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider.value(
            value: appRepository,
            child: BlocProvider.value(
              value: detailsCubit,
              child: const DetailsUserRecipeView(
                externalId: constants.testUUID,
              ),
            ),
          ),
        ),
      );

      expect(find.text(appUserRecipe.name), findsNWidgets(2));
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.textContaining('Serving size'), findsOneWidget);
      expect(find.textContaining('Quantity'), findsOneWidget);
      expect(find.textContaining('Meal date'), findsOneWidget);
      expect(find.textContaining('Meal type'), findsOneWidget);
      expect(
        find.textContaining('Nutrition Facts', skipOffstage: false),
        findsOneWidget,
      );
      expect(find.text('Foods'), findsOneWidget);
      expect(find.text('Recipes'), findsOneWidget);
      expect(find.text('LOG'), findsOneWidget);
      expect(
        find.widgetWithIcon(IconButton, Icons.delete_forever_outlined),
        findsOneWidget,
      );
    });
  });
}
