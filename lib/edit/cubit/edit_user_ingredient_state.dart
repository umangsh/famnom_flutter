part of 'edit_cubit.dart';

enum EditUserIngredientStatus {
  init,
  requestSubmitted,
  requestSuccess,
  requestFailure,
  barcodeRequest,
  barcodeCancelled,
  barcodeFound,
  barcodeNotFoundOrFailed,
  saveRequestSubmitted,
  saveRequestSuccess,
  saveRequestFailure,
}

class EditUserIngredientState extends Equatable {
  const EditUserIngredientState({
    this.status = EditUserIngredientStatus.init,
    this.userIngredient,
    this.appConstants,
    this.form,
    this.redirectExternalId,
    this.nutritionServing = '${constants.DEFAULT_PORTION_SIZE}'
        '${constants.DEFAULT_PORTION_SIZE_UNIT}',
    this.errorMessage,
  });

  final EditUserIngredientStatus status;
  final UserIngredientMutable? userIngredient;
  final AppConstants? appConstants;
  final FoodForm? form;
  final String? redirectExternalId;
  final String? nutritionServing;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        status,
        userIngredient,
        appConstants,
        form,
        redirectExternalId,
        nutritionServing,
      ];

  EditUserIngredientState copyWith({
    EditUserIngredientStatus? status,
    UserIngredientMutable? userIngredient,
    AppConstants? appConstants,
    FoodForm? form,
    String? redirectExternalId,
    String? nutritionServing,
    String? errorMessage,
  }) {
    return EditUserIngredientState(
      status: status ?? this.status,
      userIngredient: userIngredient ?? this.userIngredient,
      appConstants: appConstants ?? this.appConstants,
      form: form ?? this.form,
      redirectExternalId: redirectExternalId ?? this.redirectExternalId,
      nutritionServing: nutritionServing ?? this.nutritionServing,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
