import 'package:constants/constants.dart' as constants;
import 'package:famnom_api/famnom_api.dart';
import 'package:test/test.dart';

void main() {
  group('FdaRdiResponse', () {
    group('fromJson', () {
      test('returns FdaRdiResponse with values', () {
        expect(
          FdaRdiResponse.fromJson(
            const <String, dynamic>{
              'results': {
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
            },
          ),
          isA<FdaRdiResponse>().having(
            (FdaRdiResponse s) => s.results.length,
            'number of RDI maps',
            equals(2),
          ),
        );
      });
    });
  });
}
