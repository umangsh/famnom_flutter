import 'package:app_repository/app_repository.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:constants/constants.dart' as constants;
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

part 'goals_state.dart';

class GoalsCubit extends Cubit<GoalsState> {
  GoalsCubit(this._appRepository, this._authRepository)
      : super(const GoalsState());

  final AppRepository _appRepository;
  final AuthRepository _authRepository;

  Future<void> loadPageData() async {
    emit(state.copyWith(status: GoalsStatus.requestSubmitted));
    try {
      final fdaRDIs = await _appRepository.getConfigNutrition();
      final nutritionPreferences =
          await _appRepository.getNutritionPreferences(skipCache: true);
      emit(
        state.copyWith(
          status: GoalsStatus.requestSuccess,
          fdaRDIs: fdaRDIs,
          nutritionPreferences: nutritionPreferences,
          formValues: <String, dynamic>{
            /// Date of birth is a required field in NutritionForm
            /// (shared with web).
            'date_of_birth': _authRepository.currentUser.dateOfBirth == null
                ? ''
                : DateFormat(constants.DATE_FORMAT)
                    .format(_authRepository.currentUser.dateOfBirth!),
          },
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: GoalsStatus.requestFailure,
          errorMessage: 'Something went wrong, please try again.',
        ),
      );
    }
  }

  Future<void> populateDefaults() async {
    emit(state.copyWith(status: GoalsStatus.populateDefaults));
  }

  Future<void> saveGoals() async {
    emit(state.copyWith(status: GoalsStatus.submissionSubmitted));
    try {
      await _appRepository.saveNutritionPreferences(state.formValues);
      final nutritionPreferences =
          await _appRepository.getNutritionPreferences(skipCache: true);
      emit(
        state.copyWith(
          status: GoalsStatus.submissionSuccess,
          nutritionPreferences: nutritionPreferences,
          formValues: <String, dynamic>{
            /// Date of birth is a required field in NutritionForm
            /// (shared with web).
            'date_of_birth': _authRepository.currentUser.dateOfBirth == null
                ? ''
                : DateFormat(constants.DATE_FORMAT)
                    .format(_authRepository.currentUser.dateOfBirth!),
          },
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: GoalsStatus.requestFailure,
          errorMessage: 'Something went wrong, please try again.',
        ),
      );
    }
  }

  Future<void> refreshPage() async {
    return loadPageData();
  }
}
