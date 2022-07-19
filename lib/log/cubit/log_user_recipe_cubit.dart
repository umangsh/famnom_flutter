part of 'log_cubit.dart';

class LogUserRecipeCubit extends LogCubit {
  LogUserRecipeCubit({
    required this.appRepository,
    String? mealType,
    String? mealDate,
  }) : super(mealType: mealType, mealDate: mealDate);

  final AppRepository appRepository;

  Future<void> logUserRecipe({
    required String externalId,
    String? membershipExternalId,
    required String serving,
    double? quantity,
  }) async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await appRepository.logUserRecipe(
        externalId: externalId,
        membershipExternalId: membershipExternalId,
        mealType: state.mealType.value,
        mealDate: DateTime.parse(state.mealDate.value),
        serving: serving,
        quantity: quantity,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on LogUserRecipeFailure catch (e) {
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
