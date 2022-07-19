import 'package:constants/constants.dart' as constants;
import 'package:famnom_api/famnom_api.dart';
import 'package:test/test.dart';

void main() {
  group('MyMealsResponse', () {
    group('fromJson', () {
      test('returns empty MyMealsResponse', () {
        expect(
          MyMealsResponse.fromJson(
            const <String, dynamic>{
              'count': 0,
              'next': null,
              'previous': null,
              'results': <UserRecipeDisplay>[],
            },
          ),
          isA<MyMealsResponse>()
              .having(
                (MyMealsResponse s) => s.count,
                'count',
                equals(0),
              )
              .having(
                (MyMealsResponse s) => s.next,
                'next',
                isNull,
              )
              .having(
                (MyMealsResponse s) => s.previous,
                'previous',
                isNull,
              )
              .having(
                (MyMealsResponse s) => s.results,
                'results',
                isEmpty,
              ),
        );
      });

      test('returns MyMealsResponse with values', () {
        expect(
          MyMealsResponse.fromJson(
            const <String, dynamic>{
              'count': 1,
              'next': 'next',
              'previous': 'previous',
              'results': [
                {
                  'external_id': constants.testUUID,
                  'meal_date': constants.testMealDate,
                  'meal_type': constants.testMealType,
                }
              ],
            },
          ),
          isA<MyMealsResponse>()
              .having(
                (MyMealsResponse s) => s.count,
                'count',
                equals(1),
              )
              .having(
                (MyMealsResponse s) => s.next,
                'next',
                equals('next'),
              )
              .having(
                (MyMealsResponse s) => s.previous,
                'previous',
                equals('previous'),
              )
              .having(
                (MyMealsResponse s) => s.results.length,
                'results length',
                equals(1),
              ),
        );
      });
    });
  });
}
