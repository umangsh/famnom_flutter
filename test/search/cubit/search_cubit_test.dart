import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:famnom_flutter/search/search.dart';
import 'package:search_repository/search_repository.dart';

class MockSearchRepository extends Mock implements SearchRepository {}

void main() {
  final autoCompleteResults = [
    const AutocompleteResult(query: 'query', timestamp: 1),
    const AutocompleteResult(query: 'sample', timestamp: 2),
  ];
  final searchResults = [
    const SearchResult(externalId: 'externalId', name: 'name', url: 'url')
  ];
  group('SearchCubit', () {
    late SearchRepository searchRepository;

    setUp(() {
      searchRepository = MockSearchRepository();
      when(
        () => searchRepository.getAutocompleteResults(),
      ).thenAnswer(
        (_) async => autoCompleteResults,
      );
      when(
        () => searchRepository.updateAutocompleteResults(any()),
      ).thenAnswer(
        (_) async {},
      );
    });

    test('initial state is SearchState', () {
      expect(SearchCubit(searchRepository).state, const SearchState());
    });

    group('clearSearchBar', () {
      blocTest<SearchCubit, SearchState>(
        'emits [autocomplete] and resets search '
        'results when search bar is cleared',
        build: () => SearchCubit(searchRepository),
        act: (cubit) => cubit.clearSearchBar(),
        expect: () => const <SearchState>[
          SearchState(status: SearchStatus.autocomplete),
        ],
      );
    });

    group('scannerInit', () {
      blocTest<SearchCubit, SearchState>(
        'emits [barcodeRequest] and resets search and autocomplete results',
        build: () => SearchCubit(searchRepository),
        act: (cubit) => cubit.scannerInit(),
        expect: () => const <SearchState>[
          SearchState(status: SearchStatus.barcodeRequest),
        ],
      );
    });

    group('getAutocompleteResults', () {
      blocTest<SearchCubit, SearchState>(
        'emits [autocomplete] and autocomplete results',
        build: () => SearchCubit(searchRepository),
        act: (cubit) => cubit.getAutocompleteResults(),
        expect: () => <SearchState>[
          SearchState(
            status: SearchStatus.autocomplete,
            autocompleteResults: autoCompleteResults,
          ),
        ],
      );

      blocTest<SearchCubit, SearchState>(
        'emits [autocomplete] and filter autocomplete results',
        build: () => SearchCubit(searchRepository),
        act: (cubit) => cubit.getAutocompleteResults(query: 'SAM'),
        expect: () => <SearchState>[
          const SearchState(
            status: SearchStatus.autocomplete,
            autocompleteResults: [
              AutocompleteResult(query: 'sample', timestamp: 2),
            ],
          ),
        ],
      );
    });

    group('getSearchResultsWithQuery', () {
      blocTest<SearchCubit, SearchState>(
        'emits [requestSubmitted] and clears autocomplete results, '
        'emits [requestFinishedEmptyResults] and search results empty',
        setUp: () {
          when(
            () => searchRepository.searchWithQuery(query: any(named: 'query')),
          ).thenAnswer(
            (_) async => [],
          );
        },
        build: () => SearchCubit(searchRepository),
        act: (cubit) => cubit.getSearchResultsWithQuery(query: 'query'),
        expect: () => <SearchState>[
          const SearchState(status: SearchStatus.requestSubmitted),
          const SearchState(status: SearchStatus.requestFinishedEmptyResults),
        ],
      );

      blocTest<SearchCubit, SearchState>(
        'emits [requestSubmitted] and clears autocomplete results, '
        'emits [requestFinishedWithResults] and search results not empty',
        setUp: () {
          when(
            () => searchRepository.searchWithQuery(query: any(named: 'query')),
          ).thenAnswer(
            (_) async => searchResults,
          );
        },
        build: () => SearchCubit(searchRepository),
        act: (cubit) => cubit.getSearchResultsWithQuery(query: 'query'),
        expect: () => <SearchState>[
          const SearchState(status: SearchStatus.requestSubmitted),
          SearchState(
            status: SearchStatus.requestFinishedWithResults,
            searchResults: searchResults,
          ),
        ],
      );

      blocTest<SearchCubit, SearchState>(
        'emits [requestSubmitted] and clears autocomplete results, '
        'emits [requestFailure] and search request throws',
        setUp: () {
          when(
            () => searchRepository.searchWithQuery(query: any(named: 'query')),
          ).thenThrow(const SearchFailure());
        },
        build: () => SearchCubit(searchRepository),
        act: (cubit) => cubit.getSearchResultsWithQuery(query: 'query'),
        expect: () => <SearchState>[
          const SearchState(status: SearchStatus.requestSubmitted),
          const SearchState(
            status: SearchStatus.requestFailure,
            errorMessage: 'Something went wrong. Please try again later.',
          ),
        ],
      );
    });

    group('getMoreSearchResults', () {
      blocTest<SearchCubit, SearchState>(
        'emits [requestMoreFinishedEmptyResults] and search results empty',
        setUp: () {
          when(
            () => searchRepository.searchWithURI(),
          ).thenAnswer(
            (_) async => [],
          );
        },
        build: () => SearchCubit(searchRepository),
        act: (cubit) => cubit.getMoreSearchResults(),
        expect: () => <SearchState>[
          const SearchState(
            status: SearchStatus.requestMoreFinishedEmptyResults,
          ),
        ],
      );

      blocTest<SearchCubit, SearchState>(
        'emits [requestMoreFinishedWithResults] and search results not empty, ',
        setUp: () {
          when(
            () => searchRepository.searchWithURI(),
          ).thenAnswer(
            (_) async => searchResults,
          );
        },
        build: () => SearchCubit(searchRepository),
        act: (cubit) => cubit.getMoreSearchResults(),
        expect: () => <SearchState>[
          SearchState(
            status: SearchStatus.requestMoreFinishedWithResults,
            searchResults: searchResults,
          ),
        ],
      );

      blocTest<SearchCubit, SearchState>(
        'emits [requestFailure] and search request throws',
        setUp: () {
          when(
            () => searchRepository.searchWithURI(),
          ).thenThrow(const SearchFailure());
        },
        build: () => SearchCubit(searchRepository),
        act: (cubit) => cubit.getMoreSearchResults(),
        expect: () => <SearchState>[
          const SearchState(
            status: SearchStatus.requestFailure,
            errorMessage: 'Something went wrong. Please try again later.',
          ),
        ],
      );
    });
  });
}
