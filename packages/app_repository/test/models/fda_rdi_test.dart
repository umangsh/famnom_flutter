import 'package:app_repository/app_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:test/test.dart';

void main() {
  group('FdaRdi', () {
    group('fromJson', () {
      test('returns FdaRdi object', () {
        expect(
          FdaRdi.fromJson(
            const <String, dynamic>{
              'id': constants.testNutrientId,
              'value': constants.testNutrientAmount,
              'threshold': constants.THRESHOLD_MORE_THAN,
              'name': constants.testNutrientName,
              'unit': constants.testNutrientUnit,
            },
          ),
          isA<FdaRdi>()
              .having(
                (FdaRdi a) => a.id,
                'nutrient ID',
                equals(constants.testNutrientId),
              )
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

    group('thresholdType', () {
      test('returns threshold type object', () {
        final fdaRDI = FdaRdi.fromJson(
          const <String, dynamic>{
            'id': constants.testNutrientId,
            'value': constants.testNutrientAmount,
            'threshold': constants.THRESHOLD_MORE_THAN,
            'name': constants.testNutrientName,
            'unit': constants.testNutrientUnit,
          },
        );
        expect(constants.THRESHOLD_MORE_THAN, fdaRDI.thresholdType);
      });
    });
  });
}
