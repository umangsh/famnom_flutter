import 'package:constants/constants.dart' as constants;
import 'package:famnom_api/famnom_api.dart';
import 'package:test/test.dart';

void main() {
  group('UserMemberRecipeDisplay', () {
    group('fromJson', () {
      test('returns UserMemberRecipeDisplay with values', () {
        expect(
          UserMemberRecipeDisplay.fromJson(const <String, dynamic>{
            'external_id': constants.testUUID,
            'display_recipe': {
              'external_id': constants.testUUID,
              'name': constants.testRecipeName,
              'recipe_date': constants.testRecipeDate,
            },
            'display_portion': {
              'external_id': constants.testPortionExternalId,
              'name': constants.testPortionName,
              'serving_size': constants.testPortionSize,
              'serving_size_unit': constants.testPortionSizeUnit
            }
          }),
          isA<UserMemberRecipeDisplay>()
              .having(
                (UserMemberRecipeDisplay s) => s.externalId,
                'external id',
                equals(constants.testUUID),
              )
              .having(
                (UserMemberRecipeDisplay s) => s.displayRecipe.externalId,
                'display Recipe external ID',
                equals(constants.testUUID),
              )
              .having(
                (UserMemberRecipeDisplay s) => s.displayRecipe.name,
                'display Recipe name',
                equals(constants.testRecipeName),
              )
              .having(
                (UserMemberRecipeDisplay s) => s.displayRecipe.recipeDate,
                'display Recipe date',
                equals(constants.testRecipeDate),
              )
              .having(
                (UserMemberRecipeDisplay s) => s.displayPortion,
                'portion',
                isNotNull,
              ),
        );
      });
    });
  });
}
