import 'package:constants/constants.dart' as constants;
import 'package:famnom_api/famnom_api.dart';
import 'package:test/test.dart';

void main() {
  group('MyFoodsResponse', () {
    group('fromJson', () {
      test('returns empty MyFoodsResponse', () {
        expect(
          MyFoodsResponse.fromJson(
            const <String, dynamic>{
              'count': 0,
              'next': null,
              'previous': null,
              'results': <UserIngredientDisplay>[],
            },
          ),
          isA<MyFoodsResponse>()
              .having(
                (MyFoodsResponse s) => s.count,
                'count',
                equals(0),
              )
              .having(
                (MyFoodsResponse s) => s.next,
                'next',
                isNull,
              )
              .having(
                (MyFoodsResponse s) => s.previous,
                'previous',
                isNull,
              )
              .having(
                (MyFoodsResponse s) => s.results,
                'results',
                isEmpty,
              ),
        );
      });

      test('returns MyFoodsResponse with values', () {
        expect(
          MyFoodsResponse.fromJson(
            const <String, dynamic>{
              'count': 1,
              'next': 'next',
              'previous': 'previous',
              'results': [
                {
                  'external_id': constants.testUUID,
                  'display_name': constants.testFoodName,
                  'display_brand': {
                    'brand_owner': constants.testBrandOwner,
                    'brand_name': constants.testBrandName,
                  }
                }
              ],
            },
          ),
          isA<MyFoodsResponse>()
              .having(
                (MyFoodsResponse s) => s.count,
                'count',
                equals(1),
              )
              .having(
                (MyFoodsResponse s) => s.next,
                'next',
                equals('next'),
              )
              .having(
                (MyFoodsResponse s) => s.previous,
                'previous',
                equals('previous'),
              )
              .having(
                (MyFoodsResponse s) => s.results.length,
                'results length',
                equals(1),
              ),
        );
      });
    });
  });
}
