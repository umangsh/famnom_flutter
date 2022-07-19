import 'package:app_repository/app_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserRecipeDisplay', () {
    const userRecipeDisplay = UserRecipeDisplay(
      externalId: constants.testUUID,
      name: constants.testRecipeName,
      recipeDate: constants.testRecipeDate,
      portions: [
        Portion(
          externalId: constants.testPortionExternalId,
          name: constants.testPortionName,
          servingSize: constants.testPortionSize,
          servingSizeUnit: constants.testPortionSizeUnit,
        )
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
      membership: UserMemberRecipeDisplay(
        externalId: constants.testUUID,
        recipe: UserRecipeDisplay(
          externalId: constants.testUUID,
          name: constants.testRecipeName,
          recipeDate: constants.testRecipeDate,
        ),
      ),
    );

    test('isEmpty returns true for empty userrecipedisplay', () {
      expect(UserRecipeDisplay.empty.isEmpty, isTrue);
    });

    test('isEmpty returns false for non-empty userRecipeDisplay', () {
      expect(userRecipeDisplay.isEmpty, isFalse);
    });

    test('isNotEmpty returns false for empty userRecipeDisplay', () {
      expect(UserRecipeDisplay.empty.isNotEmpty, isFalse);
    });

    test('isNotEmpty returns true for non-empty userRecipeDisplay', () {
      expect(userRecipeDisplay.isNotEmpty, isTrue);
    });

    test('get defaultPortion', () {
      expect(
        userRecipeDisplay.defaultPortion,
        equals(
          const Portion(
            externalId: constants.testPortionExternalId,
            name: constants.testPortionName,
            servingSize: constants.testPortionSize,
            servingSizeUnit: constants.testPortionSizeUnit,
          ),
        ),
      );
    });

    group('fromJson', () {
      test('returns userRecipeDisplay with values', () {
        expect(
          UserRecipeDisplay.fromJson(
            const <String, dynamic>{
              'external_id': constants.testUUID,
              'name': constants.testRecipeName,
              'recipe_date': constants.testRecipeDate,
              'display_portions': [
                {
                  'external_id': constants.testPortionExternalId,
                  'name': constants.testPortionName,
                  'serving_size': constants.testPortionSize,
                  'serving_size_unit': constants.testPortionSizeUnit
                }
              ],
              'display_nutrients': {
                'serving_size': constants.testNutrientServingSize,
                'serving_size_unit': constants.testNutrientServingSizeUnit,
                'values': {
                  '${constants.testNutrientId}': {
                    'id': constants.testNutrientId,
                    'name': constants.testNutrientName,
                    'amount': constants.testNutrientAmount,
                    'unit': constants.testNutrientUnit
                  }
                }
              },
              'member_ingredients': [
                {
                  'external_id': constants.testUUID,
                  'ingredient': {
                    'external_id': constants.testUUID,
                    'name': constants.testFoodName,
                    'brand': {
                      'brand_owner': constants.testBrandOwner,
                      'brand_name': constants.testBrandName,
                    }
                  },
                  'portion': {
                    'external_id': constants.testPortionExternalId,
                    'name': constants.testPortionName,
                    'serving_size': constants.testPortionSize,
                    'serving_size_unit': constants.testPortionSizeUnit
                  }
                }
              ],
              'member_recipes': [
                {
                  'external_id': constants.testUUID,
                  'recipe': {
                    'external_id': constants.testUUID,
                    'name': constants.testRecipeName,
                    'recipe_date': constants.testRecipeDate,
                  },
                  'portion': {
                    'external_id': constants.testPortionExternalId,
                    'name': constants.testPortionName,
                    'serving_size': constants.testPortionSize,
                    'serving_size_unit': constants.testPortionSizeUnit
                  }
                }
              ],
              'membership': {
                'external_id': constants.testUUID,
                'recipe': {
                  'external_id': constants.testUUID,
                  'name': constants.testRecipeName,
                  'recipe_date': constants.testRecipeDate,
                },
                'portion': {
                  'external_id': constants.testPortionExternalId,
                  'name': constants.testPortionName,
                  'serving_size': constants.testPortionSize,
                  'serving_size_unit': constants.testPortionSizeUnit
                }
              }
            },
          ),
          isA<UserRecipeDisplay>()
              .having(
                (UserRecipeDisplay s) => s.externalId,
                'external id',
                equals(constants.testUUID),
              )
              .having(
                (UserRecipeDisplay s) => s.name,
                'name',
                equals(constants.testRecipeName),
              )
              .having(
                (UserRecipeDisplay s) => s.recipeDate,
                'name',
                equals(constants.testRecipeDate),
              )
              .having(
                (UserRecipeDisplay s) => s.portions?.length,
                'portions length',
                equals(1),
              )
              .having(
                (UserRecipeDisplay s) => s.nutrients?.values.length,
                'nutrients length',
                equals(1),
              )
              .having(
                (UserRecipeDisplay s) => s.memberIngredients?.length,
                'ingredients length',
                equals(1),
              )
              .having(
                (UserRecipeDisplay s) => s.memberRecipes?.length,
                'recipes length',
                equals(1),
              )
              .having(
                (UserRecipeDisplay s) => s.membership!.externalId,
                'membership',
                equals(constants.testUUID),
              ),
        );
      });
    });
  });
}
