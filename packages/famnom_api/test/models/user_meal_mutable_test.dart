import 'package:constants/constants.dart' as constants;
import 'package:famnom_api/famnom_api.dart';
import 'package:test/test.dart';

void main() {
  group('UserMealMutable', () {
    group('fromJson', () {
      test('returns UserMealMutable with values', () {
        expect(
          UserMealMutable.fromJson(
            const <String, dynamic>{
              'external_id': constants.testUUID,
              'meal_type': constants.testMealType,
              'meal_date': constants.testMealDate,
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
          isA<UserMealMutable>()
              .having(
                (UserMealMutable s) => s.externalId,
                'external id',
                equals(constants.testUUID),
              )
              .having(
                (UserMealMutable s) => s.mealType,
                'meal type',
                equals(constants.testMealType),
              )
              .having(
                (UserMealMutable s) => s.mealDate,
                'meal date',
                equals(constants.testMealDate),
              )
              .having(
                (UserMealMutable s) => s.memberIngredients!.length,
                'member foods length',
                equals(1),
              )
              .having(
                (UserMealMutable s) => s.memberRecipes!.length,
                'member recipes length',
                equals(1),
              ),
        );
      });
    });
  });
}
