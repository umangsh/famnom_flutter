part of 'browse_cubit.dart';

class BrowseMyRecipesCubit extends BrowseCubit {
  BrowseMyRecipesCubit(this._appRepository) : super();

  final AppRepository _appRepository;

  Future<void> getResultsWithQuery([String query = '']) async {
    emit(state.copyWith(status: BrowseStatus.requestSubmitted));
    try {
      final results = await _appRepository.myRecipesWithQuery(query: query);
      results.isEmpty
          ? emit(
              state.copyWith(status: BrowseStatus.requestFinishedEmptyResults),
            )
          : emit(
              state.copyWith(
                status: BrowseStatus.requestFinishedWithResults,
                recipeResults: results,
              ),
            );
    } on MyRecipesFailure catch (e) {
      emit(
        state.copyWith(
          status: BrowseStatus.requestFailure,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: BrowseStatus.requestFailure,
          errorMessage: 'Something went wrong, please try again.',
        ),
      );
    }
  }

  Future<void> getMoreResults() async {
    try {
      final results = await _appRepository.myRecipesWithURI();
      results.isEmpty
          ? emit(
              state.copyWith(
                status: BrowseStatus.requestMoreFinishedEmptyResults,
              ),
            )
          : emit(
              state.copyWith(
                status: BrowseStatus.requestMoreFinishedWithResults,
                recipeResults: state.recipeResults + results,
              ),
            );
    } on MyRecipesFailure catch (e) {
      emit(
        state.copyWith(
          status: BrowseStatus.requestFailure,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: BrowseStatus.requestFailure,
          errorMessage: 'Something went wrong, please try again.',
        ),
      );
    }
  }
}
