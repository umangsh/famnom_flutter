import 'package:flutter_test/flutter_test.dart';
import 'package:famnom_flutter/search/search.dart';
import 'package:search_repository/search_repository.dart';

void main() {
  group('SearchState', () {
    test('supports value comparisons', () {
      expect(const SearchState(), const SearchState());
    });

    test('returns same object when no properties are passed', () {
      expect(const SearchState().copyWith(), const SearchState());
    });

    test('returns object with updated status when status is passed', () {
      expect(
        const SearchState().copyWith(status: SearchStatus.init),
        const SearchState(),
      );
    });

    test('returns object with updated autocomplete results when it is passed',
        () {
      final results = [
        const AutocompleteResult(query: 'query', timestamp: 1),
        const AutocompleteResult(query: 'query2', timestamp: 2)
      ];
      expect(
        const SearchState().copyWith(autocompleteResults: results),
        SearchState(autocompleteResults: results),
      );
    });

    test('returns object with updated search results when it is passed', () {
      final results = [
        const SearchResult(
          externalId: 'externalId',
          name: 'name',
          url: 'url',
        ),
        const SearchResult(
          externalId: 'externalId2',
          name: 'name2',
          url: 'url2',
        ),
      ];
      expect(
        const SearchState().copyWith(searchResults: results),
        SearchState(searchResults: results),
      );
    });
  });
}
