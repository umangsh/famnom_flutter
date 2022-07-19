import 'package:app_repository/app_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:test/test.dart';

void main() {
  group('UserRecipeMutable', () {
    group('fromJson', () {
      test('returns UserRecipeMutable with values', () {
        expect(
          UserRecipeMutable.fromJson(
            const <String, dynamic>{
              'external_id': constants.testUUID,
              'name': constants.testRecipeName,
              'recipe_date': constants.testRecipeDate,
              'portions': [
                {
                  'id': constants.testPortionId,
                  'external_id': constants.testPortionExternalId,
                  'servings_per_container':
                      constants.testPortionServingsPerContainer,
                  'household_quantity': constants.testPortionHouseholdQuantity,
                  'household_unit': constants.testPortionHouseholdUnit,
                  'serving_size': constants.testPortionSize,
                  'serving_size_unit': constants.testPortionSizeUnit,
                }
              ],
              'member_ingredients': [
                {
                  'id': constants.testPortionId,
                  'external_id': constants.testPortionExternalId,
                  'child_id': constants.testID,
                  'child_name': constants.testFoodName,
                  'child_external_id': constants.testUUID,
                  'child_portion_name': constants.testPortionName,
                  'child_portion_external_id': constants.testUUID,
                  'quantity': constants.testPortionSize,
                }
              ],
              'member_recipes': [
                {
                  'id': constants.testPortionId,
                  'external_id': constants.testPortionExternalId,
                  'child_id': constants.testID,
                  'child_name': constants.testRecipeName,
                  'child_external_id': constants.testUUID,
                  'child_portion_name': constants.testPortionName,
                  'child_portion_external_id': constants.testUUID,
                  'quantity': constants.testPortionSize,
                }
              ],
            },
          ),
          isA<UserRecipeMutable>()
              .having(
                (UserRecipeMutable s) => s.externalId,
                'external id',
                equals(constants.testUUID),
              )
              .having(
                (UserRecipeMutable s) => s.name,
                'name',
                equals(constants.testRecipeName),
              )
              .having(
                (UserRecipeMutable s) => s.recipeDate,
                'recipe date',
                equals(constants.testRecipeDate),
              )
              .having(
                (UserRecipeMutable s) => s.portions?.length,
                'portions length',
                equals(1),
              )
              .having(
                (UserRecipeMutable s) => s.memberIngredients!.length,
                'member foods length',
                equals(1),
              )
              .having(
                (UserRecipeMutable s) => s.memberRecipes!.length,
                'member recipes length',
                equals(1),
              ),
        );
      });
    });
  });
}
