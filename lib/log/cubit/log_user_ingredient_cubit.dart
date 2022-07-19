part of 'log_cubit.dart';

class LogUserIngredientCubit extends LogCubit {
  LogUserIngredientCubit({
    required this.appRepository,
    String? mealType,
    String? mealDate,
  }) : super(mealType: mealType, mealDate: mealDate);

  final AppRepository appRepository;

  Future<void> logUserIngredient({
    required String externalId,
    String? membershipExternalId,
    required String serving,
    double? quantity,
  }) async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await appRepository.logUserIngredient(
        externalId: externalId,
        membershipExternalId: membershipExternalId,
        mealType: state.mealType.value,
        mealDate: DateTime.parse(state.mealDate.value),
        serving: serving,
        quantity: quantity,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on LogUserIngredientFailure catch (e) {
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
