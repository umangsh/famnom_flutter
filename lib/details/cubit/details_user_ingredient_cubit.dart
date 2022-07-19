part of 'details_cubit.dart';

class DetailsUserIngredientCubit extends _DetailsCubit {
  DetailsUserIngredientCubit(this._appRepository) : super();

  final AppRepository _appRepository;

  @override
  Future<void> fetchData({
    required String externalId,
    String? membershipExternalId,
  }) async {
    try {
      final userIngredient = await _appRepository.getUserIngredient(
        externalId,
        membershipExternalId,
      );
      final fdaRDIs = await _appRepository.getConfigNutrition();
      final nutritionPreferences =
          await _appRepository.getNutritionPreferences();
      emit(
        state.copyWith(
          status: DetailsStatus.requestSuccess,
          userIngredient: userIngredient,
          fdaRDIs: fdaRDIs,
          nutritionPreferences: nutritionPreferences,
          selectedPortion: userIngredient.defaultPortion,
          quantity: userIngredient.defaultQuantity,
        ),
      );
    } on GetUserIngredientFailure catch (e) {
      emit(
        state.copyWith(
          status: DetailsStatus.requestFailure,
          errorMessage: e.message,
        ),
      );
    }
  }

  Future<void> delete({
    required String externalId,
    String? membershipExternalId,
  }) async {
    emit(state.copyWith(status: DetailsStatus.deleteRequestSubmitted));
    try {
      await _appRepository.deleteUserIngredient(
        externalId: externalId,
        membershipExternalId: membershipExternalId,
      );
      emit(state.copyWith(status: DetailsStatus.deleteRequestSuccess));
    } on DeleteUserIngredientFailure catch (e) {
      emit(
        state.copyWith(
          status: DetailsStatus.requestFailure,
          errorMessage: e.message,
        ),
      );
    }
  }
}
