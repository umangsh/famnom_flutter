import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:search_repository/search_repository.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._searchRepository) : super(const SearchState());

  final SearchRepository _searchRepository;

  Future<void> clearSearchBar() async {
    emit(
      state.copyWith(
        status: SearchStatus.autocomplete,
        searchResults: [],
      ),
    );
  }

  Future<void> getAutocompleteResults({String? query}) async {
    var autocompleteResults = await _searchRepository.getAutocompleteResults();
    if (query != null) {
      autocompleteResults = autocompleteResults
          .where(
            (element) =>
                element.query.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    emit(
      state.copyWith(
        status: SearchStatus.autocomplete,
        autocompleteResults: autocompleteResults,
      ),
    );
  }

  Future<void> getSearchResultsWithQuery({
    String? query,
    String? barcode,
  }) async {
    if (query != null) {
      await _searchRepository.updateAutocompleteResults(query);
    }

    emit(
      state.copyWith(
        status: SearchStatus.requestSubmitted,
        autocompleteResults: [],
        searchResults: [],
      ),
    );

    try {
      final searchResults = await _searchRepository.searchWithQuery(
        query: query ?? barcode ?? '',
      );

      searchResults.isEmpty
          ? emit(
              state.copyWith(
                status: SearchStatus.requestFinishedEmptyResults,
                searchResults: searchResults,
              ),
            )
          : emit(
              state.copyWith(
                status: SearchStatus.requestFinishedWithResults,
                searchResults: searchResults,
              ),
            );
    } on SearchFailure catch (e) {
      emit(
        state.copyWith(
          status: SearchStatus.requestFailure,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: SearchStatus.requestFailure,
          errorMessage: 'Something went wrong, please try again.',
        ),
      );
    }
  }

  Future<void> getMoreSearchResults() async {
    try {
      final searchResults = await _searchRepository.searchWithURI();

      searchResults.isEmpty
          ? emit(
              state.copyWith(
                status: SearchStatus.requestMoreFinishedEmptyResults,
              ),
            )
          : emit(
              state.copyWith(
                status: SearchStatus.requestMoreFinishedWithResults,
                searchResults: state.searchResults + searchResults,
              ),
            );
    } on SearchFailure catch (e) {
      emit(
        state.copyWith(
          status: SearchStatus.requestFailure,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: SearchStatus.requestFailure,
          errorMessage: 'Something went wrong, please try again.',
        ),
      );
    }
  }

  Future<void> scannerInit() async {
    emit(
      state.copyWith(
        status: SearchStatus.barcodeRequest,
        autocompleteResults: [],
        searchResults: [],
      ),
    );
  }
}
