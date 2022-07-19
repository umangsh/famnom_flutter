import 'package:constants/constants.dart' as constants;
import 'package:famnom_api/famnom_api.dart';
import 'package:test/test.dart';

void main() {
  group('FdaRdi', () {
    group('fromJson', () {
      test('returns FdaRdi object', () {
        expect(
          FdaRdi.fromJson(
            const <String, dynamic>{
              'value': constants.testNutrientAmount,
              'threshold': '3',
              'name': constants.testNutrientName,
              'unit': constants.testNutrientUnit,
            },
          ),
          isA<FdaRdi>()
              .having(
                (FdaRdi a) => a.value,
                'nutrient RDI value',
                equals(constants.testNutrientAmount),
              )
              .having(
                (FdaRdi a) => a.threshold,
                'nutrient RDI threshold',
                equals(Threshold.min),
              )
              .having(
                (FdaRdi a) => a.name,
                'nutrient name',
                equals(constants.testNutrientName),
              )
              .having(
                (FdaRdi a) => a.unit,
                'nutrient unit',
                equals(constants.testNutrientUnit),
              ),
        );
      });
    });
  });
}
