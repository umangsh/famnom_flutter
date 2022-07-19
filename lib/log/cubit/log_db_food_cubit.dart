part of 'log_cubit.dart';

class LogDBFoodCubit extends LogCubit {
  LogDBFoodCubit(this._appRepository) : super();

  final AppRepository _appRepository;

  Future<void> logDBFood({
    required String externalId,
    required String serving,
    double? quantity,
  }) async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _appRepository.logDBFood(
        externalId: externalId,
        mealType: state.mealType.value,
        mealDate: DateTime.parse(state.mealDate.value),
        serving: serving,
        quantity: quantity,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on LogDBFoodFailure catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
          status: FormzStatus.submissionFailure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
