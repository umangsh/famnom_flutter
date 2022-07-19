part of 'details_cubit.dart';

enum DetailsStatus {
  init,
  requestSubmitted,
  requestSuccess,
  requestFailure,
  portionSelected,
  saveRequestSubmitted,
  saveRequestSuccess,
  saveRequestFailure,
  deleteRequestSubmitted,
  deleteRequestCancelled,
  deleteRequestSuccess,
}

class DetailsState extends Equatable {
  const DetailsState({
    this.status = DetailsStatus.init,
    this.dbFood,
    this.userIngredient,
    this.userRecipe,
    this.userMeal,
    this.fdaRDIs,
    this.nutritionPreferences = const <int, Preference>{},
    this.selectedPortion,
    this.quantity,
    this.errorMessage,
  });

  final DetailsStatus status;
  final DBFood? dbFood;
  final UserIngredientDisplay? userIngredient;
  final UserRecipeDisplay? userRecipe;
  final UserMealDisplay? userMeal;
  final Map<FDAGroup, Map<int, FdaRdi>>? fdaRDIs;
  final Map<int, Preference>? nutritionPreferences;
  final Portion? selectedPortion;
  final double? quantity;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        status,
        dbFood,
        userIngredient,
        userRecipe,
        userMeal,
        fdaRDIs,
        nutritionPreferences,
        selectedPortion,
        quantity
      ];

  DetailsState copyWith({
    DetailsStatus? status,
    DBFood? dbFood,
    UserIngredientDisplay? userIngredient,
    UserRecipeDisplay? userRecipe,
    UserMealDisplay? userMeal,
    Map<FDAGroup, Map<int, FdaRdi>>? fdaRDIs,
    Map<int, Preference>? nutritionPreferences,
    Portion? selectedPortion,
    String? errorMessage,
    double? quantity,
  }) {
    return DetailsState(
      status: status ?? this.status,
      dbFood: dbFood ?? this.dbFood,
      userIngredient: userIngredient ?? this.userIngredient,
      userRecipe: userRecipe ?? this.userRecipe,
      userMeal: userMeal ?? this.userMeal,
      fdaRDIs: fdaRDIs ?? this.fdaRDIs,
      nutritionPreferences: nutritionPreferences ?? this.nutritionPreferences,
      selectedPortion: selectedPortion ?? this.selectedPortion,
      quantity: quantity ?? this.quantity,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
