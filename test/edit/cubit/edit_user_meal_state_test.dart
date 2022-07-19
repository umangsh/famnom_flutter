import 'package:app_repository/app_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:flutter_test/flutter_test.dart';
import 'package:famnom_flutter/edit/edit.dart';

void main() {
  group('EditUserMealState', () {
    test('supports value comparisons', () {
      expect(const EditUserMealState(), const EditUserMealState());
    });

    test('returns same object when no properties are passed', () {
      expect(
        const EditUserMealState().copyWith(),
        const EditUserMealState(),
      );
    });

    test('returns object with updated status when status is passed', () {
      expect(
        const EditUserMealState()
            .copyWith(status: EditUserMealStatus.requestSubmitted),
        const EditUserMealState(
          status: EditUserMealStatus.requestSubmitted,
        ),
      );
    });

    test('returns object with updated user meal when it is passed', () {
      const userMeal = UserMealMutable(
        externalId: constants.testUUID,
        mealType: constants.testMealType,
        mealDate: constants.testMealDate,
      );
      expect(
        const EditUserMealState().copyWith(userMeal: userMeal),
        const EditUserMealState(userMeal: userMeal),
      );
    });

    test('returns object with updated app constants when it is passed', () {
      expect(
        const EditUserMealState().copyWith(appConstants: const AppConstants()),
        const EditUserMealState(appConstants: AppConstants()),
      );
    });

    test('returns object with updated form when it is passed', () {
      expect(
        const EditUserMealState().copyWith(form: MealForm()),
        EditUserMealState(form: MealForm()),
      );
    });

    test('returns object with updated redirect external ID when it is passed',
        () {
      expect(
        const EditUserMealState()
            .copyWith(redirectExternalId: constants.testUUID),
        const EditUserMealState(redirectExternalId: constants.testUUID),
      );
    });
  });
}
