import 'package:famnom_api/famnom_api.dart' as famnom;

/// {@template get_db_food_failure}
/// Thrown during the db food fetch process if a failure occurs.
/// {@endtemplate}
class GetDBFoodFailure implements Exception {
  /// {@macro get_db_food_failure}
  const GetDBFoodFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory GetDBFoodFailure.fromAPIException(famnom.FamnomAPIException e) {
    return GetDBFoodFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}

/// {@template get_user_ingredient_failure}
/// Thrown during the user ingredient fetch process if a failure occurs.
/// {@endtemplate}
class GetUserIngredientFailure implements Exception {
  /// {@macro get_user_ingredient_failure}
  const GetUserIngredientFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory GetUserIngredientFailure.fromAPIException(
    famnom.FamnomAPIException e,
  ) {
    return GetUserIngredientFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}

/// {@template get_user_recipe_failure}
/// Thrown during the user recipe fetch process if a failure occurs.
/// {@endtemplate}
class GetUserRecipeFailure implements Exception {
  /// {@macro get_user_recipe_failure}
  const GetUserRecipeFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory GetUserRecipeFailure.fromAPIException(
    famnom.FamnomAPIException e,
  ) {
    return GetUserRecipeFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}

/// {@template get_user_meal_failure}
/// Thrown during the user meal fetch process if a failure occurs.
/// {@endtemplate}
class GetUserMealFailure implements Exception {
  /// {@macro get_user_meal_failure}
  const GetUserMealFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory GetUserMealFailure.fromAPIException(
    famnom.FamnomAPIException e,
  ) {
    return GetUserMealFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}

/// {@template get_config_nutrition_failure}
/// Thrown during the fda rdi fetch process if a failure occurs.
/// {@endtemplate}
class GetConfigNutritionFailure implements Exception {
  /// {@macro get_config_nutrition_failure}
  const GetConfigNutritionFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory GetConfigNutritionFailure.fromAPIException(
    famnom.FamnomAPIException e,
  ) {
    return GetConfigNutritionFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}

/// {@template get_config_nutrition_label_failure}
/// Thrown during the nutrition label process if a failure occurs.
/// {@endtemplate}
class GetConfigNutritionLabelFailure implements Exception {
  /// {@macro get_config_nutrition_label_failure}
  const GetConfigNutritionLabelFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory GetConfigNutritionLabelFailure.fromAPIException(
    famnom.FamnomAPIException e,
  ) {
    return GetConfigNutritionLabelFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}

/// {@template get_app_constants_failure}
/// Thrown during the app constants fetch process if a failure occurs.
/// {@endtemplate}
class GetAppConstantsFailure implements Exception {
  /// {@macro get_app_constants_failure}
  const GetAppConstantsFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory GetAppConstantsFailure.fromAPIException(
    famnom.FamnomAPIException e,
  ) {
    return GetAppConstantsFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}

/// {@template get_nutrition_preferences_failure}
/// Thrown during the nutrition preferences fetch process if a failure occurs.
/// {@endtemplate}
class GetNutritionPreferencesFailure implements Exception {
  /// {@macro get_nutrition_preferences_failure}
  const GetNutritionPreferencesFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory GetNutritionPreferencesFailure.fromAPIException(
    famnom.FamnomAPIException e,
  ) {
    return GetNutritionPreferencesFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}

/// {@template save_db_food_failure}
/// Thrown during the db food save process if a failure occurs.
/// {@endtemplate}
class SaveDBFoodFailure implements Exception {
  /// {@macro save_db_food_failure}
  const SaveDBFoodFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory SaveDBFoodFailure.fromAPIException(famnom.FamnomAPIException e) {
    return SaveDBFoodFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}

/// {@template log_db_food_failure}
/// Thrown during the log db food process if a failure occurs.
/// {@endtemplate}
class LogDBFoodFailure implements Exception {
  /// {@macro log_db_food_failure}
  const LogDBFoodFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory LogDBFoodFailure.fromAPIException(famnom.FamnomAPIException e) {
    return LogDBFoodFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}

/// {@template log_user_ingredient_failure}
/// Thrown during the log user ingredient process if a failure occurs.
/// {@endtemplate}
class LogUserIngredientFailure implements Exception {
  /// {@macro log_user_ingredient_failure}
  const LogUserIngredientFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory LogUserIngredientFailure.fromAPIException(
    famnom.FamnomAPIException e,
  ) {
    return LogUserIngredientFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}

/// {@template log_user_recipe_failure}
/// Thrown during the log user recipe process if a failure occurs.
/// {@endtemplate}
class LogUserRecipeFailure implements Exception {
  /// {@macro log_user_recipe_failure}
  const LogUserRecipeFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory LogUserRecipeFailure.fromAPIException(
    famnom.FamnomAPIException e,
  ) {
    return LogUserRecipeFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}

/// {@template my_foods_failure}
/// Thrown during the my foods fetch process if a failure occurs.
/// {@endtemplate}
class MyFoodsFailure implements Exception {
  /// {@macro my_foods_failure}
  const MyFoodsFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory MyFoodsFailure.fromAPIException(famnom.FamnomAPIException e) {
    return MyFoodsFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}

/// {@template my_recipes_failure}
/// Thrown during the my recipes fetch process if a failure occurs.
/// {@endtemplate}
class MyRecipesFailure implements Exception {
  /// {@macro my_recipes_failure}
  const MyRecipesFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory MyRecipesFailure.fromAPIException(famnom.FamnomAPIException e) {
    return MyRecipesFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}

/// {@template my_meals_failure}
/// Thrown during the my meals fetch process if a failure occurs.
/// {@endtemplate}
class MyMealsFailure implements Exception {
  /// {@macro my_meals_failure}
  const MyMealsFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory MyMealsFailure.fromAPIException(famnom.FamnomAPIException e) {
    return MyMealsFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}

/// {@template delete_user_ingredient_failure}
/// Thrown during the user ingredient delete process if a failure occurs.
/// {@endtemplate}
class DeleteUserIngredientFailure implements Exception {
  /// {@macro delete_user_ingredient_failure}
  const DeleteUserIngredientFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory DeleteUserIngredientFailure.fromAPIException(
    famnom.FamnomAPIException e,
  ) {
    return DeleteUserIngredientFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}

/// {@template delete_user_recipe_failure}
/// Thrown during the user recipe delete process if a failure occurs.
/// {@endtemplate}
class DeleteUserRecipeFailure implements Exception {
  /// {@macro delete_user_recipe_failure}
  const DeleteUserRecipeFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory DeleteUserRecipeFailure.fromAPIException(
    famnom.FamnomAPIException e,
  ) {
    return DeleteUserRecipeFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}

/// {@template delete_user_meal_failure}
/// Thrown during the user meal delete process if a failure occurs.
/// {@endtemplate}
class DeleteUserMealFailure implements Exception {
  /// {@macro delete_user_meal_failure}
  const DeleteUserMealFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory DeleteUserMealFailure.fromAPIException(
    famnom.FamnomAPIException e,
  ) {
    return DeleteUserMealFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}

/// {@template get_tracker_failure}
/// Thrown during the tracker fetch process if a failure occurs.
/// {@endtemplate}
class GetTrackerFailure implements Exception {
  /// {@macro get_tracker_failure}
  const GetTrackerFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory GetTrackerFailure.fromAPIException(
    famnom.FamnomAPIException e,
  ) {
    return GetTrackerFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}

/// {@template save_nutrition_preferences_failure}
/// Thrown during the nutrition preferences save process if a failure occurs.
/// {@endtemplate}
class SaveNutritionPreferencesFailure implements Exception {
  /// {@macro save_nutrition_preferences_failure}
  const SaveNutritionPreferencesFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory SaveNutritionPreferencesFailure.fromAPIException(
    famnom.FamnomAPIException e,
  ) {
    return SaveNutritionPreferencesFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}

/// {@template save_user_ingredient_failure}
/// Thrown during the user ingredient save (create/edit) process if a failure occurs.
/// {@endtemplate}
class SaveUserIngredientFailure implements Exception {
  /// {@macro save_user_ingredient_failure}
  const SaveUserIngredientFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory SaveUserIngredientFailure.fromAPIException(
    famnom.FamnomAPIException e,
  ) {
    return SaveUserIngredientFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}

/// {@template save_user_recipe_failure}
/// Thrown during the user recipe save (create/edit) process if a failure occurs.
/// {@endtemplate}
class SaveUserRecipeFailure implements Exception {
  /// {@macro save_user_recipe_failure}
  const SaveUserRecipeFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory SaveUserRecipeFailure.fromAPIException(
    famnom.FamnomAPIException e,
  ) {
    return SaveUserRecipeFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}

/// {@template save_user_meal_failure}
/// Thrown during the user meal save (create/edit) process if a failure occurs.
/// {@endtemplate}
class SaveUserMealFailure implements Exception {
  /// {@macro save_user_meal_failure}
  const SaveUserMealFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory SaveUserMealFailure.fromAPIException(
    famnom.FamnomAPIException e,
  ) {
    return SaveUserMealFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}

/// {@template get_nutrient_page_failure}
/// Thrown during the nutrient page fetch process if a failure occurs.
/// {@endtemplate}
class GetNutrientPageFailure implements Exception {
  /// {@macro get_nutrient_page_failure}
  const GetNutrientPageFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory GetNutrientPageFailure.fromAPIException(
    famnom.FamnomAPIException e,
  ) {
    return GetNutrientPageFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}

/// {@template save_mealplan_form_one_failure}
/// Thrown during the mealplan form one save process if a failure occurs.
/// {@endtemplate}
class SaveMealplanFormOneFailure implements Exception {
  /// {@macro save_mealplan_form_one_failure}
  const SaveMealplanFormOneFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory SaveMealplanFormOneFailure.fromAPIException(
    famnom.FamnomAPIException e,
  ) {
    return SaveMealplanFormOneFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}

/// {@template get_mealplan_form_two_failure}
/// Thrown during the mealplan form two get process if a failure occurs.
/// {@endtemplate}
class GetMealplanFormTwoFailure implements Exception {
  /// {@macro get_mealplan_form_two_failure}
  const GetMealplanFormTwoFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory GetMealplanFormTwoFailure.fromAPIException(
    famnom.FamnomAPIException e,
  ) {
    return GetMealplanFormTwoFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}

/// {@template save_mealplan_form_two_failure}
/// Thrown during the mealplan form two save process if a failure occurs.
/// {@endtemplate}
class SaveMealplanFormTwoFailure implements Exception {
  /// {@macro save_mealplan_form_two_failure}
  const SaveMealplanFormTwoFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory SaveMealplanFormTwoFailure.fromAPIException(
    famnom.FamnomAPIException e,
  ) {
    return SaveMealplanFormTwoFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}

/// {@template get_mealplan_form_three_failure}
/// Thrown during the mealplan form three get process if a failure occurs.
/// {@endtemplate}
class GetMealplanFormThreeFailure implements Exception {
  /// {@macro get_mealplan_form_three_failure}
  const GetMealplanFormThreeFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory GetMealplanFormThreeFailure.fromAPIException(
    famnom.FamnomAPIException e,
  ) {
    return GetMealplanFormThreeFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}

/// {@template save_mealplan_form_three_failure}
/// Thrown during the mealplan form three save process if a failure occurs.
/// {@endtemplate}
class SaveMealplanFormThreeFailure implements Exception {
  /// {@macro save_mealplan_form_three_failure}
  const SaveMealplanFormThreeFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory SaveMealplanFormThreeFailure.fromAPIException(
    famnom.FamnomAPIException e,
  ) {
    return SaveMealplanFormThreeFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}
