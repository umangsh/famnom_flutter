import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show hashValues;

/// A generic class which provides API exceptions in a friendly format to users.
@immutable
class FamnomAPIException implements Exception {
  /// A generic class which provides API exceptions in a friendly format
  /// to users.
  const FamnomAPIException({
    this.message,
    String? code,
    this.stackTrace,
    // ignore: unnecessary_this
  }) : this.code = code ?? 'unknown';

  /// The long form message of the exception.
  final String? message;

  /// The optional code to accommodate the message.
  /// Allows users to identify the exception from a short code-name.
  final String code;

  /// The stack trace which provides information to the user about the call
  /// sequence that triggered an exception
  final StackTrace? stackTrace;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FamnomAPIException) return false;
    return other.hashCode == hashCode;
  }

  @override
  int get hashCode => hashValues(code, message);

  @override
  String toString() {
    return message ?? 'An unknown API exception occurred.';
  }
}

/// Throws a consistent cross-platform error message when
/// a user is unable to log-in.
FamnomAPIException unableToLogInWithCredentials() {
  return const FamnomAPIException(
    code: 'login-bad-credentials',
    message: 'Login failed. Check your username / password.',
  );
}

/// Throws when logging in with unverified email.
FamnomAPIException loginEmailNotVerified() {
  return const FamnomAPIException(
    code: 'login-email-not-verified',
    message:
        'Email not verified. Please check your inbox for verification e-mail.',
  );
}

/// Throws a generic login request failed error.
FamnomAPIException loginFailedGeneric() {
  return const FamnomAPIException(
    code: 'login-failed-generic',
    message: 'Login request failed. Please try again later.',
  );
}

/// Throws when the login request returns an empty auth token.
FamnomAPIException authTokenNotFound() {
  return const FamnomAPIException(
    code: 'auth-token-empty',
    message: 'Login request failed. Please try again later.',
  );
}

/// Throws a generic signup request failed error.
FamnomAPIException signupFailedGeneric() {
  return const FamnomAPIException(
    code: 'signup-failed-generic',
    message: 'SignUp request failed. Please try again later.',
  );
}

/// Throws when pre-existing user tries to sign-up.
FamnomAPIException signupEmailExists() {
  return const FamnomAPIException(
    code: 'signup-email-exists',
    message: 'Email already registered, please login with your email/password.',
  );
}

/// Throws when password is too common.
FamnomAPIException signupCommonPassword() {
  return const FamnomAPIException(
    code: 'signup-common-password',
    message: 'Password is too common, please choose a different password.',
  );
}

/// Throws when user corresponding to the auth token is not found.
FamnomAPIException userNotFound() {
  return const FamnomAPIException(
    code: 'user-not-found',
    message: 'User not found. Please try again.',
  );
}

/// Throws a generic get user request failed error.
FamnomAPIException getUserFailedGeneric() {
  return const FamnomAPIException(
    code: 'get-user-failed-generic',
    message: 'Can not find requested user. Please try again later.',
  );
}

/// Throws a generic update user request failed error.
FamnomAPIException updateUserFailedGeneric() {
  return const FamnomAPIException(
    code: 'update-user-failed-generic',
    message: 'Can not update requested user. Please try again later.',
  );
}

/// Throws when stored auth token is empty.
FamnomAPIException storedAuthTokenEmpty() {
  return const FamnomAPIException(
    code: 'stored-auth-token-empty',
    message: 'Something went wrong. Please login again.',
  );
}

/// Throws a generic logout request failed error.
FamnomAPIException logoutFailedGeneric() {
  return const FamnomAPIException(
    code: 'logout-failed-generic',
    message: 'Logout request failed. Please try again later.',
  );
}

/// Throws a generic search request failed error.
FamnomAPIException searchFailedGeneric() {
  return const FamnomAPIException(
    code: 'search-failed-generic',
    message: 'Search request failed. Please try again later.',
  );
}

/// Throws when DBFood corresponding to an external ID is not found.
FamnomAPIException dbFoodNotFound() {
  return const FamnomAPIException(
    code: 'db-food-not-found',
    message: 'Food not found.',
  );
}

