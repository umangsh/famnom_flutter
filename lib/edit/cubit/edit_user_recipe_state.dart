part of 'edit_cubit.dart';

enum EditUserRecipeStatus {
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

class EditUserRecipeState extends Equatable {
  const EditUserRecipeState({
    this.status = EditUserRecipeStatus.init,
    this.userRecipe,
    this.appConstants,
    this.form,
    this.redirectExternalId,
    this.errorMessage,
  });

  final EditUserRecipeStatus status;
  final UserRecipeMutable? userRecipe;
  final AppConstants? appConstants;
  final RecipeForm? form;
  final String? redirectExternalId;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        status,
        userRecipe,
        appConstants,
        form,
        redirectExternalId,
      ];

  EditUserRecipeState copyWith({
    EditUserRecipeStatus? status,
    UserRecipeMutable? userRecipe,
    AppConstants? appConstants,
    RecipeForm? form,
    String? redirectExternalId,
    String? errorMessage,
  }) {
    return EditUserRecipeState(
      status: status ?? this.status,
      userRecipe: userRecipe ?? this.userRecipe,
      appConstants: appConstants ?? this.appConstants,
      form: form ?? this.form,
      redirectExternalId: redirectExternalId ?? this.redirectExternalId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
