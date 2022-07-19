part of 'details_cubit.dart';

class DetailsUserMealCubit extends _DetailsCubit {
  DetailsUserMealCubit(this._appRepository) : super();

  final AppRepository _appRepository;

  @override
  Future<void> fetchData({
    required String externalId,
    String? membershipExternalId,
  }) async {
    try {
      final userMeal = await _appRepository.getUserMeal(externalId);
      final fdaRDIs = await _appRepository.getConfigNutrition();
      final nutritionPreferences =
          await _appRepository.getNutritionPreferences();
      emit(
        state.copyWith(
          status: DetailsStatus.requestSuccess,
          userMeal: userMeal,
          fdaRDIs: fdaRDIs,
          nutritionPreferences: nutritionPreferences,
        ),
      );
    } on GetUserMealFailure catch (e) {
      emit(
        state.copyWith(
          status: DetailsStatus.requestFailure,
          errorMessage: e.message,
        ),
      );
    }
  }

  Future<void> delete({required String externalId}) async {
    emit(state.copyWith(status: DetailsStatus.deleteRequestSubmitted));
    try {
      await _appRepository.deleteUserMeal(externalId: externalId);
      emit(state.copyWith(status: DetailsStatus.deleteRequestSuccess));
    } on DeleteUserMealFailure catch (e) {
      emit(
        state.copyWith(
          status: DetailsStatus.requestFailure,
          errorMessage: e.message,
        ),
      );
    }
  }
}