/// Throws a generic get db food request failed error.
FamnomAPIException getDBFoodFailedGeneric() {
  return const FamnomAPIException(
    code: 'get-db-food-failed-generic',
    message: 'Can not find requested food. Please try again later.',
  );
}

/// Throws when UserIngredient corresponding to an external ID is not found.
FamnomAPIException userIngredientNotFound() {
  return const FamnomAPIException(
    code: 'user-ingredient-not-found',
    message: 'Food not found.',
  );
}

/// Throws a generic get user ingredient request failed error.
FamnomAPIException getUserIngredientFailedGeneric() {
  return const FamnomAPIException(
    code: 'get-user-ingredient-failed-generic',
    message: 'Can not find requested food. Please try again later.',
  );
}

/// Throws when UserRecipe corresponding to an external ID is not found.
FamnomAPIException userRecipeNotFound() {
  return const FamnomAPIException(
    code: 'user-recipe-not-found',
    message: 'Recipe not found.',
  );
}

/// Throws a generic get user recipe request failed error.
FamnomAPIException getUserRecipeFailedGeneric() {
  return const FamnomAPIException(
    code: 'get-user-recipe-failed-generic',
    message: 'Can not find requested recipe. Please try again later.',
  );
}

/// Throws when UserMeal corresponding to an external ID is not found.
FamnomAPIException userMealNotFound() {
  return const FamnomAPIException(
    code: 'user-meal-not-found',
    message: 'Meal not found.',
  );
}

/// Throws a generic get user meal request failed error.
FamnomAPIException getUserMealFailedGeneric() {
  return const FamnomAPIException(
    code: 'get-user-meal-failed-generic',
    message: 'Can not find requested meal. Please try again later.',
  );
}

/// Throws a generic get nutrition config request failed error.
FamnomAPIException getConfigNutritionFailedGeneric() {
  return const FamnomAPIException(
    code: 'get-config-nutrition-failed-generic',
    message: 'Can not find requested nutrition config. Please try again later.',
  );
}

/// Throws a generic get nutrition config label request failed error.
FamnomAPIException getConfigNutritionLabelFailedGeneric() {
  return const FamnomAPIException(
    code: 'get-config-nutrition-label-failed-generic',
    message: 'Can not find requested nutrition label config. '
        'Please try again later.',
  );
}

/// Throws a generic get app constants request failed error.
FamnomAPIException getAppConstantsFailedGeneric() {
  return const FamnomAPIException(
    code: 'get-app-constants-failed-generic',
    message:
        'Can not initialize the app, some features may not work as expected. '
        'Please try again later.',
  );
}

/// Throws a generic get nutrition preferences request failed error.
FamnomAPIException getNutritionPreferencesFailedGeneric() {
  return const FamnomAPIException(
    code: 'get-nutrition-preferences-failed-generic',
    message:
        'Can not find requested nutrition preferences. Please try again later.',
  );
}

/// Throws a generic save db food request failed error.
FamnomAPIException saveDBFoodFailedGeneric() {
  return const FamnomAPIException(
    code: 'save-db-food-failed-generic',
    message: 'Can not save the food. Please try again later.',
  );
}

/// Throws a generic log db food request failed error.
FamnomAPIException logDBFoodFailedGeneric() {
  return const FamnomAPIException(
    code: 'log-db-food-failed-generic',
    message: 'Can not log the food. Please try again later.',
  );
}

/// Throws a generic log user ingredient request failed error.
FamnomAPIException logUserIngredientFailedGeneric() {
  return const FamnomAPIException(
    code: 'log-user-ingredient-failed-generic',
    message: 'Can not log the food. Please try again later.',
  );
}

/// Throws a generic log user recipe request failed error.
FamnomAPIException logUserRecipeFailedGeneric() {
  return const FamnomAPIException(
    code: 'log-user-recipe-failed-generic',
    message: 'Can not log the recipe. Please try again later.',
  );
}

/// Throws a generic my foods request failed error.
FamnomAPIException myFoodsFailedGeneric() {
  return const FamnomAPIException(
    code: 'my-foods-failed-generic',
    message: 'Can not get list of foods. Please try again later.',
  );
}

