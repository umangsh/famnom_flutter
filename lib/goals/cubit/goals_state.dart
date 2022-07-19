part of 'goals_cubit.dart';

enum GoalsStatus {
  init,
  requestSubmitted,
  requestSuccess,
  requestFailure,
  populateDefaults,
  submissionSubmitted,
  submissionSuccess,
}

class GoalsState extends Equatable {
  const GoalsState({
    this.status = GoalsStatus.init,
    this.fdaRDIs,
    this.nutritionPreferences = const <int, Preference>{},
    this.formValues = const <String, dynamic>{},
    this.errorMessage,
  });

  final GoalsStatus status;
  final Map<FDAGroup, Map<int, FdaRdi>>? fdaRDIs;
  final Map<int, Preference>? nutritionPreferences;
  final Map<String, dynamic> formValues;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, fdaRDIs, nutritionPreferences];

  GoalsState copyWith({
    GoalsStatus? status,
    Map<FDAGroup, Map<int, FdaRdi>>? fdaRDIs,
    Map<int, Preference>? nutritionPreferences,
    Map<String, dynamic>? formValues,
    String? errorMessage,
  }) {
    return GoalsState(
      status: status ?? this.status,
      fdaRDIs: fdaRDIs ?? this.fdaRDIs,
      nutritionPreferences: nutritionPreferences ?? this.nutritionPreferences,
      formValues: formValues ?? this.formValues,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
