import 'package:constants/constants.dart' as constants;
import 'package:famnom_api/famnom_api.dart';
import 'package:test/test.dart';

void main() {
  group('SearchResponse', () {
    group('fromJson', () {
      test('returns empty SearchResponse', () {
        expect(
          SearchResponse.fromJson(
            const <String, dynamic>{
              'count': 0,
              'next': null,
              'previous': null,
              'results': <SearchResult>[],
            },
          ),
          isA<SearchResponse>()
              .having(
                (SearchResponse s) => s.count,
                'count',
                equals(0),
              )
              .having(
                (SearchResponse s) => s.next,
                'next',
                isNull,
              )
              .having(
                (SearchResponse s) => s.previous,
                'previous',
                isNull,
              )
              .having(
                (SearchResponse s) => s.results,
                'results',
                isEmpty,
              ),
        );
      });

      test('returns SearchResponse with values', () {
        expect(
          SearchResponse.fromJson(
            const <String, dynamic>{
              'count': 1,
              'next': 'next',
              'previous': 'previous',
              'results': [
                {
                  'external_id': constants.testUUID,
                  'dname': 'name',
                  'url': 'url',
                }
              ],
            },
          ),
          isA<SearchResponse>()
              .having(
                (SearchResponse s) => s.count,
                'count',
                equals(1),
              )
              .having(
                (SearchResponse s) => s.next,
                'next',
                equals('next'),
              )
              .having(
                (SearchResponse s) => s.previous,
                'previous',
                equals('previous'),
              )
              .having(
                (SearchResponse s) => s.results.length,
                'results length',
                equals(1),
              ),
        );
      });
    });
  });
}
