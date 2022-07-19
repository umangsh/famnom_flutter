part of 'browse_cubit.dart';

class BrowseMyMealsCubit extends BrowseCubit {
  BrowseMyMealsCubit(this._appRepository) : super();

  final AppRepository _appRepository;

  Future<void> getResults() async {
    emit(state.copyWith(status: BrowseStatus.requestSubmitted));
    try {
      final results = await _appRepository.myMeals();
      results.isEmpty
          ? emit(
              state.copyWith(status: BrowseStatus.requestFinishedEmptyResults),
            )
          : emit(
              state.copyWith(
                status: BrowseStatus.requestFinishedWithResults,
                mealResults: results,
              ),
            );
    } on MyMealsFailure catch (e) {
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
      final results = await _appRepository.myMealsWithURI();
      results.isEmpty
          ? emit(
              state.copyWith(
                status: BrowseStatus.requestMoreFinishedEmptyResults,
              ),
            )
          : emit(
              state.copyWith(
                status: BrowseStatus.requestMoreFinishedWithResults,
                mealResults: state.mealResults + results,
              ),
            );
    } on MyMealsFailure catch (e) {
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
