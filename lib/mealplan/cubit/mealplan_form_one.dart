part of 'mealplan_cubit.dart';

// ignore: must_be_immutable
class MealplanFormOne extends Equatable {
  MealplanFormOne({
    this.allFoods,
    this.allRecipes,
    this.availableFoods,
    this.availableRecipes,
    this.mustHaveFoods,
    this.mustHaveRecipes,
    this.dontHaveFoods,
    this.dontHaveRecipes,
    this.dontRepeatFoods,
    this.dontRepeatRecipes,
  });

  List<UserIngredientDisplay>? allFoods;
  List<UserRecipeDisplay>? allRecipes;
  List<UserIngredientDisplay>? availableFoods;
  List<UserRecipeDisplay>? availableRecipes;
  List<UserIngredientDisplay>? mustHaveFoods;
  List<UserRecipeDisplay>? mustHaveRecipes;
  List<UserIngredientDisplay>? dontHaveFoods;
  List<UserRecipeDisplay>? dontHaveRecipes;
  List<UserIngredientDisplay>? dontRepeatFoods;
  List<UserRecipeDisplay>? dontRepeatRecipes;

  Map<String, dynamic> convertToMap() {
    final form = <String, dynamic>{};

    form['available_foods'] = availableFoods?.map((e) => e.externalId).toList();
    form['available_recipes'] =
        availableRecipes?.map((e) => e.externalId).toList();
    form['must_have_foods'] = mustHaveFoods?.map((e) => e.externalId).toList();
    form['must_have_recipes'] =
        mustHaveRecipes?.map((e) => e.externalId).toList();
    form['dont_have_foods'] = dontHaveFoods?.map((e) => e.externalId).toList();
    form['dont_have_recipes'] =
        dontHaveRecipes?.map((e) => e.externalId).toList();
    form['dont_repeat_foods'] =
        dontRepeatFoods?.map((e) => e.externalId).toList();
    form['dont_repeat_recipes'] =
        dontRepeatRecipes?.map((e) => e.externalId).toList();

    return form;
  }

  @override
  List<Object?> get props => [
        allFoods,
        allRecipes,
        availableFoods,
        availableRecipes,
        mustHaveFoods,
        mustHaveRecipes,
        dontHaveFoods,
        dontHaveRecipes,
        dontRepeatFoods,
        dontRepeatRecipes,
      ];
}
