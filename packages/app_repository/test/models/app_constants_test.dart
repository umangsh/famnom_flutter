import 'package:app_repository/app_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:test/test.dart';

void main() {
  group('AppConstants', () {
    group('fromJson', () {
      test('returns AppConstants with values', () {
        expect(
          AppConstants.fromJson(
            const <String, dynamic>{
              'fda_rdis': {
                '1': {
                  '${constants.testNutrientId}': {
                    'id': constants.testNutrientId,
                    'value': constants.testNutrientAmount,
                    'threshold': '3',
                    'name': constants.testNutrientName,
                    'unit': constants.testNutrientUnit,
                  },
                },
                '2': {
                  '${constants.testNutrientId}': {
                    'id': constants.testNutrientId,
                    'value': constants.testNutrientAmount,
                    'threshold': '1',
                    'name': constants.testNutrientName,
                    'unit': constants.testNutrientUnit,
                  },
                },
              },
              'label_nutrients': {
                '${constants.testNutrientId}': {
                  'id': constants.testNutrientId,
                  'name': constants.testNutrientName,
                  'unit': constants.testNutrientUnit,
                },
              },
              'categories': [
                {
                  'id': constants.testCategoryId,
                  'name': constants.testCategoryName,
                },
              ],
              'household_quantities': [
                {
                  'id': '1/8',
                  'name': '1/8',
                },
                {
                  'id': '1/5',
                  'name': '1/5',
                },
              ],
              'household_units': [
                {
                  'id': '1066',
                  'name': 'back',
                },
                {
                  'id': '1088',
                  'name': 'bag',
                },
              ],
              'serving_size_units': [
                {
                  'id': '',
                  'name': 'Select unit',
                },
                {
                  'id': 'g',
                  'name': 'g',
                },
                {
                  'id': 'ml',
                  'name': 'ml',
                }
              ],
            },
          ),
          isA<AppConstants>()
              .having(
                (AppConstants s) => s.fdaRdis?.length,
                'number of RDI maps',
                equals(2),
              )
              .having(
                (AppConstants s) => s.labelNutrients?.length,
                'number of label nutrients',
                equals(1),
              )
              .having(
                (AppConstants s) => s.categories?.length,
                'number of categories',
                equals(1),
              )
              .having(
                (AppConstants s) => s.householdQuantities?.length,
                'number of household quantities',
                equals(2),
              )
              .having(
                (AppConstants s) => s.householdUnits?.length,
                'number of household units',
                equals(2),
              )
              .having(
                (AppConstants s) => s.servingSizeUnits?.length,
                'number of serving size units',
                equals(3),
              ),
        );
      });
    });
  });
}
