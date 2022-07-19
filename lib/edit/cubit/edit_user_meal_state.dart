part of 'edit_cubit.dart';

enum EditUserMealStatus {
  init,
  requestSubmitted,
  requestSuccess,
  requestFailure,
  redrawRequested,
  redrawDone,
  saveRequestSubmitted,
  saveRequestSuccess,
  saveRequestFailure,
}

class EditUserMealState extends Equatable {
  const EditUserMealState({
    this.status = EditUserMealStatus.init,
    this.userMeal,
    this.appConstants,
    this.form,
    this.redirectExternalId,
    this.errorMessage,
  });

  final EditUserMealStatus status;
  final UserMealMutable? userMeal;
  final AppConstants? appConstants;
  final MealForm? form;
  final String? redirectExternalId;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        status,
        userMeal,
        appConstants,
        form,
        redirectExternalId,
      ];

  EditUserMealState copyWith({
    EditUserMealStatus? status,
    UserMealMutable? userMeal,
    AppConstants? appConstants,
    MealForm? form,
    String? redirectExternalId,
    String? errorMessage,
  }) {
    return EditUserMealState(
      status: status ?? this.status,
      userMeal: userMeal ?? this.userMeal,
      appConstants: appConstants ?? this.appConstants,
      form: form ?? this.form,
      redirectExternalId: redirectExternalId ?? this.redirectExternalId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
