import 'package:app_repository/app_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:environments/environment.dart';
import 'package:famnom_api/famnom_api.dart' as famnom_api;
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

class MockFamnomApiClient extends Mock implements famnom_api.FamnomApiClient {}

class MockFamnomApiFdaRdiResponse extends Mock
    implements famnom_api.FdaRdiResponse {}

class MockFamnomApiAuthToken extends Mock implements famnom_api.AuthToken {}

void main() {
  const testDBFood = DBFood(
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

  const testUserIngredient = UserIngredientDisplay(
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

  const testUserRecipe = UserRecipeDisplay(
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
      )
    ],
    memberRecipes: [
      UserMemberRecipeDisplay(
        externalId: constants.testUUID,
        recipe: UserRecipeDisplay(
          externalId: constants.testUUID,
          name: constants.testFoodName,
        ),
      )
    ],
  );

  const testUserMeal = UserMealDisplay(
    externalId: constants.testUUID,
    mealDate: constants.testMealDate,
    mealType: constants.testMealType,
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
      )
    ],
    memberRecipes: [
      UserMemberRecipeDisplay(
        externalId: constants.testUUID,
        recipe: UserRecipeDisplay(
          externalId: constants.testUUID,
          name: constants.testFoodName,
        ),
      )
    ],
  );

  group('AppRepository', () {
    late famnom_api.FamnomApiClient famnomApiClient;
    late AppRepository appRepository;

    setUpAll(() {
      Environment().initConfig(Environment.dev);
    });

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      famnomApiClient = MockFamnomApiClient();
      appRepository = AppRepository(
        famnomApiClient: famnomApiClient,
      );
    });

    group('constructor', () {
      test('instantiates FamnomApiClient when not injected', () {
        expect(AppRepository(), isNotNull);
      });
    });

    group('getDBFood', () {
      test('calls with key', () async {
        try {
          await appRepository.getDBFood(constants.testUUID);
        } catch (_) {}
        verify(
          () => famnomApiClient.getDBFood(any(), any()),
        ).called(1);
      });

      test('throws when db food request fails', () async {
        final exception = famnom_api.getDBFoodFailedGeneric();
        when(() => famnomApiClient.getDBFood(any(), any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.getDBFood(constants.testUUID),
          throwsA(
            predicate(
              (x) =>
                  x is GetDBFoodFailure &&
                  x.message ==
                      'Can not find requested food. Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(() => famnomApiClient.getDBFood(any(), any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.getDBFood(constants.testUUID),
          throwsA(
            predicate(
              (x) =>
                  x is GetDBFoodFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });

      test('throws when db food not found', () async {
        final exception = famnom_api.dbFoodNotFound();
        when(() => famnomApiClient.getDBFood(any(), any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.getDBFood(constants.testUUID),
          throwsA(
            predicate(
              (x) => x is GetDBFoodFailure && x.message == 'Food not found.',
            ),
          ),
        );
      });

      test('returns correct dbfood on success', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          constants.prefAuthToken,
          constants.testAuthTokenKey,
        );

        const famnomApiDBfood = famnom_api.DBFood(
          externalId: constants.testUUID,
          description: constants.testFoodName,
          portions: [
            famnom_api.Portion(
              externalId: constants.testPortionExternalId,
              name: constants.testPortionName,
              servingSize: constants.testPortionSize,
              servingSizeUnit: constants.testPortionSizeUnit,
            ),
          ],
          nutrients: famnom_api.Nutrients(
            servingSize: constants.testNutrientServingSize,
            servingSizeUnit: constants.testNutrientServingSizeUnit,
            values: [
              famnom_api.Nutrient(
                id: constants.testNutrientId,
                name: constants.testNutrientName,
                amount: constants.testNutrientAmount,
                unit: constants.testNutrientUnit,
              )
            ],
          ),
        );

        when(
          () => famnomApiClient.getDBFood(
            constants.testAuthTokenKey,
            constants.testUUID,
          ),
        ).thenAnswer(
          (_) async => famnomApiDBfood,
        );

        final dbFood = await appRepository.getDBFood(constants.testUUID);
        expect(dbFood, equals(testDBFood));
      });
    });

    group('getUserIngredient', () {
      test('calls with key', () async {
        try {
          await appRepository.getUserIngredient(constants.testUUID);
        } catch (_) {}
        verify(
          () => famnomApiClient.getUserIngredient(any(), any()),
        ).called(1);
      });

      test('throws when user ingredient request fails', () async {
        final exception = famnom_api.getUserIngredientFailedGeneric();
        when(() => famnomApiClient.getUserIngredient(any(), any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.getUserIngredient(constants.testUUID),
          throwsA(
            predicate(
              (x) =>
                  x is GetUserIngredientFailure &&
                  x.message ==
                      'Can not find requested food. Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(() => famnomApiClient.getUserIngredient(any(), any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.getUserIngredient(constants.testUUID),
          throwsA(
            predicate(
              (x) =>
                  x is GetUserIngredientFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });

      test('throws when user ingredient not found', () async {
        final exception = famnom_api.userIngredientNotFound();
        when(() => famnomApiClient.getUserIngredient(any(), any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.getUserIngredient(constants.testUUID),
          throwsA(
            predicate(
              (x) =>
                  x is GetUserIngredientFailure &&
                  x.message == 'Food not found.',
            ),
          ),
        );
      });

      test('returns correct user ingredient on success', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          constants.prefAuthToken,
          constants.testAuthTokenKey,
        );

        const famnomApiUserIngredient = famnom_api.UserIngredientDisplay(
          externalId: constants.testUUID,
          name: constants.testFoodName,
          portions: [
            famnom_api.Portion(
              externalId: constants.testPortionExternalId,
              name: constants.testPortionName,
              servingSize: constants.testPortionSize,
              servingSizeUnit: constants.testPortionSizeUnit,
            ),
          ],
          nutrients: famnom_api.Nutrients(
            servingSize: constants.testNutrientServingSize,
            servingSizeUnit: constants.testNutrientServingSizeUnit,
            values: [
              famnom_api.Nutrient(
                id: constants.testNutrientId,
                name: constants.testNutrientName,
                amount: constants.testNutrientAmount,
                unit: constants.testNutrientUnit,
              )
            ],
          ),
        );

        when(
          () => famnomApiClient.getUserIngredient(
            constants.testAuthTokenKey,
            constants.testUUID,
          ),
        ).thenAnswer(
          (_) async => famnomApiUserIngredient,
        );

        final userIngredient =
            await appRepository.getUserIngredient(constants.testUUID);
        expect(userIngredient, equals(testUserIngredient));
      });
    });

    group('getMutableUserIngredient', () {
      test('calls with key', () async {
        try {
          await appRepository.getMutableUserIngredient(
            externalId: constants.testUUID,
          );
        } catch (_) {}
        verify(
          () => famnomApiClient.getMutableUserIngredient(
            key: any(named: 'key'),
            externalId: any(named: 'externalId'),
          ),
        ).called(1);
      });

      test('throws when user ingredient request fails', () async {
        final exception = famnom_api.getUserIngredientFailedGeneric();
        when(
          () => famnomApiClient.getMutableUserIngredient(
            key: any(named: 'key'),
            externalId: any(named: 'externalId'),
          ),
        ).thenThrow(exception);
        expect(
          () async => appRepository.getMutableUserIngredient(
            externalId: constants.testUUID,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is GetUserIngredientFailure &&
                  x.message ==
                      'Can not find requested food. Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(
          () => famnomApiClient.getMutableUserIngredient(
            key: any(named: 'key'),
            externalId: any(named: 'externalId'),
          ),
        ).thenThrow(exception);
        expect(
          () async => appRepository.getMutableUserIngredient(
            externalId: constants.testUUID,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is GetUserIngredientFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });

      test('throws when user ingredient not found', () async {
        final exception = famnom_api.userIngredientNotFound();
        when(
          () => famnomApiClient.getMutableUserIngredient(
            key: any(named: 'key'),
            externalId: any(named: 'externalId'),
          ),
        ).thenThrow(exception);
        expect(
          () async => appRepository.getMutableUserIngredient(
            externalId: constants.testUUID,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is GetUserIngredientFailure &&
                  x.message == 'Food not found.',
            ),
          ),
        );
      });

      test('returns correct user ingredient on success', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          constants.prefAuthToken,
          constants.testAuthTokenKey,
        );

        const famnomApiUserIngredient = famnom_api.UserIngredientMutable(
          externalId: constants.testUUID,
          name: constants.testFoodName,
          portions: [
            famnom_api.UserFoodPortion(
              id: constants.testPortionId,
              externalId: constants.testPortionExternalId,
              servingSize: constants.testPortionSize,
              servingSizeUnit: constants.testPortionSizeUnit,
            ),
          ],
          nutrients: famnom_api.Nutrients(
            servingSize: constants.testNutrientServingSize,
            servingSizeUnit: constants.testNutrientServingSizeUnit,
            values: [
              famnom_api.Nutrient(
                id: constants.testNutrientId,
                name: constants.testNutrientName,
                amount: constants.testNutrientAmount,
                unit: constants.testNutrientUnit,
              )
            ],
          ),
        );

        const appUserIngredient = UserIngredientMutable(
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

        when(
          () => famnomApiClient.getMutableUserIngredient(
            key: constants.testAuthTokenKey,
            externalId: constants.testUUID,
          ),
        ).thenAnswer(
          (_) async => famnomApiUserIngredient,
        );

        final userIngredient = await appRepository.getMutableUserIngredient(
          externalId: constants.testUUID,
        );
        expect(userIngredient, equals(appUserIngredient));
      });
    });

    group('getUserRecipe', () {
      test('calls with key', () async {
        try {
          await appRepository.getUserRecipe(constants.testUUID);
        } catch (_) {}
        verify(
          () => famnomApiClient.getUserRecipe(any(), any()),
        ).called(1);
      });

      test('throws when user recipe request fails', () async {
        final exception = famnom_api.getUserRecipeFailedGeneric();
        when(() => famnomApiClient.getUserRecipe(any(), any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.getUserRecipe(constants.testUUID),
          throwsA(
            predicate(
              (x) =>
                  x is GetUserRecipeFailure &&
                  x.message ==
                      'Can not find requested recipe. Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(() => famnomApiClient.getUserRecipe(any(), any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.getUserRecipe(constants.testUUID),
          throwsA(
            predicate(
              (x) =>
                  x is GetUserRecipeFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });

      test('throws when user recipe not found', () async {
        final exception = famnom_api.userRecipeNotFound();
        when(() => famnomApiClient.getUserRecipe(any(), any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.getUserRecipe(constants.testUUID),
          throwsA(
            predicate(
              (x) =>
                  x is GetUserRecipeFailure && x.message == 'Recipe not found.',
            ),
          ),
        );
      });

      test('returns correct user recipe on success', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          constants.prefAuthToken,
          constants.testAuthTokenKey,
        );

        const famnomApiUserRecipe = famnom_api.UserRecipeDisplay(
          externalId: constants.testUUID,
          name: constants.testRecipeName,
          recipeDate: constants.testRecipeDate,
          portions: [
            famnom_api.Portion(
              externalId: constants.testPortionExternalId,
              name: constants.testPortionName,
              servingSize: constants.testPortionSize,
              servingSizeUnit: constants.testPortionSizeUnit,
            ),
          ],
          nutrients: famnom_api.Nutrients(
            servingSize: constants.testNutrientServingSize,
            servingSizeUnit: constants.testNutrientServingSizeUnit,
            values: [
              famnom_api.Nutrient(
                id: constants.testNutrientId,
                name: constants.testNutrientName,
                amount: constants.testNutrientAmount,
                unit: constants.testNutrientUnit,
              )
            ],
          ),
          memberIngredients: [
            famnom_api.UserMemberIngredientDisplay(
              externalId: constants.testUUID,
              displayIngredient: famnom_api.UserIngredientDisplay(
                externalId: constants.testUUID,
                name: constants.testFoodName,
              ),
            )
          ],
          memberRecipes: [
            famnom_api.UserMemberRecipeDisplay(
              externalId: constants.testUUID,
              displayRecipe: famnom_api.UserRecipeDisplay(
                externalId: constants.testUUID,
                name: constants.testFoodName,
              ),
            )
          ],
        );

        when(
          () => famnomApiClient.getUserRecipe(
            constants.testAuthTokenKey,
            constants.testUUID,
          ),
        ).thenAnswer(
          (_) async => famnomApiUserRecipe,
        );

        final userRecipe =
            await appRepository.getUserRecipe(constants.testUUID);
        expect(userRecipe, equals(testUserRecipe));
      });
    });

    group('getMutableUserRecipe', () {
      test('calls with key', () async {
        try {
          await appRepository.getMutableUserRecipe(
            externalId: constants.testUUID,
          );
        } catch (_) {}
        verify(
          () => famnomApiClient.getMutableUserRecipe(
            key: any(named: 'key'),
            externalId: any(named: 'externalId'),
          ),
        ).called(1);
      });

      test('throws when user recipe request fails', () async {
        final exception = famnom_api.getUserRecipeFailedGeneric();
        when(
          () => famnomApiClient.getMutableUserRecipe(
            key: any(named: 'key'),
            externalId: any(named: 'externalId'),
          ),
        ).thenThrow(exception);
        expect(
          () async => appRepository.getMutableUserRecipe(
            externalId: constants.testUUID,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is GetUserRecipeFailure &&
                  x.message ==
                      'Can not find requested recipe. Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(
          () => famnomApiClient.getMutableUserRecipe(
            key: any(named: 'key'),
            externalId: any(named: 'externalId'),
          ),
        ).thenThrow(exception);
        expect(
          () async => appRepository.getMutableUserRecipe(
            externalId: constants.testUUID,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is GetUserRecipeFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });

      test('throws when user recipe not found', () async {
        final exception = famnom_api.userRecipeNotFound();
        when(
          () => famnomApiClient.getMutableUserRecipe(
            key: any(named: 'key'),
            externalId: any(named: 'externalId'),
          ),
        ).thenThrow(exception);
        expect(
          () async => appRepository.getMutableUserRecipe(
            externalId: constants.testUUID,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is GetUserRecipeFailure && x.message == 'Recipe not found.',
            ),
          ),
        );
      });

      test('returns correct user recipe on success', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          constants.prefAuthToken,
          constants.testAuthTokenKey,
        );

        const famnomApiUserRecipe = famnom_api.UserRecipeMutable(
          externalId: constants.testUUID,
          name: constants.testRecipeName,
          recipeDate: constants.testRecipeDate,
        );

        const appUserRecipe = UserRecipeMutable(
          externalId: constants.testUUID,
          name: constants.testRecipeName,
          recipeDate: constants.testRecipeDate,
        );

        when(
          () => famnomApiClient.getMutableUserRecipe(
            key: constants.testAuthTokenKey,
            externalId: constants.testUUID,
          ),
        ).thenAnswer(
          (_) async => famnomApiUserRecipe,
        );

        final userRecipe = await appRepository.getMutableUserRecipe(
          externalId: constants.testUUID,
        );
        expect(userRecipe, equals(appUserRecipe));
      });
    });

    group('getUserMeal', () {
      test('calls with key', () async {
        try {
          await appRepository.getUserMeal(constants.testUUID);
        } catch (_) {}
        verify(
          () => famnomApiClient.getUserMeal(any(), any()),
        ).called(1);
      });

      test('throws when user meal request fails', () async {
        final exception = famnom_api.getUserMealFailedGeneric();
        when(() => famnomApiClient.getUserMeal(any(), any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.getUserMeal(constants.testUUID),
          throwsA(
            predicate(
              (x) =>
                  x is GetUserMealFailure &&
                  x.message ==
                      'Can not find requested meal. Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(() => famnomApiClient.getUserMeal(any(), any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.getUserMeal(constants.testUUID),
          throwsA(
            predicate(
              (x) =>
                  x is GetUserMealFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });

      test('throws when user meal not found', () async {
        final exception = famnom_api.userMealNotFound();
        when(() => famnomApiClient.getUserMeal(any(), any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.getUserMeal(constants.testUUID),
          throwsA(
            predicate(
              (x) => x is GetUserMealFailure && x.message == 'Meal not found.',
            ),
          ),
        );
      });

      test('returns correct user meal on success', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          constants.prefAuthToken,
          constants.testAuthTokenKey,
        );

        const famnomApiUserMeal = famnom_api.UserMealDisplay(
          externalId: constants.testUUID,
          mealDate: constants.testMealDate,
          mealType: constants.testMealType,
          nutrients: famnom_api.Nutrients(
            servingSize: constants.testNutrientServingSize,
            servingSizeUnit: constants.testNutrientServingSizeUnit,
            values: [
              famnom_api.Nutrient(
                id: constants.testNutrientId,
                name: constants.testNutrientName,
                amount: constants.testNutrientAmount,
                unit: constants.testNutrientUnit,
              )
            ],
          ),
          memberIngredients: [
            famnom_api.UserMemberIngredientDisplay(
              externalId: constants.testUUID,
              displayIngredient: famnom_api.UserIngredientDisplay(
                externalId: constants.testUUID,
                name: constants.testFoodName,
              ),
            )
          ],
          memberRecipes: [
            famnom_api.UserMemberRecipeDisplay(
              externalId: constants.testUUID,
              displayRecipe: famnom_api.UserRecipeDisplay(
                externalId: constants.testUUID,
                name: constants.testFoodName,
              ),
            )
          ],
        );

        when(
          () => famnomApiClient.getUserMeal(
            constants.testAuthTokenKey,
            constants.testUUID,
          ),
        ).thenAnswer(
          (_) async => famnomApiUserMeal,
        );

        final userMeal = await appRepository.getUserMeal(constants.testUUID);
        expect(userMeal, equals(testUserMeal));
      });
    });

    group('getMutableUserMeal', () {
      test('calls with key', () async {
        try {
          await appRepository.getMutableUserMeal(
            externalId: constants.testUUID,
          );
        } catch (_) {}
        verify(
          () => famnomApiClient.getMutableUserMeal(
            key: any(named: 'key'),
            externalId: any(named: 'externalId'),
          ),
        ).called(1);
      });

      test('throws when user meal request fails', () async {
        final exception = famnom_api.getUserMealFailedGeneric();
        when(
          () => famnomApiClient.getMutableUserMeal(
            key: any(named: 'key'),
            externalId: any(named: 'externalId'),
          ),
        ).thenThrow(exception);
        expect(
          () async => appRepository.getMutableUserMeal(
            externalId: constants.testUUID,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is GetUserMealFailure &&
                  x.message ==
                      'Can not find requested meal. Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(
          () => famnomApiClient.getMutableUserMeal(
            key: any(named: 'key'),
            externalId: any(named: 'externalId'),
          ),
        ).thenThrow(exception);
        expect(
          () async => appRepository.getMutableUserMeal(
            externalId: constants.testUUID,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is GetUserMealFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });

      test('throws when user meal not found', () async {
        final exception = famnom_api.userMealNotFound();
        when(
          () => famnomApiClient.getMutableUserMeal(
            key: any(named: 'key'),
            externalId: any(named: 'externalId'),
          ),
        ).thenThrow(exception);
        expect(
          () async => appRepository.getMutableUserMeal(
            externalId: constants.testUUID,
          ),
          throwsA(
            predicate(
              (x) => x is GetUserMealFailure && x.message == 'Meal not found.',
            ),
          ),
        );
      });

      test('returns correct user meal on success', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          constants.prefAuthToken,
          constants.testAuthTokenKey,
        );

        const famnomApiUserMeal = famnom_api.UserMealMutable(
          externalId: constants.testUUID,
          mealType: constants.testMealType,
          mealDate: constants.testMealDate,
        );

        const appUserMeal = UserMealMutable(
          externalId: constants.testUUID,
          mealType: constants.testMealType,
          mealDate: constants.testMealDate,
        );

        when(
          () => famnomApiClient.getMutableUserMeal(
            key: constants.testAuthTokenKey,
            externalId: constants.testUUID,
          ),
        ).thenAnswer(
          (_) async => famnomApiUserMeal,
        );

        final userMeal = await appRepository.getMutableUserMeal(
          externalId: constants.testUUID,
        );
        expect(userMeal, equals(appUserMeal));
      });
    });

    group('getAppConstants', () {
      test('calls with key', () async {
        try {
          await appRepository.getAppConstants();
        } catch (_) {}
        verify(
          () => famnomApiClient.getAppConstants(any()),
        ).called(1);
      });

      test('throws when request fails', () async {
        final exception = famnom_api.getAppConstantsFailedGeneric();
        when(() => famnomApiClient.getAppConstants(any())).thenThrow(exception);
        expect(
          () async => appRepository.getAppConstants(),
          throwsA(
            predicate(
              (x) =>
                  x is GetAppConstantsFailure &&
                  x.message ==
                      'Can not initialize the app, some features may not work '
                          'as expected. Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(() => famnomApiClient.getAppConstants(any())).thenThrow(exception);
        expect(
          () async => appRepository.getAppConstants(),
          throwsA(
            predicate(
              (x) =>
                  x is GetAppConstantsFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });

      test('returns config on success', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          constants.prefAuthToken,
          constants.testAuthTokenKey,
        );

        when(
          () => famnomApiClient.getAppConstants(constants.testAuthTokenKey),
        ).thenAnswer(
          (_) async => const famnom_api.AppConstants(),
        );

        final config = await appRepository.getAppConstants();
        expect(
          config,
          equals(const AppConstants()),
        );
      });
    });

    group('getConfigNutrition', () {
      test('calls with key', () async {
        try {
          await appRepository.getConfigNutrition();
        } catch (_) {}
        verify(
          () => famnomApiClient.getConfigNutrition(any()),
        ).called(1);
      });

      test('throws when request fails', () async {
        final exception = famnom_api.getConfigNutritionFailedGeneric();
        when(() => famnomApiClient.getConfigNutrition(any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.getConfigNutrition(),
          throwsA(
            predicate(
              (x) =>
                  x is GetConfigNutritionFailure &&
                  x.message ==
                      'Can not find requested nutrition config. '
                          'Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(() => famnomApiClient.getConfigNutrition(any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.getConfigNutrition(),
          throwsA(
            predicate(
              (x) =>
                  x is GetConfigNutritionFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });

      test('returns config on success', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          constants.prefAuthToken,
          constants.testAuthTokenKey,
        );

        final famnomFdaRdiResponse = MockFamnomApiFdaRdiResponse();
        when(() => famnomFdaRdiResponse.results).thenReturn({
          famnom_api.FDAGroup.adult: {
            '${constants.testNutrientId}': const famnom_api.FdaRdi(
              value: constants.testNutrientAmount,
              threshold: famnom_api.Threshold.min,
              name: constants.testNutrientName,
              unit: constants.testNutrientUnit,
            )
          },
        });
        when(
          () => famnomApiClient.getConfigNutrition(constants.testAuthTokenKey),
        ).thenAnswer(
          (_) async => famnomFdaRdiResponse,
        );

        final config = await appRepository.getConfigNutrition();
        expect(
          config,
          equals({
            FDAGroup.adult: {
              constants.testNutrientId: const FdaRdi(
                id: constants.testNutrientId,
                name: constants.testNutrientName,
                value: constants.testNutrientAmount,
                unit: constants.testNutrientUnit,
                threshold: Threshold.min,
              )
            }
          }),
        );
      });
    });

    group('getConfigNutritionLabel', () {
      test('calls with key', () async {
        try {
          await appRepository.getConfigNutritionLabel();
        } catch (_) {}
        verify(
          () => famnomApiClient.getConfigNutritionLabel(any()),
        ).called(1);
      });

      test('throws when request fails', () async {
        final exception = famnom_api.getConfigNutritionLabelFailedGeneric();
        when(() => famnomApiClient.getConfigNutritionLabel(any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.getConfigNutritionLabel(),
          throwsA(
            predicate(
              (x) =>
                  x is GetConfigNutritionLabelFailure &&
                  x.message ==
                      'Can not find requested nutrition label config. '
                          'Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(() => famnomApiClient.getConfigNutritionLabel(any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.getConfigNutritionLabel(),
          throwsA(
            predicate(
              (x) =>
                  x is GetConfigNutritionLabelFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });

      test('returns config on success', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          constants.prefAuthToken,
          constants.testAuthTokenKey,
        );

        final famnomFdaRdiResponse = MockFamnomApiFdaRdiResponse();
        when(() => famnomFdaRdiResponse.results).thenReturn({
          famnom_api.FDAGroup.adult: {
            '${constants.testNutrientId}': const famnom_api.FdaRdi(
              value: constants.testNutrientAmount,
              threshold: famnom_api.Threshold.min,
              name: constants.testNutrientName,
              unit: constants.testNutrientUnit,
            )
          },
        });
        when(
          () => famnomApiClient.getConfigNutrition(constants.testAuthTokenKey),
        ).thenAnswer(
          (_) async => famnomFdaRdiResponse,
        );

        final config = await appRepository.getConfigNutrition();
        expect(
          config,
          equals({
            FDAGroup.adult: {
              constants.testNutrientId: const FdaRdi(
                id: constants.testNutrientId,
                name: constants.testNutrientName,
                value: constants.testNutrientAmount,
                unit: constants.testNutrientUnit,
                threshold: Threshold.min,
              )
            }
          }),
        );
      });
    });

    group('getNutritionPreferences', () {
      test('calls with key', () async {
        try {
          await appRepository.getNutritionPreferences();
        } catch (_) {}
        verify(
          () => famnomApiClient.getNutritionPreferences(any()),
        ).called(1);
      });

      test('throws when request fails', () async {
        final exception = famnom_api.getNutritionPreferencesFailedGeneric();
        when(() => famnomApiClient.getNutritionPreferences(any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.getNutritionPreferences(),
          throwsA(
            predicate(
              (x) =>
                  x is GetNutritionPreferencesFailure &&
                  x.message ==
                      'Can not find requested nutrition preferences. '
                          'Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(() => famnomApiClient.getNutritionPreferences(any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.getNutritionPreferences(),
          throwsA(
            predicate(
              (x) =>
                  x is GetNutritionPreferencesFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });

      test('returns preferences on success', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          constants.prefAuthToken,
          constants.testAuthTokenKey,
        );

        when(
          () => famnomApiClient
              .getNutritionPreferences(constants.testAuthTokenKey),
        ).thenAnswer(
          (_) async => const [
            famnom_api.Preference(
              foodNutrientId: constants.testNutrientId,
              thresholds: [
                {
                  'min_value': constants.testNutrientAmount,
                  'max_value': null,
                  'exact_value': null,
                }
              ],
            ),
          ],
        );

        final response = await appRepository.getNutritionPreferences();
        expect(
          response,
          equals({
            constants.testNutrientId: const Preference(
              foodNutrientId: constants.testNutrientId,
              thresholds: [
                {
                  'min_value': constants.testNutrientAmount,
                  'max_value': null,
                  'exact_value': null,
                }
              ],
            ),
          }),
        );
      });
    });

    group('saveDBFood', () {
      test('calls with key', () async {
        try {
          await appRepository.saveDBFood(constants.testUUID);
        } catch (_) {}
        verify(
          () => famnomApiClient.saveDBFood(any(), any()),
        ).called(1);
      });

      test('throws when db food request fails', () async {
        final exception = famnom_api.saveDBFoodFailedGeneric();
        when(() => famnomApiClient.saveDBFood(any(), any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.saveDBFood(constants.testUUID),
          throwsA(
            predicate(
              (x) =>
                  x is SaveDBFoodFailure &&
                  x.message == 'Can not save the food. Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(() => famnomApiClient.saveDBFood(any(), any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.saveDBFood(constants.testUUID),
          throwsA(
            predicate(
              (x) =>
                  x is SaveDBFoodFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });
    });

    group('saveUserIngredient', () {
      test('calls with key', () async {
        try {
          await appRepository.saveUserIngredient(
            values: <String, dynamic>{},
          );
        } catch (_) {}
        verify(
          () => famnomApiClient.saveUserIngredient(
            key: any(named: 'key'),
            values: any(named: 'values'),
          ),
        ).called(1);
      });

      test('throws when save request fails', () async {
        final exception = famnom_api.saveUserIngredientFailedGeneric();
        when(
          () => famnomApiClient.saveUserIngredient(
            key: any(named: 'key'),
            values: any(named: 'values'),
          ),
        ).thenThrow(exception);
        expect(
          () async =>
              appRepository.saveUserIngredient(values: <String, dynamic>{}),
          throwsA(
            predicate(
              (x) =>
                  x is SaveUserIngredientFailure &&
                  x.message == 'Save failed. Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(
          () => famnomApiClient.saveUserIngredient(
            key: any(named: 'key'),
            values: any(named: 'values'),
          ),
        ).thenThrow(exception);
        expect(
          () async =>
              appRepository.saveUserIngredient(values: <String, dynamic>{}),
          throwsA(
            predicate(
              (x) =>
                  x is SaveUserIngredientFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });
    });

    group('saveUserRecipe', () {
      test('calls with key', () async {
        try {
          await appRepository.saveUserRecipe(
            values: <String, dynamic>{},
          );
        } catch (_) {}
        verify(
          () => famnomApiClient.saveUserRecipe(
            key: any(named: 'key'),
            values: any(named: 'values'),
          ),
        ).called(1);
      });

      test('throws when save request fails', () async {
        final exception = famnom_api.saveUserRecipeFailedGeneric();
        when(
          () => famnomApiClient.saveUserRecipe(
            key: any(named: 'key'),
            values: any(named: 'values'),
          ),
        ).thenThrow(exception);
        expect(
          () async => appRepository.saveUserRecipe(values: <String, dynamic>{}),
          throwsA(
            predicate(
              (x) =>
                  x is SaveUserRecipeFailure &&
                  x.message == 'Save failed. Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(
          () => famnomApiClient.saveUserRecipe(
            key: any(named: 'key'),
            values: any(named: 'values'),
          ),
        ).thenThrow(exception);
        expect(
          () async => appRepository.saveUserRecipe(values: <String, dynamic>{}),
          throwsA(
            predicate(
              (x) =>
                  x is SaveUserRecipeFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });
    });

    group('saveUserMeal', () {
      test('calls with key', () async {
        try {
          await appRepository.saveUserMeal(
            values: <String, dynamic>{},
          );
        } catch (_) {}
        verify(
          () => famnomApiClient.saveUserMeal(
            key: any(named: 'key'),
            values: any(named: 'values'),
          ),
        ).called(1);
      });

      test('throws when save request fails', () async {
        final exception = famnom_api.saveUserMealFailedGeneric();
        when(
          () => famnomApiClient.saveUserMeal(
            key: any(named: 'key'),
            values: any(named: 'values'),
          ),
        ).thenThrow(exception);
        expect(
          () async => appRepository.saveUserMeal(values: <String, dynamic>{}),
          throwsA(
            predicate(
              (x) =>
                  x is SaveUserMealFailure &&
                  x.message == 'Save failed. Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(
          () => famnomApiClient.saveUserMeal(
            key: any(named: 'key'),
            values: any(named: 'values'),
          ),
        ).thenThrow(exception);
        expect(
          () async => appRepository.saveUserMeal(values: <String, dynamic>{}),
          throwsA(
            predicate(
              (x) =>
                  x is SaveUserMealFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });
    });

    group('logDBFood', () {
      test('calls with key', () async {
        try {
          await appRepository.logDBFood(
            externalId: constants.testUUID,
            mealType: constants.testMealType,
            mealDate: DateTime.now(),
            serving: constants.testPortionExternalId,
          );
        } catch (_) {}
        verify(
          () => famnomApiClient.logDBFood(
            key: any(named: 'key'),
            externalId: any(named: 'externalId'),
            mealType: any(named: 'mealType'),
            mealDate: any(named: 'mealDate'),
            serving: any(named: 'serving'),
          ),
        ).called(1);
      });

      test('throws when log db food request fails', () async {
        final exception = famnom_api.logDBFoodFailedGeneric();
        when(
          () => famnomApiClient.logDBFood(
            key: any(named: 'key'),
            externalId: any(named: 'externalId'),
            mealType: any(named: 'mealType'),
            mealDate: any(named: 'mealDate'),
            serving: any(named: 'serving'),
          ),
        ).thenThrow(exception);
        expect(
          () async => appRepository.logDBFood(
            externalId: constants.testUUID,
            mealType: constants.testMealType,
            mealDate: DateTime.now(),
            serving: constants.testPortionExternalId,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is LogDBFoodFailure &&
                  x.message == 'Can not log the food. Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(
          () => famnomApiClient.logDBFood(
            key: any(named: 'key'),
            externalId: any(named: 'externalId'),
            mealType: any(named: 'mealType'),
            mealDate: any(named: 'mealDate'),
            serving: any(named: 'serving'),
          ),
        ).thenThrow(exception);
        expect(
          () async => appRepository.logDBFood(
            externalId: constants.testUUID,
            mealType: constants.testMealType,
            mealDate: DateTime.now(),
            serving: constants.testPortionExternalId,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is LogDBFoodFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });
    });

    group('logUserIngredient', () {
      test('calls with key', () async {
        try {
          await appRepository.logUserIngredient(
            externalId: constants.testUUID,
            mealType: constants.testMealType,
            mealDate: DateTime.now(),
            serving: constants.testPortionExternalId,
          );
        } catch (_) {}
        verify(
          () => famnomApiClient.logUserIngredient(
            key: any(named: 'key'),
            externalId: any(named: 'externalId'),
            mealType: any(named: 'mealType'),
            mealDate: any(named: 'mealDate'),
            serving: any(named: 'serving'),
          ),
        ).called(1);
      });

      test('throws when log ingredient request fails', () async {
        final exception = famnom_api.logUserIngredientFailedGeneric();
        when(
          () => famnomApiClient.logUserIngredient(
            key: any(named: 'key'),
            externalId: any(named: 'externalId'),
            mealType: any(named: 'mealType'),
            mealDate: any(named: 'mealDate'),
            serving: any(named: 'serving'),
          ),
        ).thenThrow(exception);
        expect(
          () async => appRepository.logUserIngredient(
            externalId: constants.testUUID,
            mealType: constants.testMealType,
            mealDate: DateTime.now(),
            serving: constants.testPortionExternalId,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is LogUserIngredientFailure &&
                  x.message == 'Can not log the food. Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(
          () => famnomApiClient.logUserIngredient(
            key: any(named: 'key'),
            externalId: any(named: 'externalId'),
            mealType: any(named: 'mealType'),
            mealDate: any(named: 'mealDate'),
            serving: any(named: 'serving'),
          ),
        ).thenThrow(exception);
        expect(
          () async => appRepository.logUserIngredient(
            externalId: constants.testUUID,
            mealType: constants.testMealType,
            mealDate: DateTime.now(),
            serving: constants.testPortionExternalId,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is LogUserIngredientFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });
    });

    group('logUserRecipe', () {
      test('calls with key', () async {
        try {
          await appRepository.logUserRecipe(
            externalId: constants.testUUID,
            mealType: constants.testMealType,
            mealDate: DateTime.now(),
            serving: constants.testPortionExternalId,
          );
        } catch (_) {}
        verify(
          () => famnomApiClient.logUserRecipe(
            key: any(named: 'key'),
            externalId: any(named: 'externalId'),
            mealType: any(named: 'mealType'),
            mealDate: any(named: 'mealDate'),
            serving: any(named: 'serving'),
          ),
        ).called(1);
      });

      test('throws when log recipe request fails', () async {
        final exception = famnom_api.logUserRecipeFailedGeneric();
        when(
          () => famnomApiClient.logUserRecipe(
            key: any(named: 'key'),
            externalId: any(named: 'externalId'),
            mealType: any(named: 'mealType'),
            mealDate: any(named: 'mealDate'),
            serving: any(named: 'serving'),
          ),
        ).thenThrow(exception);
        expect(
          () async => appRepository.logUserRecipe(
            externalId: constants.testUUID,
            mealType: constants.testMealType,
            mealDate: DateTime.now(),
            serving: constants.testPortionExternalId,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is LogUserRecipeFailure &&
                  x.message ==
                      'Can not log the recipe. Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(
          () => famnomApiClient.logUserRecipe(
            key: any(named: 'key'),
            externalId: any(named: 'externalId'),
            mealType: any(named: 'mealType'),
            mealDate: any(named: 'mealDate'),
            serving: any(named: 'serving'),
          ),
        ).thenThrow(exception);
        expect(
          () async => appRepository.logUserRecipe(
            externalId: constants.testUUID,
            mealType: constants.testMealType,
            mealDate: DateTime.now(),
            serving: constants.testPortionExternalId,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is LogUserRecipeFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });
    });

    group('myFoodsWithQuery empty query', () {
      test('calls with key', () async {
        try {
          await appRepository.myFoodsWithQuery();
        } catch (_) {}
        verify(
          () => famnomApiClient.getMyFoods(any(), any(), any()),
        ).called(1);
      });
    });

    group('myFoodsWithQuery with query', () {
      test('calls with key', () async {
        try {
          await appRepository.myFoodsWithQuery(query: constants.testQuery);
        } catch (_) {}
        verify(
          () => famnomApiClient.getMyFoods(any(), any(), any()),
        ).called(1);
      });

      test('throws when my foods request fails', () async {
        final exception = famnom_api.myFoodsFailedGeneric();
        when(() => famnomApiClient.getMyFoods(any(), any(), any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.myFoodsWithQuery(
            query: constants.testQuery,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is MyFoodsFailure &&
                  x.message ==
                      'Can not get list of foods. Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(() => famnomApiClient.getMyFoods(any(), any(), any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.myFoodsWithQuery(
            query: constants.testQuery,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is MyFoodsFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });
    });

    group('myFoodsWithURI', () {
      test('no calls when nextURI is None', () async {
        try {
          await appRepository.myFoodsWithURI();
        } catch (_) {}
        verifyNever(
          () => famnomApiClient.getMyFoods(any(), any(), any()),
        );
      });

      test('calls with key', () async {
        appRepository.myFoodsNextURI = 'uri';
        try {
          await appRepository.myFoodsWithURI();
        } catch (_) {}
        verify(
          () => famnomApiClient.getMyFoods(any(), any(), any()),
        ).called(1);
      });

      test('throws when my foods request fails', () async {
        appRepository.myFoodsNextURI = 'uri';
        final exception = famnom_api.myFoodsFailedGeneric();
        when(() => famnomApiClient.getMyFoods(any(), any(), any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.myFoodsWithURI(),
          throwsA(
            predicate(
              (x) =>
                  x is MyFoodsFailure &&
                  x.message ==
                      'Can not get list of foods. Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        appRepository.myFoodsNextURI = 'uri';
        final exception = famnom_api.storedAuthTokenEmpty();
        when(() => famnomApiClient.getMyFoods(any(), any(), any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.myFoodsWithURI(),
          throwsA(
            predicate(
              (x) =>
                  x is MyFoodsFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });
    });

    group('myRecipesWithQuery empty query', () {
      test('calls with key', () async {
        try {
          await appRepository.myRecipesWithQuery();
        } catch (_) {}
        verify(
          () => famnomApiClient.getMyRecipes(any(), any(), any()),
        ).called(1);
      });
    });

    group('myRecipesWithQuery with query', () {
      test('calls with key', () async {
        try {
          await appRepository.myRecipesWithQuery(query: constants.testQuery);
        } catch (_) {}
        verify(
          () => famnomApiClient.getMyRecipes(any(), any(), any()),
        ).called(1);
      });

      test('throws when my recipes request fails', () async {
        final exception = famnom_api.myRecipesFailedGeneric();
        when(() => famnomApiClient.getMyRecipes(any(), any(), any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.myRecipesWithQuery(
            query: constants.testQuery,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is MyRecipesFailure &&
                  x.message ==
                      'Can not get list of recipes. Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(() => famnomApiClient.getMyRecipes(any(), any(), any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.myRecipesWithQuery(
            query: constants.testQuery,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is MyRecipesFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });
    });

    group('myRecipesWithURI', () {
      test('no calls when nextURI is None', () async {
        try {
          await appRepository.myRecipesWithURI();
        } catch (_) {}
        verifyNever(
          () => famnomApiClient.getMyRecipes(any(), any(), any()),
        );
      });

      test('calls with key', () async {
        appRepository.myRecipesNextURI = 'uri';
        try {
          await appRepository.myRecipesWithURI();
        } catch (_) {}
        verify(
          () => famnomApiClient.getMyRecipes(any(), any(), any()),
        ).called(1);
      });

      test('throws when my recipes request fails', () async {
        appRepository.myRecipesNextURI = 'uri';
        final exception = famnom_api.myRecipesFailedGeneric();
        when(() => famnomApiClient.getMyRecipes(any(), any(), any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.myRecipesWithURI(),
          throwsA(
            predicate(
              (x) =>
                  x is MyRecipesFailure &&
                  x.message ==
                      'Can not get list of recipes. Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        appRepository.myRecipesNextURI = 'uri';
        final exception = famnom_api.storedAuthTokenEmpty();
        when(() => famnomApiClient.getMyRecipes(any(), any(), any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.myRecipesWithURI(),
          throwsA(
            predicate(
              (x) =>
                  x is MyRecipesFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });
    });

    group('myMeals', () {
      test('calls with key', () async {
        try {
          await appRepository.myMeals();
        } catch (_) {}
        verify(
          () => famnomApiClient.getMyMeals(any(), any()),
        ).called(1);
      });

      test('throws when my meals request fails', () async {
        final exception = famnom_api.myMealsFailedGeneric();
        when(() => famnomApiClient.getMyMeals(any(), any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.myMeals(),
          throwsA(
            predicate(
              (x) =>
                  x is MyMealsFailure &&
                  x.message ==
                      'Can not get list of meals. Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(() => famnomApiClient.getMyMeals(any(), any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.myMeals(),
          throwsA(
            predicate(
              (x) =>
                  x is MyMealsFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });
    });

    group('myMealsWithURI', () {
      test('no calls when nextURI is None', () async {
        try {
          await appRepository.myMealsWithURI();
        } catch (_) {}
        verifyNever(
          () => famnomApiClient.getMyMeals(any(), any()),
        );
      });

      test('calls with key', () async {
        appRepository.myMealsNextURI = 'uri';
        try {
          await appRepository.myMealsWithURI();
        } catch (_) {}
        verify(
          () => famnomApiClient.getMyMeals(any(), any()),
        ).called(1);
      });

      test('throws when my meals request fails', () async {
        appRepository.myMealsNextURI = 'uri';
        final exception = famnom_api.myMealsFailedGeneric();
        when(() => famnomApiClient.getMyMeals(any(), any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.myMealsWithURI(),
          throwsA(
            predicate(
              (x) =>
                  x is MyMealsFailure &&
                  x.message ==
                      'Can not get list of meals. Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        appRepository.myMealsNextURI = 'uri';
        final exception = famnom_api.storedAuthTokenEmpty();
        when(() => famnomApiClient.getMyMeals(any(), any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.myMealsWithURI(),
          throwsA(
            predicate(
              (x) =>
                  x is MyMealsFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });
    });

    group('deleteUserIngredient', () {
      test('calls with key', () async {
        try {
          await appRepository.deleteUserIngredient(
            externalId: constants.testUUID,
          );
        } catch (_) {}
        verify(
          () => famnomApiClient.deleteUserIngredient(
            key: any(named: 'key'),
            externalId: any(named: 'externalId'),
          ),
        ).called(1);
      });

      test('throws when delete ingredient request fails', () async {
        final exception = famnom_api.deleteUserIngredientFailedGeneric();
        when(
          () => famnomApiClient.deleteUserIngredient(
            key: any(named: 'key'),
            externalId: any(named: 'externalId'),
          ),
        ).thenThrow(exception);
        expect(
          () async => appRepository.deleteUserIngredient(
            externalId: constants.testUUID,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is DeleteUserIngredientFailure &&
                  x.message == 'Can not delete food. Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(
          () => famnomApiClient.deleteUserIngredient(
            key: any(named: 'key'),
            externalId: any(named: 'externalId'),
          ),
        ).thenThrow(exception);
        expect(
          () async => appRepository.deleteUserIngredient(
            externalId: constants.testUUID,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is DeleteUserIngredientFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });
    });

    group('getTracker', () {
      test('calls with key', () async {
        try {
          await appRepository.getTracker(DateTime.now());
        } catch (_) {}
        verify(
          () => famnomApiClient.getTracker(any(), any()),
        ).called(1);
      });

      test('throws when tracker request fails', () async {
        final exception = famnom_api.getTrackerFailedGeneric();
        when(() => famnomApiClient.getTracker(any(), any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.getTracker(DateTime.now()),
          throwsA(
            predicate(
              (x) =>
                  x is GetTrackerFailure &&
                  x.message == 'Can not fetch tracker. Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(() => famnomApiClient.getTracker(any(), any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.getTracker(DateTime.now()),
          throwsA(
            predicate(
              (x) =>
                  x is GetTrackerFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });

      test('returns correct tracker on success', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          constants.prefAuthToken,
          constants.testAuthTokenKey,
        );

        const famnomApiTrackerResponse = famnom_api.TrackerResponse(
          meals: [],
          nutrients: famnom_api.Nutrients(values: []),
        );

        when(
          () => famnomApiClient.getTracker(
            constants.testAuthTokenKey,
            any(),
          ),
        ).thenAnswer(
          (_) async => famnomApiTrackerResponse,
        );

        final tracker = await appRepository.getTracker(DateTime.now());
        expect(tracker, equals(Tracker.empty));
      });
    });

    group('saveNutritionPreferences', () {
      test('calls with key', () async {
        try {
          await appRepository.saveNutritionPreferences(<String, dynamic>{});
        } catch (_) {}
        verify(
          () => famnomApiClient.saveNutritionPreferences(any(), any()),
        ).called(1);
      });

      test('throws when save request fails', () async {
        final exception = famnom_api.saveNutritionPreferencesFailedGeneric();
        when(() => famnomApiClient.saveNutritionPreferences(any(), any()))
            .thenThrow(exception);
        expect(
          () async =>
              appRepository.saveNutritionPreferences(<String, dynamic>{}),
          throwsA(
            predicate(
              (x) =>
                  x is SaveNutritionPreferencesFailure &&
                  x.message ==
                      'Can not save nutrition preferences. '
                          'Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(() => famnomApiClient.saveNutritionPreferences(any(), any()))
            .thenThrow(exception);
        expect(
          () async =>
              appRepository.saveNutritionPreferences(<String, dynamic>{}),
          throwsA(
            predicate(
              (x) =>
                  x is SaveNutritionPreferencesFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });
    });

    group('getNutrientPage', () {
      test('calls with key', () async {
        try {
          await appRepository.getNutrientPage(
            nutrientId: constants.testNutrientId,
          );
        } catch (_) {}
        verify(
          () => famnomApiClient.getNutrientPage(
            key: any(named: 'key'),
            nutrientId: any(named: 'nutrientId'),
          ),
        ).called(1);
      });

      test('throws when nutrient page request fails', () async {
        final exception = famnom_api.getNutrientPageFailedGeneric();
        when(
          () => famnomApiClient.getNutrientPage(
            key: any(named: 'key'),
            nutrientId: any(named: 'nutrientId'),
          ),
        ).thenThrow(exception);
        expect(
          () async => appRepository.getNutrientPage(
            nutrientId: constants.testNutrientId,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is GetNutrientPageFailure &&
                  x.message ==
                      'Can not fetch nutrient details. Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(
          () => famnomApiClient.getNutrientPage(
            key: any(named: 'key'),
            nutrientId: any(named: 'nutrientId'),
          ),
        ).thenThrow(exception);
        expect(
          () async => appRepository.getNutrientPage(
            nutrientId: constants.testNutrientId,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is GetNutrientPageFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });

      test('returns correct nutrient page on success', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          constants.prefAuthToken,
          constants.testAuthTokenKey,
        );

        const famnomApiNutrientPage = famnom_api.NutrientPage(
          id: constants.testNutrientId,
          name: constants.testNutrientName,
        );

        const appNutrientPage = NutrientPage(
          id: constants.testNutrientId,
          name: constants.testNutrientName,
        );

        when(
          () => famnomApiClient.getNutrientPage(
            key: any(named: 'key'),
            nutrientId: any(named: 'nutrientId'),
          ),
        ).thenAnswer(
          (_) async => famnomApiNutrientPage,
        );

        final nutrientPage = await appRepository.getNutrientPage(
          nutrientId: constants.testNutrientId,
        );
        expect(nutrientPage, equals(appNutrientPage));
      });
    });

    group('saveMealplanFormOne', () {
      test('calls with key', () async {
        try {
          await appRepository.saveMealplanFormOne(
            values: <String, dynamic>{},
          );
        } catch (_) {}
        verify(
          () => famnomApiClient.saveMealplanFormOne(
            key: any(named: 'key'),
            values: any(named: 'values'),
          ),
        ).called(1);
      });

      test('throws when save request fails', () async {
        final exception = famnom_api.saveMealplanFormOneFailedGeneric();
        when(
          () => famnomApiClient.saveMealplanFormOne(
            key: any(named: 'key'),
            values: any(named: 'values'),
          ),
        ).thenThrow(exception);
        expect(
          () async =>
              appRepository.saveMealplanFormOne(values: <String, dynamic>{}),
          throwsA(
            predicate(
              (x) =>
                  x is SaveMealplanFormOneFailure &&
                  x.message == 'Save failed. Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(
          () => famnomApiClient.saveMealplanFormOne(
            key: any(named: 'key'),
            values: any(named: 'values'),
          ),
        ).thenThrow(exception);
        expect(
          () async =>
              appRepository.saveMealplanFormOne(values: <String, dynamic>{}),
          throwsA(
            predicate(
              (x) =>
                  x is SaveMealplanFormOneFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });
    });

    group('getMealplanFormTwo', () {
      test('calls with key', () async {
        try {
          await appRepository.getMealplanFormTwo();
        } catch (_) {}
        verify(
          () => famnomApiClient.getMealplanFormTwo(any()),
        ).called(1);
      });

      test('throws when request fails', () async {
        final exception = famnom_api.getMealplanFormTwoFailedGeneric();
        when(() => famnomApiClient.getMealplanFormTwo(any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.getMealplanFormTwo(),
          throwsA(
            predicate(
              (x) =>
                  x is GetMealplanFormTwoFailure &&
                  x.message == 'Request failed. Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(() => famnomApiClient.getMealplanFormTwo(any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.getMealplanFormTwo(),
          throwsA(
            predicate(
              (x) =>
                  x is GetMealplanFormTwoFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });

      test('returns preferences on success', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          constants.prefAuthToken,
          constants.testAuthTokenKey,
        );

        when(
          () => famnomApiClient.getMealplanFormTwo(constants.testAuthTokenKey),
        ).thenAnswer(
          (_) async => const [
            famnom_api.MealplanPreference(
              externalId: constants.testUUID,
              name: constants.testFoodName,
              thresholds: [
                {
                  'min_value': constants.testNutrientAmount,
                  'max_value': null,
                  'exact_value': null,
                }
              ],
            ),
          ],
        );

        final response = await appRepository.getMealplanFormTwo();
        expect(
          response,
          equals(const [
            MealplanPreference(
              externalId: constants.testUUID,
              name: constants.testFoodName,
              thresholds: [
                {
                  'min_value': constants.testNutrientAmount,
                  'max_value': null,
                  'exact_value': null,
                }
              ],
            ),
          ]),
        );
      });
    });

    group('saveMealplanFormTwo', () {
      test('calls with key', () async {
        try {
          await appRepository.saveMealplanFormTwo(
            values: <String, dynamic>{},
          );
        } catch (_) {}
        verify(
          () => famnomApiClient.saveMealplanFormTwo(
            key: any(named: 'key'),
            values: any(named: 'values'),
          ),
        ).called(1);
      });

      test('throws when save request fails', () async {
        final exception = famnom_api.saveMealplanFormTwoFailedGeneric();
        when(
          () => famnomApiClient.saveMealplanFormTwo(
            key: any(named: 'key'),
            values: any(named: 'values'),
          ),
        ).thenThrow(exception);
        expect(
          () async =>
              appRepository.saveMealplanFormTwo(values: <String, dynamic>{}),
          throwsA(
            predicate(
              (x) =>
                  x is SaveMealplanFormTwoFailure &&
                  x.message == 'Save failed. Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(
          () => famnomApiClient.saveMealplanFormTwo(
            key: any(named: 'key'),
            values: any(named: 'values'),
          ),
        ).thenThrow(exception);
        expect(
          () async =>
              appRepository.saveMealplanFormTwo(values: <String, dynamic>{}),
          throwsA(
            predicate(
              (x) =>
                  x is SaveMealplanFormTwoFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });
    });

    group('getMealplanFormThree', () {
      test('calls with key', () async {
        try {
          await appRepository.getMealplanFormThree();
        } catch (_) {}
        verify(
          () => famnomApiClient.getMealplanFormThree(any()),
        ).called(1);
      });

      test('throws when request fails', () async {
        final exception = famnom_api.getMealplanFormThreeFailedGeneric();
        when(() => famnomApiClient.getMealplanFormThree(any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.getMealplanFormThree(),
          throwsA(
            predicate(
              (x) =>
                  x is GetMealplanFormThreeFailure &&
                  x.message == 'Request failed. Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(() => famnomApiClient.getMealplanFormThree(any()))
            .thenThrow(exception);
        expect(
          () async => appRepository.getMealplanFormThree(),
          throwsA(
            predicate(
              (x) =>
                  x is GetMealplanFormThreeFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });

      test('returns preferences on success', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          constants.prefAuthToken,
          constants.testAuthTokenKey,
        );

        when(
          () =>
              famnomApiClient.getMealplanFormThree(constants.testAuthTokenKey),
        ).thenAnswer(
          (_) async => const famnom_api.Mealplan(
            infeasible: false,
            results: [
              famnom_api.MealplanItem(
                externalId: constants.testUUID,
                name: constants.testFoodName,
                quantity: 123,
              )
            ],
          ),
        );

        final response = await appRepository.getMealplanFormThree();
        expect(
          response,
          equals(
            const Mealplan(
              infeasible: false,
              results: [
                MealplanItem(
                  externalId: constants.testUUID,
                  name: constants.testFoodName,
                  quantity: 123,
                )
              ],
            ),
          ),
        );
      });
    });

    group('saveMealplanFormThree', () {
      test('calls with key', () async {
        try {
          await appRepository.saveMealplanFormThree(
            values: <String, dynamic>{},
          );
        } catch (_) {}
        verify(
          () => famnomApiClient.saveMealplanFormThree(
            key: any(named: 'key'),
            values: any(named: 'values'),
          ),
        ).called(1);
      });

      test('throws when save request fails', () async {
        final exception = famnom_api.saveMealplanFormThreeFailedGeneric();
        when(
          () => famnomApiClient.saveMealplanFormThree(
            key: any(named: 'key'),
            values: any(named: 'values'),
          ),
        ).thenThrow(exception);
        expect(
          () async =>
              appRepository.saveMealplanFormThree(values: <String, dynamic>{}),
          throwsA(
            predicate(
              (x) =>
                  x is SaveMealplanFormThreeFailure &&
                  x.message == 'Save failed. Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(
          () => famnomApiClient.saveMealplanFormThree(
            key: any(named: 'key'),
            values: any(named: 'values'),
          ),
        ).thenThrow(exception);
        expect(
          () async =>
              appRepository.saveMealplanFormThree(values: <String, dynamic>{}),
          throwsA(
            predicate(
              (x) =>
                  x is SaveMealplanFormThreeFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });
    });

    group('FamnomAPIToAppDBFoodConversion.toDBFood', () {
      test('converts famnom DBFood to app_repository DBFood success', () {
        const famnomApiDBfood = famnom_api.DBFood(
          externalId: constants.testUUID,
          description: constants.testFoodName,
          brand: famnom_api.DBBrandedFood(
            brandName: constants.testBrandName,
            brandOwner: constants.testBrandOwner,
          ),
          portions: [
            famnom_api.Portion(
              externalId: constants.testPortionExternalId,
              name: constants.testPortionName,
              servingSize: constants.testPortionSize,
              servingSizeUnit: constants.testPortionSizeUnit,
            ),
          ],
          nutrients: famnom_api.Nutrients(
            servingSize: constants.testNutrientServingSize,
            servingSizeUnit: constants.testNutrientServingSizeUnit,
            values: [
              famnom_api.Nutrient(
                id: constants.testNutrientId,
                name: constants.testNutrientName,
                amount: constants.testNutrientAmount,
                unit: constants.testNutrientUnit,
              )
            ],
          ),
          lfoodExternalId: constants.testUUID,
        );

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

        expect(
          famnomApiDBfood.toDBFood,
          equals(appDBFood),
        );
      });
    });

    group('FamnomAPIToAppConfigNutritionConversion.toFDARDIMap', () {
      test(
          'converts famnom fdardiresponse to app_repository fdardi map success',
          () {
        const famnomApiFdaRdiResponse = famnom_api.FdaRdiResponse(
          results: {
            famnom_api.FDAGroup.adult: {
              '${constants.testNutrientId}': famnom_api.FdaRdi(
                value: constants.testNutrientAmount,
                threshold: famnom_api.Threshold.min,
                name: constants.testNutrientName,
                unit: constants.testNutrientUnit,
              )
            }
          },
        );

        const appFDARDIMap = {
          FDAGroup.adult: {
            constants.testNutrientId: FdaRdi(
              id: constants.testNutrientId,
              value: constants.testNutrientAmount,
              threshold: Threshold.min,
              name: constants.testNutrientName,
              unit: constants.testNutrientUnit,
            )
          }
        };

        expect(
          famnomApiFdaRdiResponse.toFDARDIMap,
          equals(appFDARDIMap),
        );
      });
    });

    group('FamnomAPIToAppConfigNutritionLabelConversion.toNutrientMap', () {
      test(
          'converts famnom fdardiresponse to app_repository '
          'nutrient map success', () {
        const famnomApiLabelResponse = famnom_api.LabelResponse(
          results: [
            famnom_api.Nutrient(
              id: constants.testNutrientId,
              name: constants.testNutrientName,
              unit: constants.testNutrientUnit,
            ),
          ],
        );

        const appNutrientMap = {
          constants.testNutrientId: Nutrient(
            id: constants.testNutrientId,
            name: constants.testNutrientName,
            unit: constants.testNutrientUnit,
          )
        };

        expect(
          famnomApiLabelResponse.toNutrientMap,
          equals(appNutrientMap),
        );
      });
    });

    group('FamnomAPIToAppConstantsConversion.toAppConstants', () {
      test(
          'converts famnom appconstants to app_repository appconstants success',
          () {
        const famnomApiAppConstants = famnom_api.AppConstants();
        const appAppConstants = AppConstants();

        expect(
          famnomApiAppConstants.toAppConstants,
          equals(appAppConstants),
        );
      });
    });

    group('FamnomAPIToAppPreferenceConversion.toPreference', () {
      test('converts famnom Preference to app_repository Preference success',
          () {
        const famnomApiPreference = famnom_api.Preference(
          foodNutrientId: constants.testNutrientId,
          thresholds: [
            {
              'min_value': constants.testNutrientAmount,
              'max_value': null,
              'exact_value': null,
            }
          ],
        );
        const appPreference = Preference(
          foodNutrientId: constants.testNutrientId,
          thresholds: [
            {
              'min_value': constants.testNutrientAmount,
              'max_value': null,
              'exact_value': null,
            }
          ],
        );
        expect(
          famnomApiPreference.toPreference,
          equals(appPreference),
        );
      });
    });

    group('FamnomAPIToAppMealplanPreferenceConversion.toPreference', () {
      test(
          'converts famnom Preference to app_repository '
          'MealplanPreference success', () {
        const famnomApiPreference = famnom_api.MealplanPreference(
          externalId: constants.testUUID,
          name: constants.testFoodName,
          thresholds: [
            {
              'min_value': constants.testNutrientAmount,
              'max_value': null,
              'exact_value': null,
            }
          ],
        );
        const appPreference = MealplanPreference(
          externalId: constants.testUUID,
          name: constants.testFoodName,
          thresholds: [
            {
              'min_value': constants.testNutrientAmount,
              'max_value': null,
              'exact_value': null,
            }
          ],
        );
        expect(
          famnomApiPreference.toPreference,
          equals(appPreference),
        );
      });
    });

    group('FamnomAPIToAppMealplanConversion.toMealplan', () {
      test('converts famnom Mealplan to app_repository Mealplan success', () {
        const famnomApiMealplan = famnom_api.Mealplan(
          infeasible: false,
          results: [
            famnom_api.MealplanItem(
              externalId: constants.testUUID,
              name: constants.testFoodName,
              quantity: 123,
            )
          ],
        );
        const appMealplan = Mealplan(
          infeasible: false,
          results: [
            MealplanItem(
              externalId: constants.testUUID,
              name: constants.testFoodName,
              quantity: 123,
            )
          ],
        );
        expect(famnomApiMealplan.toMealplan, equals(appMealplan));
      });
    });

    group(
        'FamnomAPIToAppUserIngredientDisplayConversion.toUserIngredientDisplay',
        () {
      test(
          'converts famnom UserIngredientDisplay to app_repository '
          'UserIngredientDisplay success', () {
        const famnomApiUserIngredientDisplay = famnom_api.UserIngredientDisplay(
          externalId: constants.testUUID,
          name: constants.testFoodName,
          brand: famnom_api.Brand(
            brandName: constants.testBrandName,
            brandOwner: constants.testBrandOwner,
          ),
          portions: [
            famnom_api.Portion(
              externalId: constants.testPortionExternalId,
              name: constants.testPortionName,
              servingSize: constants.testPortionSize,
              servingSizeUnit: constants.testPortionSizeUnit,
            ),
          ],
          nutrients: famnom_api.Nutrients(
            servingSize: constants.testNutrientServingSize,
            servingSizeUnit: constants.testNutrientServingSizeUnit,
            values: [
              famnom_api.Nutrient(
                id: constants.testNutrientId,
                name: constants.testNutrientName,
                amount: constants.testNutrientAmount,
                unit: constants.testNutrientUnit,
              )
            ],
          ),
          category: constants.testCategoryName,
        );

        const appUserIngredientDisplay = UserIngredientDisplay(
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

        expect(
          famnomApiUserIngredientDisplay.toUserIngredientDisplay,
          equals(appUserIngredientDisplay),
        );
      });
    });

    group(
        'FamnomAPIToAppUserIngredientMutableConversion.toUserIngredientMutable',
        () {
      test(
          'converts famnom UserIngredientMutable to app_repository '
          'UserIngredientMutable success', () {
        const famnomApiUserIngredientMutable = famnom_api.UserIngredientMutable(
          externalId: constants.testUUID,
          name: constants.testFoodName,
          brand: famnom_api.Brand(
            brandName: constants.testBrandName,
            brandOwner: constants.testBrandOwner,
          ),
          portions: [
            famnom_api.UserFoodPortion(
              id: constants.testPortionId,
              externalId: constants.testPortionExternalId,
              servingSize: constants.testPortionSize,
              servingSizeUnit: constants.testPortionSizeUnit,
            ),
          ],
          nutrients: famnom_api.Nutrients(
            servingSize: constants.testNutrientServingSize,
            servingSizeUnit: constants.testNutrientServingSizeUnit,
            values: [
              famnom_api.Nutrient(
                id: constants.testNutrientId,
                name: constants.testNutrientName,
                amount: constants.testNutrientAmount,
                unit: constants.testNutrientUnit,
              )
            ],
          ),
          category: constants.testCategoryName,
        );

        const appUserIngredientMutable = UserIngredientMutable(
          externalId: constants.testUUID,
          name: constants.testFoodName,
          brand: Brand(
            brandName: constants.testBrandName,
            brandOwner: constants.testBrandOwner,
          ),
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
          category: constants.testCategoryName,
        );

        expect(
          famnomApiUserIngredientMutable.toUserIngredientMutable,
          equals(appUserIngredientMutable),
        );
      });
    });

    group('FamnomAPIToAppUserRecipeDisplayConversion.toUserRecipeDisplay', () {
      test(
          'converts famnom UserRecipeDisplay to app_repository '
          'UserRecipeDisplay success', () {
        const famnomApiUserRecipeDisplay = famnom_api.UserRecipeDisplay(
          externalId: constants.testUUID,
          name: constants.testRecipeName,
          recipeDate: constants.testRecipeDate,
          portions: [
            famnom_api.Portion(
              externalId: constants.testPortionExternalId,
              name: constants.testPortionName,
              servingSize: constants.testPortionSize,
              servingSizeUnit: constants.testPortionSizeUnit,
            ),
          ],
          nutrients: famnom_api.Nutrients(
            servingSize: constants.testNutrientServingSize,
            servingSizeUnit: constants.testNutrientServingSizeUnit,
            values: [
              famnom_api.Nutrient(
                id: constants.testNutrientId,
                name: constants.testNutrientName,
                amount: constants.testNutrientAmount,
                unit: constants.testNutrientUnit,
              )
            ],
          ),
          memberIngredients: [
            famnom_api.UserMemberIngredientDisplay(
              externalId: constants.testUUID,
              displayIngredient: famnom_api.UserIngredientDisplay(
                externalId: constants.testUUID,
                name: constants.testFoodName,
              ),
            )
          ],
          memberRecipes: [
            famnom_api.UserMemberRecipeDisplay(
              externalId: constants.testUUID,
              displayRecipe: famnom_api.UserRecipeDisplay(
                externalId: constants.testUUID,
                name: constants.testFoodName,
              ),
            )
          ],
        );

        const appUserRecipeDisplay = UserRecipeDisplay(
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
            )
          ],
          memberRecipes: [
            UserMemberRecipeDisplay(
              externalId: constants.testUUID,
              recipe: UserRecipeDisplay(
                externalId: constants.testUUID,
                name: constants.testFoodName,
              ),
            )
          ],
        );

        expect(
          famnomApiUserRecipeDisplay.toUserRecipeDisplay,
          equals(appUserRecipeDisplay),
        );
      });
    });

    group('FamnomAPIToAppUserMealDisplayConversion.toUserMealDisplay', () {
      test(
          'converts famnom UserMealDisplay to app_repository '
          'UserMealDisplay success', () {
        const famnomApiUserMealDisplay = famnom_api.UserMealDisplay(
          externalId: constants.testUUID,
          mealDate: constants.testMealDate,
          mealType: constants.testMealType,
          nutrients: famnom_api.Nutrients(
            servingSize: constants.testNutrientServingSize,
            servingSizeUnit: constants.testNutrientServingSizeUnit,
            values: [
              famnom_api.Nutrient(
                id: constants.testNutrientId,
                name: constants.testNutrientName,
                amount: constants.testNutrientAmount,
                unit: constants.testNutrientUnit,
              )
            ],
          ),
          memberIngredients: [
            famnom_api.UserMemberIngredientDisplay(
              externalId: constants.testUUID,
              displayIngredient: famnom_api.UserIngredientDisplay(
                externalId: constants.testUUID,
                name: constants.testFoodName,
              ),
            )
          ],
          memberRecipes: [
            famnom_api.UserMemberRecipeDisplay(
              externalId: constants.testUUID,
              displayRecipe: famnom_api.UserRecipeDisplay(
                externalId: constants.testUUID,
                name: constants.testFoodName,
              ),
            )
          ],
        );

        const appUserMealDisplay = UserMealDisplay(
          externalId: constants.testUUID,
          mealDate: constants.testMealDate,
          mealType: constants.testMealType,
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
            )
          ],
          memberRecipes: [
            UserMemberRecipeDisplay(
              externalId: constants.testUUID,
              recipe: UserRecipeDisplay(
                externalId: constants.testUUID,
                name: constants.testFoodName,
              ),
            )
          ],
        );

        expect(
          famnomApiUserMealDisplay.toUserMealDisplay,
          equals(appUserMealDisplay),
        );
      });
    });

    group('FamnomAPIToAppMyFoodsResponseConversion.toResults', () {
      test(
          'converts famnom MyFoodsResponse to app_repository '
          'List<UserIngredientDisplay> success', () {
        const famnomApiMyFoodsResponse = famnom_api.MyFoodsResponse(
          count: 1,
          results: [
            famnom_api.UserIngredientDisplay(
              externalId: constants.testUUID,
              name: constants.testFoodName,
              brand: famnom_api.Brand(
                brandName: constants.testBrandName,
                brandOwner: constants.testBrandOwner,
              ),
              portions: [
                famnom_api.Portion(
                  externalId: constants.testPortionExternalId,
                  name: constants.testPortionName,
                  servingSize: constants.testPortionSize,
                  servingSizeUnit: constants.testPortionSizeUnit,
                ),
              ],
              nutrients: famnom_api.Nutrients(
                servingSize: constants.testNutrientServingSize,
                servingSizeUnit: constants.testNutrientServingSizeUnit,
                values: [
                  famnom_api.Nutrient(
                    id: constants.testNutrientId,
                    name: constants.testNutrientName,
                    amount: constants.testNutrientAmount,
                    unit: constants.testNutrientUnit,
                  )
                ],
              ),
              category: constants.testCategoryName,
            ),
          ],
        );

        const appUserIngredientDisplay = UserIngredientDisplay(
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

        expect(
          famnomApiMyFoodsResponse.toResults,
          equals([appUserIngredientDisplay]),
        );
      });
    });

    group('FamnomAPIToAppMyRecipesResponseConversion.toResults', () {
      test(
          'converts famnom MyRecipesResponse to app_repository '
          'List<UserRecipeDisplay> success', () {
        const famnomApiMyRecipesResponse = famnom_api.MyRecipesResponse(
          count: 1,
          results: [
            famnom_api.UserRecipeDisplay(
              externalId: constants.testUUID,
              name: constants.testRecipeName,
              recipeDate: constants.testRecipeDate,
              portions: [
                famnom_api.Portion(
                  externalId: constants.testPortionExternalId,
                  name: constants.testPortionName,
                  servingSize: constants.testPortionSize,
                  servingSizeUnit: constants.testPortionSizeUnit,
                ),
              ],
              nutrients: famnom_api.Nutrients(
                servingSize: constants.testNutrientServingSize,
                servingSizeUnit: constants.testNutrientServingSizeUnit,
                values: [
                  famnom_api.Nutrient(
                    id: constants.testNutrientId,
                    name: constants.testNutrientName,
                    amount: constants.testNutrientAmount,
                    unit: constants.testNutrientUnit,
                  )
                ],
              ),
              memberIngredients: [
                famnom_api.UserMemberIngredientDisplay(
                  externalId: constants.testUUID,
                  displayIngredient: famnom_api.UserIngredientDisplay(
                    externalId: constants.testUUID,
                    name: constants.testFoodName,
                  ),
                )
              ],
              memberRecipes: [
                famnom_api.UserMemberRecipeDisplay(
                  externalId: constants.testUUID,
                  displayRecipe: famnom_api.UserRecipeDisplay(
                    externalId: constants.testUUID,
                    name: constants.testFoodName,
                  ),
                )
              ],
            )
          ],
        );

        const appUserRecipeDisplay = UserRecipeDisplay(
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
            )
          ],
          memberRecipes: [
            UserMemberRecipeDisplay(
              externalId: constants.testUUID,
              recipe: UserRecipeDisplay(
                externalId: constants.testUUID,
                name: constants.testFoodName,
              ),
            )
          ],
        );

        expect(
          famnomApiMyRecipesResponse.toResults,
          equals([appUserRecipeDisplay]),
        );
      });
    });

    group('FamnomAPIToAppMyMealsResponseConversion.toResults', () {
      test(
          'converts famnom MyMealsResponse to app_repository '
          'List<UserMealDisplay> success', () {
        const famnomApiMyMealsResponse = famnom_api.MyMealsResponse(
          count: 1,
          results: [
            famnom_api.UserMealDisplay(
              externalId: constants.testUUID,
              mealDate: constants.testMealDate,
              mealType: constants.testMealType,
              nutrients: famnom_api.Nutrients(
                servingSize: constants.testNutrientServingSize,
                servingSizeUnit: constants.testNutrientServingSizeUnit,
                values: [
                  famnom_api.Nutrient(
                    id: constants.testNutrientId,
                    name: constants.testNutrientName,
                    amount: constants.testNutrientAmount,
                    unit: constants.testNutrientUnit,
                  )
                ],
              ),
              memberIngredients: [
                famnom_api.UserMemberIngredientDisplay(
                  externalId: constants.testUUID,
                  displayIngredient: famnom_api.UserIngredientDisplay(
                    externalId: constants.testUUID,
                    name: constants.testFoodName,
                  ),
                )
              ],
              memberRecipes: [
                famnom_api.UserMemberRecipeDisplay(
                  externalId: constants.testUUID,
                  displayRecipe: famnom_api.UserRecipeDisplay(
                    externalId: constants.testUUID,
                    name: constants.testFoodName,
                  ),
                )
              ],
            )
          ],
        );

        const appUserMealDisplay = UserMealDisplay(
          externalId: constants.testUUID,
          mealDate: constants.testMealDate,
          mealType: constants.testMealType,
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
            )
          ],
          memberRecipes: [
            UserMemberRecipeDisplay(
              externalId: constants.testUUID,
              recipe: UserRecipeDisplay(
                externalId: constants.testUUID,
                name: constants.testFoodName,
              ),
            )
          ],
        );

        expect(
          famnomApiMyMealsResponse.toResults,
          equals([appUserMealDisplay]),
        );
      });
    });

    group('FamnomAPIToAppTrackerConversion.toTracker', () {
      test('converts famnom TrackerResponse to app_repository Tracker success',
          () {
        const famnomApiTrackerResponse = famnom_api.TrackerResponse(
          meals: [
            famnom_api.UserMealDisplay(
              externalId: constants.testUUID,
              mealDate: constants.testMealDate,
              mealType: constants.testMealType,
              memberIngredients: [
                famnom_api.UserMemberIngredientDisplay(
                  externalId: constants.testUUID,
                  displayIngredient: famnom_api.UserIngredientDisplay(
                    externalId: constants.testUUID,
                    name: constants.testFoodName,
                  ),
                ),
              ],
              memberRecipes: [
                famnom_api.UserMemberRecipeDisplay(
                  externalId: constants.testUUID,
                  displayRecipe: famnom_api.UserRecipeDisplay(
                    externalId: constants.testUUID,
                    name: constants.testFoodName,
                  ),
                ),
              ],
            ),
          ],
          nutrients: famnom_api.Nutrients(
            values: [
              famnom_api.Nutrient(
                id: constants.testNutrientId,
                name: constants.testNutrientName,
                amount: constants.testNutrientAmount,
                unit: constants.testNutrientUnit,
              )
            ],
          ),
        );

        const appTracker = Tracker(
          meals: [
            UserMealDisplay(
              externalId: constants.testUUID,
              mealDate: constants.testMealDate,
              mealType: constants.testMealType,
              memberIngredients: [
                UserMemberIngredientDisplay(
                  externalId: constants.testUUID,
                  ingredient: UserIngredientDisplay(
                    externalId: constants.testUUID,
                    name: constants.testFoodName,
                  ),
                ),
              ],
              memberRecipes: [
                UserMemberRecipeDisplay(
                  externalId: constants.testUUID,
                  recipe: UserRecipeDisplay(
                    externalId: constants.testUUID,
                    name: constants.testFoodName,
                  ),
                ),
              ],
            ),
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

        expect(
          famnomApiTrackerResponse.toTracker,
          equals(appTracker),
        );
      });
    });
  });
}
