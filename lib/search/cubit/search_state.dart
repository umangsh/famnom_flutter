part of 'search_cubit.dart';

enum SearchStatus {
  init,
  autocomplete,
  requestSubmitted,
  requestFinishedWithResults,
  requestFinishedEmptyResults,
  requestMoreFinishedWithResults,
  requestMoreFinishedEmptyResults,
  barcodeRequest,
  requestFailure,
}

class SearchState extends Equatable {
  const SearchState({
    this.status = SearchStatus.init,
    this.autocompleteResults = const <AutocompleteResult>[],
    this.searchResults = const <SearchResult>[],
    this.errorMessage,
  });

  final SearchStatus status;
  final List<AutocompleteResult> autocompleteResults;
  final List<SearchResult> searchResults;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, autocompleteResults, searchResults];

  SearchState copyWith({
    SearchStatus? status,
    List<AutocompleteResult>? autocompleteResults,
    List<SearchResult>? searchResults,
    String? errorMessage,
  }) {
    return SearchState(
      status: status ?? this.status,
      autocompleteResults: autocompleteResults ?? this.autocompleteResults,
      searchResults: searchResults ?? this.searchResults,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
