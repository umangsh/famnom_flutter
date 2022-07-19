part of 'browse_cubit.dart';

enum BrowseStatus {
  init,
  requestSubmitted,
  requestFinishedWithResults,
  requestFinishedEmptyResults,
  requestMoreFinishedWithResults,
  requestMoreFinishedEmptyResults,
  requestFailure,
  barcodeRequest,
}

class BrowseState extends Equatable {
  const BrowseState({
    this.status = BrowseStatus.init,
    this.ingredientResults = const <UserIngredientDisplay>[],
    this.recipeResults = const <UserRecipeDisplay>[],
    this.mealResults = const <UserMealDisplay>[],
    this.errorMessage,
  });

  final BrowseStatus status;
  final List<UserIngredientDisplay> ingredientResults;
  final List<UserRecipeDisplay> recipeResults;
  final List<UserMealDisplay> mealResults;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        status,
        ingredientResults,
        recipeResults,
        mealResults,
      ];

  BrowseState copyWith({
    BrowseStatus? status,
    List<UserIngredientDisplay>? ingredientResults,
    List<UserRecipeDisplay>? recipeResults,
    List<UserMealDisplay>? mealResults,
    String? errorMessage,
  }) {
    return BrowseState(
      status: status ?? this.status,
      ingredientResults: ingredientResults ?? this.ingredientResults,
      recipeResults: recipeResults ?? this.recipeResults,
      mealResults: mealResults ?? this.mealResults,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
