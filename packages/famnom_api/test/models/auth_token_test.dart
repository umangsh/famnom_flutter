import 'package:constants/constants.dart' as constants;
import 'package:famnom_api/famnom_api.dart';
import 'package:test/test.dart';

void main() {
  group('AuthToken', () {
    group('fromJson', () {
      test('returns AuthToken', () {
        expect(
          AuthToken.fromJson(
            const <String, dynamic>{
              'key': constants.testAuthTokenKey,
            },
          ),
          isA<AuthToken>().having(
            (AuthToken a) => a.key,
            'key',
            equals(constants.testAuthTokenKey),
          ),
        );
      });
    });
  });
}
