import 'package:app_repository/app_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:test/test.dart';

void main() {
  group('UserMemberRecipeDisplay', () {
    group('fromJson', () {
      test('returns UserMemberRecipeDisplay with values', () {
        expect(
          UserMemberRecipeDisplay.fromJson(const <String, dynamic>{
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
          }),
          isA<UserMemberRecipeDisplay>()
              .having(
                (UserMemberRecipeDisplay s) => s.externalId,
                'external id',
                equals(constants.testUUID),
              )
              .having(
                (UserMemberRecipeDisplay s) => s.recipe.externalId,
                'Recipe external ID',
                equals(constants.testUUID),
              )
              .having(
                (UserMemberRecipeDisplay s) => s.recipe.name,
                'Recipe name',
                equals(constants.testRecipeName),
              )
              .having(
                (UserMemberRecipeDisplay s) => s.recipe.recipeDate,
                'Recipe date',
                equals(constants.testRecipeDate),
              )
              .having(
                (UserMemberRecipeDisplay s) => s.portion,
                'portion',
                isNotNull,
              ),
        );
      });
    });
  });
}
