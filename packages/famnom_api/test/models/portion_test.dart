import 'package:constants/constants.dart' as constants;
import 'package:famnom_api/famnom_api.dart';
import 'package:test/test.dart';

void main() {
  group('Portion', () {
    group('fromJson', () {
      test('returns Portion with values', () {
        expect(
          Portion.fromJson(
            const <String, dynamic>{
              'external_id': constants.testPortionExternalId,
              'name': constants.testPortionName,
              'serving_size': constants.testPortionSize,
              'serving_size_unit': constants.testPortionSizeUnit
            },
          ),
          isA<Portion>()
              .having(
                (Portion s) => s.externalId,
                'external id',
                equals(constants.testPortionExternalId),
              )
              .having(
                (Portion s) => s.name,
                'name',
                equals(constants.testPortionName),
              )
              .having(
                (Portion s) => s.servingSize,
                'serving size',
                equals(constants.testPortionSize),
              )
              .having(
                (Portion s) => s.servingSizeUnit,
                'serving size unit',
                equals(constants.testPortionSizeUnit),
              ),
        );
      });
    });
  });
}
