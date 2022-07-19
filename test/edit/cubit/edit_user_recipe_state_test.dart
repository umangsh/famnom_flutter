import 'package:app_repository/app_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter_test/flutter_test.dart';
import 'package:famnom_flutter/edit/edit.dart';

void main() {
  group('EditUserRecipeState', () {
    test('supports value comparisons', () {
      expect(const EditUserRecipeState(), const EditUserRecipeState());
    });

    test('returns same object when no properties are passed', () {
      expect(
        const EditUserRecipeState().copyWith(),
        const EditUserRecipeState(),
      );
    });

    test('returns object with updated status when status is passed', () {
      expect(
        const EditUserRecipeState()
            .copyWith(status: EditUserRecipeStatus.requestSubmitted),
        const EditUserRecipeState(
          status: EditUserRecipeStatus.requestSubmitted,
        ),
      );
    });

    test('returns object with updated user recipe when it is passed', () {
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
      expect(
        const EditUserRecipeState().copyWith(userRecipe: userRecipe),
        const EditUserRecipeState(userRecipe: userRecipe),
      );
    });

    test('returns object with updated app constants when it is passed', () {
      expect(
        const EditUserRecipeState()
            .copyWith(appConstants: const AppConstants()),
        const EditUserRecipeState(appConstants: AppConstants()),
      );
    });

    test('returns object with updated form when it is passed', () {
      expect(
        const EditUserRecipeState().copyWith(form: RecipeForm()),
        EditUserRecipeState(form: RecipeForm()),
      );
    });

    test('returns object with updated redirect external ID when it is passed',
        () {
      expect(
        const EditUserRecipeState()
            .copyWith(redirectExternalId: constants.testUUID),
        const EditUserRecipeState(redirectExternalId: constants.testUUID),
      );
    });
  });
}