/// Throws a generic my recipes request failed error.
FamnomAPIException myRecipesFailedGeneric() {
  return const FamnomAPIException(
    code: 'my-recipes-failed-generic',
    message: 'Can not get list of recipes. Please try again later.',
  );
}

/// Throws a generic my meals request failed error.
FamnomAPIException myMealsFailedGeneric() {
  return const FamnomAPIException(
    code: 'my-meals-failed-generic',
    message: 'Can not get list of meals. Please try again later.',
  );
}

/// Throws a generic delete user ingredient request failed error.
FamnomAPIException deleteUserIngredientFailedGeneric() {
  return const FamnomAPIException(
    code: 'delete-user-ingredient-failed-generic',
    message: 'Can not delete food. Please try again later.',
  );
}

/// Throws a generic delete user recipe request failed error.
FamnomAPIException deleteUserRecipeFailedGeneric() {
  return const FamnomAPIException(
    code: 'delete-user-recipe-failed-generic',
    message: 'Can not delete recipe. Please try again later.',
  );
}

/// Throws a generic delete user meal request failed error.
FamnomAPIException deleteUserMealFailedGeneric() {
  return const FamnomAPIException(
    code: 'delete-user-meal-failed-generic',
    message: 'Can not delete meal. Please try again later.',
  );
}

/// Throws a generic get tracker request failed error.
FamnomAPIException getTrackerFailedGeneric() {
  return const FamnomAPIException(
    code: 'get-tracker-failed-generic',
    message: 'Can not fetch tracker. Please try again later.',
  );
}

/// Throws a generic save preferences request failed error.
FamnomAPIException saveNutritionPreferencesFailedGeneric() {
  return const FamnomAPIException(
    code: 'save-nutrition-preferences-failed-generic',
    message: 'Can not save nutrition preferences. Please try again later.',
  );
}

/// Throws a generic get nutrient page request failed error.
FamnomAPIException getNutrientPageFailedGeneric() {
  return const FamnomAPIException(
    code: 'get-nutrient-page-failed-generic',
    message: 'Can not fetch nutrient details. Please try again later.',
  );
}

/// Throws a generic save user ingredient request failed error.
FamnomAPIException saveUserIngredientFailedGeneric() {
  return const FamnomAPIException(
    code: 'save-user-ingredient-failed-generic',
    message: 'Save failed. Please try again later.',
  );
}

/// Throws a generic save user recipe request failed error.
FamnomAPIException saveUserRecipeFailedGeneric() {
  return const FamnomAPIException(
    code: 'save-user-recipe-failed-generic',
    message: 'Save failed. Please try again later.',
  );
}

/// Throws a generic save user meal request failed error.
FamnomAPIException saveUserMealFailedGeneric() {
  return const FamnomAPIException(
    code: 'save-user-meal-failed-generic',
    message: 'Save failed. Please try again later.',
  );
}

/// Throws a generic save mealplan form one failed error.
FamnomAPIException saveMealplanFormOneFailedGeneric() {
  return const FamnomAPIException(
    code: 'save-mealplan-form-one-failed-generic',
    message: 'Save failed. Please try again later.',
  );
}

/// Throws a generic get mealplan form two failed error.
FamnomAPIException getMealplanFormTwoFailedGeneric() {
  return const FamnomAPIException(
    code: 'get-mealplan-form-two-failed-generic',
    message: 'Request failed. Please try again later.',
  );
}

/// Throws a generic save mealplan form two failed error.
FamnomAPIException saveMealplanFormTwoFailedGeneric() {
  return const FamnomAPIException(
    code: 'save-mealplan-form-two-failed-generic',
    message: 'Save failed. Please try again later.',
  );
}

/// Throws a generic get mealplan form three failed error.
FamnomAPIException getMealplanFormThreeFailedGeneric() {
  return const FamnomAPIException(
    code: 'get-mealplan-form-three-failed-generic',
    message: 'Request failed. Please try again later.',
  );
}

/// Throws a generic save mealplan form three failed error.
FamnomAPIException saveMealplanFormThreeFailedGeneric() {
  return const FamnomAPIException(
    code: 'save-mealplan-form-three-failed-generic',
    message: 'Save failed. Please try again later.',
  );
}
