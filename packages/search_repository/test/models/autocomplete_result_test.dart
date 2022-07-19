import 'package:flutter_test/flutter_test.dart';
import 'package:search_repository/search_repository.dart';

void main() {
  group('AutocompleteResult', () {
    const query = 'mock-query';
    const timestamp = 1;

    group('fromJson', () {
      test('returns AutocompleteResult', () {
        expect(
          AutocompleteResult.fromJson(
            const <String, dynamic>{
              'query': query,
              'timestamp': timestamp,
            },
          ),
          isA<AutocompleteResult>()
              .having(
                (AutocompleteResult s) => s.query,
                'query',
                equals(query),
              )
              .having(
                (AutocompleteResult s) => s.timestamp,
                'timestamp',
                equals(timestamp),
              ),
        );
      });
    });

    group('toJson', () {
      test('returns json', () {
        const r = AutocompleteResult(query: query, timestamp: timestamp);
        expect(
          r.toJson(),
          equals(<String, dynamic>{'query': query, 'timestamp': timestamp}),
        );
      });
    });
  });
}
