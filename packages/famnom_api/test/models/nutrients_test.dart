import 'package:constants/constants.dart' as constants;
import 'package:famnom_api/famnom_api.dart';
import 'package:test/test.dart';

void main() {
  group('Nutrient', () {
    group('fromJson', () {
      test('returns Nutrient with values', () {
        expect(
          Nutrient.fromJson(
            const <String, dynamic>{
              'id': constants.testNutrientId,
              'name': constants.testNutrientName,
              'amount': constants.testNutrientAmount,
              'unit': constants.testNutrientUnit
            },
          ),
          isA<Nutrient>()
              .having(
                (Nutrient s) => s.id,
                'id',
                equals(constants.testNutrientId),
              )
              .having(
                (Nutrient s) => s.name,
                'name',
                equals(constants.testNutrientName),
              )
              .having(
                (Nutrient s) => s.amount,
                'amount',
                equals(constants.testNutrientAmount),
              )
              .having(
                (Nutrient s) => s.unit,
                'unit',
                equals(constants.testNutrientUnit),
              ),
        );
      });
    });
  });

  group('Nutrients', () {
    group('fromJson', () {
      test('returns Nutrients with values', () {
        expect(
          Nutrients.fromJson(
            const <String, dynamic>{
              'serving_size': constants.testNutrientServingSize,
              'serving_size_unit': constants.testNutrientServingSizeUnit,
              'values': [
                {
                  'id': constants.testNutrientId,
                  'name': constants.testNutrientName,
                  'amount': constants.testNutrientAmount,
                  'unit': constants.testNutrientUnit
                }
              ]
            },
          ),
          isA<Nutrients>()
              .having(
                (Nutrients s) => s.servingSize,
                'serving size',
                equals(constants.testNutrientServingSize),
              )
              .having(
                (Nutrients s) => s.servingSizeUnit,
                'serving size unit',
                equals(constants.testNutrientServingSizeUnit),
              )
              .having(
                (Nutrients s) => s.values.length,
                'values length',
                equals(1),
              ),
        );
      });
    });

    group('NutrientPage', () {
      group('fromJson', () {
        test('returns NutrientPage with values', () {
          expect(
            NutrientPage.fromJson(
              const <String, dynamic>{
                'id': constants.testNutrientId,
                'name': constants.testNutrientName,
                'unit': constants.testNutrientUnit,
                'description': constants.testNutrientDescription,
              },
            ),
            isA<NutrientPage>()
                .having(
                  (NutrientPage s) => s.id,
                  'id',
                  equals(constants.testNutrientId),
                )
                .having(
                  (NutrientPage s) => s.name,
                  'name',
                  equals(constants.testNutrientName),
                )
                .having(
                  (NutrientPage s) => s.description,
                  'description',
                  equals(constants.testNutrientDescription),
                )
                .having(
                  (NutrientPage s) => s.unit,
                  'unit',
                  equals(constants.testNutrientUnit),
                ),
          );
        });
      });
    });
  });
}
