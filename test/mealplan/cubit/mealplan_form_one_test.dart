import 'package:app_repository/app_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:famnom_flutter/mealplan/mealplan.dart';
import 'package:test/test.dart';

void main() {
  group('MealplanFormOne', () {
    group('convertToMap', () {
      test('MealplanFormOne with values', () {
        final form = MealplanFormOne(
          availableFoods: const [
            UserIngredientDisplay(
              externalId: constants.testUUID,
              name: constants.testFoodName,
            )
          ],
          dontHaveRecipes: const [
            UserRecipeDisplay(
              externalId: constants.testUUID,
              name: constants.testRecipeName,
            )
          ],
        );
        final expected = <String, dynamic>{
          'available_foods': [constants.testUUID],
          'available_recipes': null,
          'must_have_foods': null,
          'must_have_recipes': null,
          'dont_have_foods': null,
          'dont_have_recipes': [constants.testUUID],
          'dont_repeat_foods': null,
          'dont_repeat_recipes': null
        };
        expect(form.convertToMap(), equals(expected));
      });
    });
  });
}
