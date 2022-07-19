import 'package:constants/constants.dart' as constants;
import 'package:famnom_api/famnom_api.dart';
import 'package:test/test.dart';

void main() {
  group('MealplanItem', () {
    group('fromJson', () {
      test('returns MealplanItem object', () {
        expect(
          MealplanItem.fromJson(
            const <String, dynamic>{
              'external_id': constants.testUUID,
              'name': constants.testFoodName,
              'quantity': 123
            },
          ),
          isA<MealplanItem>()
              .having(
                (MealplanItem a) => a.externalId,
                'external ID',
                equals(constants.testUUID),
              )
              .having(
                (MealplanItem a) => a.name,
                'name',
                equals(constants.testFoodName),
              )
              .having(
                (MealplanItem a) => a.quantity,
                'quantity',
                equals(123),
              ),
        );
      });
    });
  });

  group('Mealplan', () {
    group('fromJson', () {
      test('returns Mealplan object', () {
        expect(
          Mealplan.fromJson(
            const <String, dynamic>{
              'infeasible': false,
              'results': [
                {
                  'external_id': constants.testUUID,
                  'name': constants.testFoodName,
                  'quantity': 123
                }
              ],
            },
          ),
          isA<Mealplan>()
              .having(
                (Mealplan a) => a.infeasible,
                'infeasible',
                equals(false),
              )
              .having(
                (Mealplan a) => a.results.length,
                'results length',
                equals(1),
              ),
        );
      });
    });
  });
}
