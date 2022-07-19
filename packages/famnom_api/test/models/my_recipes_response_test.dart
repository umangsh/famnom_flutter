import 'package:constants/constants.dart' as constants;
import 'package:famnom_api/famnom_api.dart';
import 'package:test/test.dart';

void main() {
  group('MyRecipesResponse', () {
    group('fromJson', () {
      test('returns empty MyRecipesResponse', () {
        expect(
          MyRecipesResponse.fromJson(
            const <String, dynamic>{
              'count': 0,
              'next': null,
              'previous': null,
              'results': <UserRecipeDisplay>[],
            },
          ),
          isA<MyRecipesResponse>()
              .having(
                (MyRecipesResponse s) => s.count,
                'count',
                equals(0),
              )
              .having(
                (MyRecipesResponse s) => s.next,
                'next',
                isNull,
              )
              .having(
                (MyRecipesResponse s) => s.previous,
                'previous',
                isNull,
              )
              .having(
                (MyRecipesResponse s) => s.results,
                'results',
                isEmpty,
              ),
        );
      });

      test('returns MyRecipesResponse with values', () {
        expect(
          MyRecipesResponse.fromJson(
            const <String, dynamic>{
              'count': 1,
              'next': 'next',
              'previous': 'previous',
              'results': [
                {
                  'external_id': constants.testUUID,
                  'name': constants.testRecipeName,
                  'recipe_date': constants.testRecipeDate,
                }
              ],
            },
          ),
          isA<MyRecipesResponse>()
              .having(
                (MyRecipesResponse s) => s.count,
                'count',
                equals(1),
              )
              .having(
                (MyRecipesResponse s) => s.next,
                'next',
                equals('next'),
              )
              .having(
                (MyRecipesResponse s) => s.previous,
                'previous',
                equals('previous'),
              )
              .having(
                (MyRecipesResponse s) => s.results.length,
                'results length',
                equals(1),
              ),
        );
      });
    });
  });
}
