part of 'details_cubit.dart';

class DetailsDBFoodCubit extends _DetailsCubit {
  DetailsDBFoodCubit(this._appRepository) : super();

  final AppRepository _appRepository;

  @override
  Future<void> fetchData({
    required String externalId,
    String? membershipExternalId,
  }) async {
    try {
      final dbFood = await _appRepository.getDBFood(externalId);
      final fdaRDIs = await _appRepository.getConfigNutrition();
      final nutritionPreferences =
          await _appRepository.getNutritionPreferences();
      emit(
        state.copyWith(
          status: DetailsStatus.requestSuccess,
          dbFood: dbFood,
          fdaRDIs: fdaRDIs,
          nutritionPreferences: nutritionPreferences,
          selectedPortion: dbFood.defaultPortion,
        ),
      );
    } on GetDBFoodFailure catch (e) {
      emit(
        state.copyWith(
          status: DetailsStatus.requestFailure,
          errorMessage: e.message,
        ),
      );
    }
  }

  Future<void> saveDBFood({required String externalId}) async {
    emit(state.copyWith(status: DetailsStatus.saveRequestSubmitted));
    try {
      await _appRepository.saveDBFood(externalId);
      emit(state.copyWith(status: DetailsStatus.saveRequestSuccess));
    } on SaveDBFoodFailure catch (e) {
      emit(
        state.copyWith(
          status: DetailsStatus.saveRequestFailure,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: DetailsStatus.saveRequestFailure,
          errorMessage: 'Something went wrong, please try again.',
        ),
      );
    }
  }
}
