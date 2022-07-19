part of 'mealplan_cubit.dart';

enum MealplanStatus {
  init,
  requestFailure,
  loadRequestSubmitted,
  loadRequestSuccess,
  loadRequestFailure,
  thresholdsRequestSubmitted,
  thresholdsRequestSuccess,
  thresholdsRequestFailure,
  mealplanRequestSubmitted,
  mealplanRequestSuccess,
  mealplanRequestFailure,
  mealplanSaved,
}

class MealplanState extends Equatable {
  const MealplanState({
    this.status = MealplanStatus.init,
    this.formOne,
    this.preferences,
    this.formTwo,
    this.mealplanInfeasible,
    this.mealplanResults,
    this.formThree,
    this.errorMessage,
  });

  final MealplanStatus status;
  final MealplanFormOne? formOne;
  final Map<String, MealplanPreference>? preferences;
  final MealplanFormTwo? formTwo;
  final bool? mealplanInfeasible;
  final Map<String, MealplanItem>? mealplanResults;
  final MealplanFormThree? formThree;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        status,
        formOne,
        preferences,
        formTwo,
        mealplanInfeasible,
        mealplanResults,
        formThree
      ];

  MealplanState copyWith({
    MealplanStatus? status,
    MealplanFormOne? formOne,
    Map<String, MealplanPreference>? preferences,
    MealplanFormTwo? formTwo,
    bool? mealplanInfeasible,
    Map<String, MealplanItem>? mealplanResults,
    MealplanFormThree? formThree,
    String? errorMessage,
  }) {
    return MealplanState(
      status: status ?? this.status,
      formOne: formOne ?? this.formOne,
      preferences: preferences ?? this.preferences,
      formTwo: formTwo ?? this.formTwo,
      mealplanInfeasible: mealplanInfeasible ?? this.mealplanInfeasible,
      mealplanResults: mealplanResults ?? this.mealplanResults,
      formThree: formThree ?? this.formThree,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
