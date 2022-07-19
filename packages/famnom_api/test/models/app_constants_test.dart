import 'package:constants/constants.dart' as constants;
import 'package:famnom_api/famnom_api.dart';
import 'package:test/test.dart';

void main() {
  group('AppConstants', () {
    group('fromJson', () {
      test('returns AppConstants with values', () {
        expect(
          AppConstants.fromJson(
            const <String, dynamic>{
              'fda_rdis': {
                '1': <String, dynamic>{
                  '${constants.testNutrientId}': <String, dynamic>{
                    'value': constants.testNutrientAmount,
                    'threshold': '3',
                    'name': constants.testNutrientName,
                    'unit': constants.testNutrientUnit,
                  },
                },
                '2': <String, dynamic>{
                  '${constants.testNutrientId}': <String, dynamic>{
                    'value': constants.testNutrientAmount,
                    'threshold': '1',
                    'name': constants.testNutrientName,
                    'unit': constants.testNutrientUnit,
                  },
                },
              },
              'label_nutrients': [
                {
                  'id': constants.testNutrientId,
                  'name': constants.testNutrientName,
                  'unit': constants.testNutrientUnit,
                },
              ],
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
                  'id': '1/6',
                  'name': '1/6',
                }
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
