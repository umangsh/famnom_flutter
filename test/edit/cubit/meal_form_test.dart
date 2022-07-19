import 'package:app_repository/app_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:famnom_flutter/edit/edit.dart';
import 'package:test/test.dart';

void main() {
  group('MealForm', () {
    group('convertToMap', () {
      test('empty MealForm', () {
        final form = MealForm();
        final expected = <String, dynamic>{
          'external_id': null,
          'meal_type': null,
          'meal_date': null,
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

      test('RecipeForm with values changed members', () {
        const userMeal = UserMealMutable(
          externalId: constants.testUUID,
          mealDate: constants.testMealDate,
          mealType: constants.testMealType,
        );

        final form = MealForm(
          userMeal: userMeal,
          externalId: userMeal.externalId,
          mealType: userMeal.mealType,
          mealDate: userMeal.mealDate,
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
          'meal_type': 'Suhur',
          'meal_date': '2022-02-04',
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
