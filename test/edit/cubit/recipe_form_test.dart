import 'package:app_repository/app_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:famnom_flutter/edit/edit.dart';
import 'package:test/test.dart';

void main() {
  group('RecipeForm', () {
    group('convertToMap', () {
      test('empty RecipeForm', () {
        final form = RecipeForm();
        final expected = <String, dynamic>{
          'external_id': null,
          'name': null,
          'recipe_date': null,
          'servings-TOTAL_FORMS': 0,
          'servings-INITIAL_FORMS': 0,
          'servings-MIN_NUM_FORMS': 0,
          'servings-MAX_NUM_FORMS': 1000,
          'food-TOTAL_FORMS': 0,
          'food-INITIAL_FORMS': 0,
          'food-MIN_NUM_FORMS': 0,
          'food-MAX_NUM_FORMS': 1000,
          'recipe-TOTAL_FORMS': 0,
          'recipe-INITIAL_FORMS': 0,
          'recipe-MIN_NUM_FORMS': 0,
          'recipe-MAX_NUM_FORMS': 1000
        };
        expect(form.convertToMap(), equals(expected));
      });

      test('RecipeForm with values unchanged portions', () {
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

        final form = RecipeForm(
          userRecipe: userRecipe,
          externalId: userRecipe.externalId,
          name: userRecipe.name,
          recipeDate: userRecipe.recipeDate,
          portions: [
            FoodPortionForm(
              id: constants.testPortionId,
              servingSize: constants.testPortionSize.toString(),
              servingSizeUnit: constants.testPortionSizeUnit,
            )
          ],
        );

        final expected = <String, dynamic>{
          'external_id': '52aa70fd-556d-46eb-acb8-40898814e83e',
          'name': 'test_recipe',
          'recipe_date': '2022-03-03',
          'servings-TOTAL_FORMS': 1,
          'servings-INITIAL_FORMS': 1,
          'servings-MIN_NUM_FORMS': 0,
          'servings-MAX_NUM_FORMS': 1000,
          'servings-0-id': 123,
          'servings-0-servings_per_container': null,
          'servings-0-household_quantity': null,
          'servings-0-measure_unit': null,
          'servings-0-serving_size': '100.0',
          'servings-0-serving_size_unit': 'g',
          'food-TOTAL_FORMS': 0,
          'food-INITIAL_FORMS': 0,
          'food-MIN_NUM_FORMS': 0,
          'food-MAX_NUM_FORMS': 1000,
          'recipe-TOTAL_FORMS': 0,
          'recipe-INITIAL_FORMS': 0,
          'recipe-MIN_NUM_FORMS': 0,
          'recipe-MAX_NUM_FORMS': 1000
        };
        expect(form.convertToMap(), equals(expected));
      });

      test('RecipeForm with values changed portions', () {
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

        final form = RecipeForm(
          userRecipe: userRecipe,
          externalId: userRecipe.externalId,
          name: userRecipe.name,
          recipeDate: userRecipe.recipeDate,
          portions: [
            FoodPortionForm(
              id: constants.testPortionId,
              householdQuantity: constants.testPortionHouseholdQuantity,
              householdUnit: constants.testPortionHouseholdUnit,
              servingSize: '83',
              servingSizeUnit: 'ml',
            )
          ],
        );

        final expected = <String, dynamic>{
          'external_id': '52aa70fd-556d-46eb-acb8-40898814e83e',
          'name': 'test_recipe',
          'recipe_date': '2022-03-03',
          'servings-TOTAL_FORMS': 1,
          'servings-INITIAL_FORMS': 1,
          'servings-MIN_NUM_FORMS': 0,
          'servings-MAX_NUM_FORMS': 1000,
          'servings-0-id': 123,
          'servings-0-servings_per_container': null,
          'servings-0-household_quantity': '1/4',
          'servings-0-measure_unit': 'chips',
          'servings-0-serving_size': '83',
          'servings-0-serving_size_unit': 'ml',
          'food-TOTAL_FORMS': 0,
          'food-INITIAL_FORMS': 0,
          'food-MIN_NUM_FORMS': 0,
          'food-MAX_NUM_FORMS': 1000,
          'recipe-TOTAL_FORMS': 0,
          'recipe-INITIAL_FORMS': 0,
          'recipe-MIN_NUM_FORMS': 0,
          'recipe-MAX_NUM_FORMS': 1000
        };
        expect(form.convertToMap(), equals(expected));
      });

      test('RecipeForm with values changed portions and members', () {
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

        final form = RecipeForm(
          userRecipe: userRecipe,
          externalId: userRecipe.externalId,
          name: userRecipe.name,
          recipeDate: userRecipe.recipeDate,
          portions: [
            FoodPortionForm(
              id: constants.testPortionId,
              householdQuantity: constants.testPortionHouseholdQuantity,
              householdUnit: constants.testPortionHouseholdUnit,
              servingSize: '83',
              servingSizeUnit: 'ml',
            )
          ],
          ingredientMembers: [
            FoodMemberForm(
              childExternalId: constants.testUUID,
              serving: constants.testPortionExternalId,
              quantity: '2',
            )
          ],
          recipeMembers: [
            FoodMemberForm(
              childExternalId: constants.testUUID,
              serving: constants.testPortionExternalId,
              quantity: '4',
            )
          ],
        );

        final expected = <String, dynamic>{
          'external_id': '52aa70fd-556d-46eb-acb8-40898814e83e',
          'name': 'test_recipe',
          'recipe_date': '2022-03-03',
          'servings-TOTAL_FORMS': 1,
          'servings-INITIAL_FORMS': 1,
          'servings-MIN_NUM_FORMS': 0,
          'servings-MAX_NUM_FORMS': 1000,
          'servings-0-id': 123,
          'servings-0-servings_per_container': null,
          'servings-0-household_quantity': '1/4',
          'servings-0-measure_unit': 'chips',
          'servings-0-serving_size': '83',
          'servings-0-serving_size_unit': 'ml',
          'food-TOTAL_FORMS': 1,
          'food-INITIAL_FORMS': 0,
          'food-MIN_NUM_FORMS': 0,
          'food-MAX_NUM_FORMS': 1000,
          'food-0-id': null,
          'food-0-child_external_id': '52aa70fd-556d-46eb-acb8-40898814e83e',
          'food-0-serving': '7cb00293-49b1-4ecf-a364-2c9c51f4fb08',
          'food-0-quantity': '2',
          'recipe-TOTAL_FORMS': 1,
          'recipe-INITIAL_FORMS': 0,
          'recipe-MIN_NUM_FORMS': 0,
          'recipe-MAX_NUM_FORMS': 1000,
          'recipe-0-id': null,
          'recipe-0-child_external_id': '52aa70fd-556d-46eb-acb8-40898814e83e',
          'recipe-0-serving': '7cb00293-49b1-4ecf-a364-2c9c51f4fb08',
          'recipe-0-quantity': '4',
        };
        expect(form.convertToMap(), equals(expected));
      });
    });
  });
}
