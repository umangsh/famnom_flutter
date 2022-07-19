import 'package:clock/clock.dart';
import 'package:constants/constants.dart' as constants;
import 'package:environments/environment.dart';
import 'package:famnom_api/famnom_api.dart' as famnom_api;
import 'package:mocktail/mocktail.dart';
import 'package:search_repository/search_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

class MockFamnomApiClient extends Mock implements famnom_api.FamnomApiClient {}

class MockFamnomApiSearchResponse extends Mock
    implements famnom_api.SearchResponse {}

class MockFamnomApiAuthToken extends Mock implements famnom_api.AuthToken {}

void main() {
  group('SearchRepository', () {
    late famnom_api.FamnomApiClient famnomApiClient;
    late SearchRepository searchRepository;

    setUpAll(() {
      Environment().initConfig(Environment.dev);
    });

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      famnomApiClient = MockFamnomApiClient();
      searchRepository = SearchRepository(
        famnomApiClient: famnomApiClient,
      );
    });

    group('constructor', () {
      test('instantiates internal FamnomApiClient when not injected', () {
        expect(SearchRepository(), isNotNull);
      });
    });

    group('searchWithQuery empty query', () {
      test('calls with key', () async {
        try {
          await searchRepository.searchWithQuery();
        } catch (_) {}
        verify(
          () => famnomApiClient.search(any(), any(), any()),
        ).called(1);
      });
    });

    group('searchWithQuery with query', () {
      test('calls with key', () async {
        try {
          await searchRepository.searchWithQuery(query: constants.testQuery);
        } catch (_) {}
        verify(
          () => famnomApiClient.search(any(), any(), any()),
        ).called(1);
      });

      test('throws when search request fails', () async {
        final exception = famnom_api.searchFailedGeneric();
        when(() => famnomApiClient.search(any(), any(), any()))
            .thenThrow(exception);
        expect(
          () async => searchRepository.searchWithQuery(
            query: constants.testQuery,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is SearchFailure &&
                  x.message == 'Search request failed. Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(() => famnomApiClient.search(any(), any(), any()))
            .thenThrow(exception);
        expect(
          () async => searchRepository.searchWithQuery(
            query: constants.testQuery,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is SearchFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });
    });

    group('searchWithURI', () {
      test('calls with key', () async {
        try {
          await searchRepository.searchWithURI();
        } catch (_) {}
        verify(
          () => famnomApiClient.search(any(), any(), any()),
        ).called(1);
      });

      test('throws when search request fails', () async {
        final exception = famnom_api.searchFailedGeneric();
        when(() => famnomApiClient.search(any(), any(), any()))
            .thenThrow(exception);
        expect(
          () async => searchRepository.searchWithURI(),
          throwsA(
            predicate(
              (x) =>
                  x is SearchFailure &&
                  x.message == 'Search request failed. Please try again later.',
            ),
          ),
        );
      });

      test('throws when auth token malformed', () async {
        final exception = famnom_api.storedAuthTokenEmpty();
        when(() => famnomApiClient.search(any(), any(), any()))
            .thenThrow(exception);
        expect(
          () async => searchRepository.searchWithURI(),
          throwsA(
            predicate(
              (x) =>
                  x is SearchFailure &&
                  x.message == 'Something went wrong. Please login again.',
            ),
          ),
        );
      });
    });

    group('getAutocompleteResults', () {
      test('get results', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList(
          constants.prefAutocompleteSuggestions,
          [
            '''
            {
              "query": "query1",
              "timestamp": 1234
            }
            ''',
            '''
            {
              "query": "query2",
              "timestamp": 2345
            }
            ''',
          ],
        );

        final expected = await searchRepository.getAutocompleteResults();
        expect(
          expected,
          isA<List<AutocompleteResult>>().having((List l) => l, 'items', const [
            AutocompleteResult(query: 'query1', timestamp: 1234),
            AutocompleteResult(query: 'query2', timestamp: 2345),
          ]),
        );
      });
    });

    group('updateAutocompleteResults', () {
      test('update successful new query', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList(
          constants.prefAutocompleteSuggestions,
          [
            '''
            {
              "query": "query1",
              "timestamp": 1234
            }
            ''',
            '''
            {
              "query": "query2",
              "timestamp": 2345
            }
            ''',
          ],
        );

        await withClock(
          Clock.fixed(DateTime(2022, 05, 02)),
          () async => searchRepository.updateAutocompleteResults('query3'),
        );

        final expected = await searchRepository.getAutocompleteResults();
        expect(
          expected,
          isA<List<AutocompleteResult>>().having((List l) => l, 'items', const [
            AutocompleteResult(query: 'query3', timestamp: 1651474800000),
            AutocompleteResult(query: 'query1', timestamp: 1234),
            AutocompleteResult(query: 'query2', timestamp: 2345),
          ]),
        );
      });

      test('update successful old query', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList(
          constants.prefAutocompleteSuggestions,
          [
            '''
            {
              "query": "query1",
              "timestamp": 1234
            }
            ''',
            '''
            {
              "query": "query2",
              "timestamp": 2345
            }
            ''',
          ],
        );

        await withClock(
          Clock.fixed(DateTime(2022, 05, 02)),
          () async => searchRepository.updateAutocompleteResults('query2'),
        );

        final expected = await searchRepository.getAutocompleteResults();
        expect(
          expected,
          isA<List<AutocompleteResult>>().having((List l) => l, 'items', const [
            AutocompleteResult(query: 'query2', timestamp: 1651474800000),
            AutocompleteResult(query: 'query1', timestamp: 1234),
          ]),
        );
      });
    });

    test('update successful new query exceeds maxsuggestions', () async {
      searchRepository.maxSuggestions = 1;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        constants.prefAutocompleteSuggestions,
        [
          '''
            {
              "query": "query1",
              "timestamp": 1234
            }
            ''',
        ],
      );

      await withClock(
        Clock.fixed(DateTime(2022, 05, 02)),
        () async => searchRepository.updateAutocompleteResults('query3'),
      );

      final expected = await searchRepository.getAutocompleteResults();
      expect(
        expected,
        isA<List<AutocompleteResult>>().having((List l) => l, 'items', const [
          AutocompleteResult(query: 'query3', timestamp: 1651474800000),
        ]),
      );
    });

    test('update successful old query exceeds maxsuggestions', () async {
      searchRepository.maxSuggestions = 1;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        constants.prefAutocompleteSuggestions,
        [
          '''
            {
              "query": "query2",
              "timestamp": 2345
            }
            ''',
        ],
      );

      await withClock(
        Clock.fixed(DateTime(2022, 05, 02)),
        () async => searchRepository.updateAutocompleteResults('query2'),
      );

      final expected = await searchRepository.getAutocompleteResults();
      expect(
        expected,
        isA<List<AutocompleteResult>>().having((List l) => l, 'items', const [
          AutocompleteResult(query: 'query2', timestamp: 1651474800000),
        ]),
      );
    });
  });
}
