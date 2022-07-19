import 'package:constants/constants.dart' as constants;
import 'package:famnom_api/famnom_api.dart';
import 'package:test/test.dart';

void main() {
  group('LabelResponse', () {
    group('fromJson', () {
      test('returns LabelResponse with values', () {
        expect(
          LabelResponse.fromJson(
            const <String, dynamic>{
              'results': [
                {
                  'id': constants.testNutrientId,
                  'name': constants.testNutrientName,
                  'unit': constants.testNutrientUnit,
                },
              ],
            },
          ),
          isA<LabelResponse>().having(
            (LabelResponse s) => s.results.length,
            'number of label nutrients',
            equals(1),
          ),
        );
      });
    });
  });
}
