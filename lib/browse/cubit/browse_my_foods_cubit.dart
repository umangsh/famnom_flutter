part of 'browse_cubit.dart';

class BrowseMyFoodsCubit extends BrowseCubit {
  BrowseMyFoodsCubit(this._appRepository) : super();

  final AppRepository _appRepository;

  Future<void> getResultsWithQuery([String query = '']) async {
    emit(state.copyWith(status: BrowseStatus.requestSubmitted));
    try {
      final results = await _appRepository.myFoodsWithQuery(query: query);
      results.isEmpty
          ? emit(
              state.copyWith(status: BrowseStatus.requestFinishedEmptyResults),
            )
          : emit(
              state.copyWith(
                status: BrowseStatus.requestFinishedWithResults,
                ingredientResults: results,
              ),
            );
    } on MyFoodsFailure catch (e) {
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
      final results = await _appRepository.myFoodsWithURI();
      results.isEmpty
          ? emit(
              state.copyWith(
                status: BrowseStatus.requestMoreFinishedEmptyResults,
              ),
            )
          : emit(
              state.copyWith(
                status: BrowseStatus.requestMoreFinishedWithResults,
                ingredientResults: state.ingredientResults + results,
              ),
            );
    } on MyFoodsFailure catch (e) {
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

  Future<void> scannerInit() async {
    emit(
      state.copyWith(
        status: BrowseStatus.barcodeRequest,
        ingredientResults: [],
      ),
    );
  }
}
