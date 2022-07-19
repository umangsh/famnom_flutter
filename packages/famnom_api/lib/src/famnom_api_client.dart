import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:constants/constants.dart' as constants;
import 'package:environments/environment.dart';
import 'package:famnom_api/famnom_api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// {@template famnom_api_client}
/// Dart API Client which wraps the FamNom REST API.
/// {@endtemplate}
class FamnomApiClient {
  /// {@macro famnom_api_client}
  FamnomApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  /// [User] login, sets [AuthToken]
  Future<AuthToken> loginUser({
    required String email,
    required String password,
  }) async {
    final loginRequest = Uri(
      scheme: Environment().config.apiUriScheme,
      host: Environment().config.apiHost,
      port: Environment().config.apiPort,
      path: constants.apiEndpointAuthLogin,
    );

    final loginResponse = await _httpClient.post(
      loginRequest,
      headers: {
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
      body: json.encode(
        {
          'email': email,
          'password': password,
        },
      ),
      encoding: Encoding.getByName(constants.encodingTypeUTF8),
    );

    final parsed = jsonDecode(loginResponse.body) as Map<String, dynamic>;
    if (loginResponse.statusCode == HttpStatus.badRequest) {
      if (parsed.containsKey('non_field_errors')) {
        final nonFieldErrors = parsed['non_field_errors'] as List;
        if (nonFieldErrors.isNotEmpty) {
          if (nonFieldErrors.first == constants.errorLoginFailed) {
            throw unableToLogInWithCredentials();
          }

          if (nonFieldErrors.first == constants.errorEmailUnverified) {
            throw loginEmailNotVerified();
          }
        }
      }
    }

    if (loginResponse.statusCode != HttpStatus.ok) {
      throw loginFailedGeneric();
    }

    if (parsed.isEmpty) {
      throw authTokenNotFound();
    }

    final authToken = AuthToken.fromJson(parsed);
    if (authToken.key.isEmpty) {
      throw authTokenNotFound();
    }

    return authToken;
  }

  /// [User] SignUp/Registration, email verification sent by service.
  Future<void> signUpUser({
    required String email,
    required String password1,
    required String password2,
  }) async {
    final signUpRequest = Uri(
      scheme: Environment().config.apiUriScheme,
      host: Environment().config.apiHost,
      port: Environment().config.apiPort,
      path: constants.apiEndpointAuthSignUp,
    );

    final signUpResponse = await _httpClient.post(
      signUpRequest,
      headers: {
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
      body: json.encode(
        {
          'email': email,
          'password1': password1,
          'password2': password2,
        },
      ),
      encoding: Encoding.getByName(constants.encodingTypeUTF8),
    );

    final parsed = jsonDecode(signUpResponse.body) as Map<String, dynamic>;
    if (signUpResponse.statusCode == HttpStatus.badRequest) {
      if (parsed.containsKey('email')) {
        final emailFieldErrors = parsed['email'] as List;
        if (emailFieldErrors.isNotEmpty &&
            emailFieldErrors.first == constants.errorEmailExists) {
          throw signupEmailExists();
        }
      }

      if (parsed.containsKey('password1')) {
        final password1FieldErrors = parsed['password1'] as List;
        if (password1FieldErrors.isNotEmpty &&
            password1FieldErrors.first == constants.errorCommonPassword) {
          throw signupCommonPassword();
        }
      }
    }

    if (signUpResponse.statusCode != HttpStatus.created) {
      throw signupFailedGeneric();
    }
  }

  /// Finds a [User].
  Future<User> getUser(String? key) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    final userRequest = Uri(
      scheme: Environment().config.apiUriScheme,
      host: Environment().config.apiHost,
      port: Environment().config.apiPort,
      path: constants.apiEndpointAuthUser,
    );

    final userResponse = await _httpClient.get(
      userRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
    );

    if (userResponse.statusCode != HttpStatus.ok) {
      throw getUserFailedGeneric();
    }

    final parsed = jsonDecode(userResponse.body) as Map<String, dynamic>;
    if (parsed.isEmpty) {
      throw userNotFound();
    }

    final user = User.fromJson(parsed);
    if (user.isEmpty) {
      throw userNotFound();
    }

    return user;
  }

  /// Updates a [User].
  Future<void> updateUser(
    String? key,
    User user, [
    Map<String, dynamic>? params,
  ]) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    final userRequest = Uri(
      scheme: Environment().config.apiUriScheme,
      host: Environment().config.apiHost,
      port: Environment().config.apiPort,
      path: constants.apiEndpointAuthUser,
    );

    final userResponse = await _httpClient.put(
      userRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
      body: json.encode(<String, dynamic>{
        ...user.toJson(),
        ...params ?? <String, dynamic>{},
      }),
      encoding: Encoding.getByName(constants.encodingTypeUTF8),
    );

    if (userResponse.statusCode != HttpStatus.ok) {
      throw updateUserFailedGeneric();
    }
  }

  /// [User] logout. On GET, should be changed to POST.
  Future<void> logoutUser(String? key) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    final logoutRequest = Uri(
      scheme: Environment().config.apiUriScheme,
      host: Environment().config.apiHost,
      port: Environment().config.apiPort,
      path: constants.apiEndpointAuthLogout,
    );

    final logoutResponse = await _httpClient.get(
      logoutRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
    );

    if (logoutResponse.statusCode != HttpStatus.ok) {
      throw logoutFailedGeneric();
    }
  }

  /// Search request, returns a [SearchResponse].
  Future<SearchResponse> search(
    String? key,
    String? query,
    String? requestURI,
  ) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    Uri searchRequest;
    if (requestURI != null && requestURI.isNotEmpty) {
      searchRequest = Uri.parse(requestURI);
    } else {
      searchRequest = Uri(
        scheme: Environment().config.apiUriScheme,
        host: Environment().config.apiHost,
        port: Environment().config.apiPort,
        path: constants.apiEndpointSearch,
        queryParameters: <String, String>{
          'q': query ?? '',
        },
      );
    }

    final searchResponse = await _httpClient.get(
      searchRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
    );

    if (searchResponse.statusCode != HttpStatus.ok) {
      throw searchFailedGeneric();
    }

    final parsed = jsonDecode(searchResponse.body) as Map<String, dynamic>;
    return SearchResponse.fromJson(parsed);
  }

  /// DBFood fetch, returns a [DBFood].
  Future<DBFood> getDBFood(String? key, String externalId) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    final dbFoodRequest = Uri(
      scheme: Environment().config.apiUriScheme,
      host: Environment().config.apiHost,
      port: Environment().config.apiPort,
      path: '${constants.apiEndpointDetailsDBFood}$externalId/',
    );

    final dbFoodResponse = await _httpClient.get(
      dbFoodRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
    );

    if (dbFoodResponse.statusCode != HttpStatus.ok) {
      throw getDBFoodFailedGeneric();
    }

    final parsed = jsonDecode(dbFoodResponse.body) as Map<String, dynamic>;
    if (parsed.isEmpty) {
      throw dbFoodNotFound();
    }

    return DBFood.fromJson(parsed);
  }

  /// UserIngredient fetch, returns a [UserIngredientDisplay].
  Future<UserIngredientDisplay> getUserIngredient(
    String? key,
    String externalId, [
    String? membershipExternalId,
  ]) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    var path = '${constants.apiEndpointDetailsUserIngredient}$externalId/';
    if (membershipExternalId != null && membershipExternalId.isNotEmpty) {
      path = '$path$membershipExternalId/';
    }

    final userIngredientRequest = Uri(
      scheme: Environment().config.apiUriScheme,
      host: Environment().config.apiHost,
      port: Environment().config.apiPort,
      path: path,
    );

    final userIngredientResponse = await _httpClient.get(
      userIngredientRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
    );

    if (userIngredientResponse.statusCode != HttpStatus.ok) {
      throw getUserIngredientFailedGeneric();
    }

    final parsed =
        jsonDecode(userIngredientResponse.body) as Map<String, dynamic>;
    if (parsed.isEmpty) {
      throw userIngredientNotFound();
    }

    return UserIngredientDisplay.fromJson(parsed);
  }

  /// UserRecipe fetch, returns a [UserRecipeDisplay].
  Future<UserRecipeDisplay> getUserRecipe(
    String? key,
    String externalId, [
    String? membershipExternalId,
  ]) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    var path = '${constants.apiEndpointDetailsUserRecipe}$externalId/';
    if (membershipExternalId != null && membershipExternalId.isNotEmpty) {
      path = '$path$membershipExternalId/';
    }

    final userRecipeRequest = Uri(
      scheme: Environment().config.apiUriScheme,
      host: Environment().config.apiHost,
      port: Environment().config.apiPort,
      path: path,
    );

    final userRecipeResponse = await _httpClient.get(
      userRecipeRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
    );

    if (userRecipeResponse.statusCode != HttpStatus.ok) {
      throw getUserRecipeFailedGeneric();
    }

    final parsed = jsonDecode(userRecipeResponse.body) as Map<String, dynamic>;
    if (parsed.isEmpty) {
      throw userRecipeNotFound();
    }

    return UserRecipeDisplay.fromJson(parsed);
  }

  /// UserMeal fetch, returns a [UserMealDisplay].
  Future<UserMealDisplay> getUserMeal(String? key, String externalId) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    final userMealRequest = Uri(
      scheme: Environment().config.apiUriScheme,
      host: Environment().config.apiHost,
      port: Environment().config.apiPort,
      path: '${constants.apiEndpointDetailsUserMeal}$externalId/',
    );

    final userMealResponse = await _httpClient.get(
      userMealRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
    );

    if (userMealResponse.statusCode != HttpStatus.ok) {
      throw getUserMealFailedGeneric();
    }

    final parsed = jsonDecode(userMealResponse.body) as Map<String, dynamic>;
    if (parsed.isEmpty) {
      throw userMealNotFound();
    }

    return UserMealDisplay.fromJson(parsed);
  }

  /// Fetches FDA nutrient RDIs for all age groups.
  Future<FdaRdiResponse> getConfigNutrition(String? key) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    final nutritionRequest = Uri(
      scheme: Environment().config.apiUriScheme,
      host: Environment().config.apiHost,
      port: Environment().config.apiPort,
      path: constants.apiEndpointNutritionFDA,
    );

    final nutritionResponse = await _httpClient.get(
      nutritionRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
    );

    if (nutritionResponse.statusCode != HttpStatus.ok) {
      throw getConfigNutritionFailedGeneric();
    }

    final parsed = jsonDecode(nutritionResponse.body) as Map<String, dynamic>;
    return FdaRdiResponse.fromJson(parsed);
  }

  /// Fetches label nutrient metadata for all age groups.
  Future<LabelResponse> getConfigNutritionLabel(String? key) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    final nutritionRequest = Uri(
      scheme: Environment().config.apiUriScheme,
      host: Environment().config.apiHost,
      port: Environment().config.apiPort,
      path: constants.apiEndpointNutritionLabel,
    );

    final nutritionResponse = await _httpClient.get(
      nutritionRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
    );

    if (nutritionResponse.statusCode != HttpStatus.ok) {
      throw getConfigNutritionLabelFailedGeneric();
    }

    final parsed = jsonDecode(nutritionResponse.body) as Map<String, dynamic>;
    return LabelResponse.fromJson(parsed);
  }

  /// Fetches app constants metadata.
  Future<AppConstants> getAppConstants(String? key) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    final request = Uri(
      scheme: Environment().config.apiUriScheme,
      host: Environment().config.apiHost,
      port: Environment().config.apiPort,
      path: constants.apiEndpointAppConstants,
    );

    final response = await _httpClient.get(
      request,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
    );

    if (response.statusCode != HttpStatus.ok) {
      throw getAppConstantsFailedGeneric();
    }

    final parsed = jsonDecode(response.body) as Map<String, dynamic>;
    return AppConstants.fromJson(parsed);
  }

  /// Fetches user nutrition preferences.
  Future<List<Preference>> getNutritionPreferences(
    String? key,
  ) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    final preferencesRequest = Uri(
      scheme: Environment().config.apiUriScheme,
      host: Environment().config.apiHost,
      port: Environment().config.apiPort,
      path: constants.apiEndpointNutritionPreferences,
    );

    final preferencesResponse = await _httpClient.get(
      preferencesRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
    );

    if (preferencesResponse.statusCode != HttpStatus.ok) {
      throw getNutritionPreferencesFailedGeneric();
    }

    final parsed = jsonDecode(preferencesResponse.body) as List;
    return parsed
        .map((dynamic e) => Preference.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Saves [DBFood] to a user's kitchen.
  Future<void> saveDBFood(String? key, String externalId) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    final saveRequest = Uri(
      scheme: Environment().config.apiUriScheme,
      host: Environment().config.apiHost,
      port: Environment().config.apiPort,
      path: constants.apiEndpointSaveFoodToKitchen,
    );

    final saveResponse = await _httpClient.post(
      saveRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
      body: json.encode({'id': externalId}),
      encoding: Encoding.getByName(constants.encodingTypeUTF8),
    );

    if (saveResponse.statusCode != HttpStatus.ok) {
      throw saveDBFoodFailedGeneric();
    }
  }

  /// Logs [DBFood] to a user's meal.
  Future<void> logDBFood({
    String? key,
    required String externalId,
    required String mealType,
    required String mealDate,
    required String serving,
    double? quantity,
  }) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    final logRequest = Uri(
      scheme: Environment().config.apiUriScheme,
      host: Environment().config.apiHost,
      port: Environment().config.apiPort,
      path: '${constants.apiEndpointLogDBFood}$externalId/',
    );

    final logResponse = await _httpClient.post(
      logRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
      body: json.encode({
        'external_id': externalId,
        'meal_type': mealType,
        'meal_date': mealDate,
        'serving': serving,
        'quantity': quantity
      }),
      encoding: Encoding.getByName(constants.encodingTypeUTF8),
    );

    if (logResponse.statusCode != HttpStatus.ok) {
      throw logDBFoodFailedGeneric();
    }
  }

  /// Logs [UserIngredientDisplay] to a user's meal.
  Future<void> logUserIngredient({
    String? key,
    required String externalId,
    String? membershipExternalId,
    required String mealType,
    required String mealDate,
    required String serving,
    double? quantity,
  }) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    var path = '${constants.apiEndpointLogUserIngredient}$externalId/';
    if (membershipExternalId != null && membershipExternalId.isNotEmpty) {
      path = '$path$membershipExternalId/';
    }

    final logRequest = Uri(
      scheme: Environment().config.apiUriScheme,
      host: Environment().config.apiHost,
      port: Environment().config.apiPort,
      path: path,
    );

    final logResponse = await _httpClient.post(
      logRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
      body: json.encode({
        'external_id': externalId,
        'meal_type': mealType,
        'meal_date': mealDate,
        'serving': serving,
        'quantity': quantity
      }),
      encoding: Encoding.getByName(constants.encodingTypeUTF8),
    );

    if (logResponse.statusCode != HttpStatus.ok) {
      throw logUserIngredientFailedGeneric();
    }
  }

  /// Logs [UserRecipeDisplay] to a user's meal.
  Future<void> logUserRecipe({
    String? key,
    required String externalId,
    String? membershipExternalId,
    required String mealType,
    required String mealDate,
    required String serving,
    double? quantity,
  }) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    var path = '${constants.apiEndpointLogUserRecipe}$externalId/';
    if (membershipExternalId != null && membershipExternalId.isNotEmpty) {
      path = '$path$membershipExternalId/';
    }

    final logRequest = Uri(
      scheme: Environment().config.apiUriScheme,
      host: Environment().config.apiHost,
      port: Environment().config.apiPort,
      path: path,
    );

    final logResponse = await _httpClient.post(
      logRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
      body: json.encode({
        'external_id': externalId,
        'meal_type': mealType,
        'meal_date': mealDate,
        'serving': serving,
        'quantity': quantity
      }),
      encoding: Encoding.getByName(constants.encodingTypeUTF8),
    );

    if (logResponse.statusCode != HttpStatus.ok) {
      throw logUserRecipeFailedGeneric();
    }
  }

  /// MyFoods browse request, returns a [MyFoodsResponse].
  Future<MyFoodsResponse> getMyFoods(
    String? key,
    String? query,
    String? requestURI, [
    String? flagSet,
    String? flagUnset,
    int? pageSize,
  ]) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    Uri myFoodsRequest;
    if (requestURI != null && requestURI.isNotEmpty) {
      myFoodsRequest = Uri.parse(requestURI);
    } else {
      myFoodsRequest = Uri(
        scheme: Environment().config.apiUriScheme,
        host: Environment().config.apiHost,
        port: Environment().config.apiPort,
        path: constants.apiEndpointMyFoods,
        queryParameters: <String, String>{
          'q': query ?? '',
          'fs': flagSet ?? '',
          'fn': flagUnset ?? '',
          'ps': pageSize.toString(),
        },
      );
    }

    final myFoodsResponse = await _httpClient.get(
      myFoodsRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
    );

    if (myFoodsResponse.statusCode != HttpStatus.ok) {
      throw myFoodsFailedGeneric();
    }

    final parsed = jsonDecode(myFoodsResponse.body) as Map<String, dynamic>;
    return MyFoodsResponse.fromJson(parsed);
  }

  /// MyRecipes browse request, returns a [MyRecipesResponse].
  Future<MyRecipesResponse> getMyRecipes(
    String? key,
    String? query,
    String? requestURI, [
    String? flagSet,
    String? flagUnset,
    int? pageSize,
  ]) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    Uri myRecipesRequest;
    if (requestURI != null && requestURI.isNotEmpty) {
      myRecipesRequest = Uri.parse(requestURI);
    } else {
      myRecipesRequest = Uri(
        scheme: Environment().config.apiUriScheme,
        host: Environment().config.apiHost,
        port: Environment().config.apiPort,
        path: constants.apiEndpointMyRecipes,
        queryParameters: <String, String>{
          'q': query ?? '',
          'fs': flagSet ?? '',
          'fn': flagUnset ?? '',
          'ps': pageSize.toString(),
        },
      );
    }

    final myRecipesResponse = await _httpClient.get(
      myRecipesRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
    );

    if (myRecipesResponse.statusCode != HttpStatus.ok) {
      throw myRecipesFailedGeneric();
    }

    final parsed = jsonDecode(myRecipesResponse.body) as Map<String, dynamic>;
    return MyRecipesResponse.fromJson(parsed);
  }

  /// MyMeals browse request, returns a [MyMealsResponse].
  Future<MyMealsResponse> getMyMeals(
    String? key,
    String? requestURI,
  ) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    Uri myMealsRequest;
    if (requestURI != null && requestURI.isNotEmpty) {
      myMealsRequest = Uri.parse(requestURI);
    } else {
      myMealsRequest = Uri(
        scheme: Environment().config.apiUriScheme,
        host: Environment().config.apiHost,
        port: Environment().config.apiPort,
        path: constants.apiEndpointMyMeals,
      );
    }

    final myMealsResponse = await _httpClient.get(
      myMealsRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
    );

    if (myMealsResponse.statusCode != HttpStatus.ok) {
      throw myMealsFailedGeneric();
    }

    final parsed = jsonDecode(myMealsResponse.body) as Map<String, dynamic>;
    return MyMealsResponse.fromJson(parsed);
  }

  /// Delete UserIngredient from user's kitchen.
  Future<void> deleteUserIngredient({
    String? key,
    required String externalId,
    String? membershipExternalId,
  }) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    var path = '${constants.apiEndpointDeleteUserIngredient}$externalId/';
    if (membershipExternalId != null && membershipExternalId.isNotEmpty) {
      path = '$path$membershipExternalId/';
    }

    final deleteRequest = Uri(
      scheme: Environment().config.apiUriScheme,
      host: Environment().config.apiHost,
      port: Environment().config.apiPort,
      path: path,
    );

    final deleteResponse = await _httpClient.post(
      deleteRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
      encoding: Encoding.getByName(constants.encodingTypeUTF8),
    );

    if (deleteResponse.statusCode != HttpStatus.ok) {
      throw deleteUserIngredientFailedGeneric();
    }
  }

  /// Delete UserRecipe from user's kitchen.
  Future<void> deleteUserRecipe({
    String? key,
    required String externalId,
    String? membershipExternalId,
  }) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    var path = '${constants.apiEndpointDeleteUserRecipe}$externalId/';
    if (membershipExternalId != null && membershipExternalId.isNotEmpty) {
      path = '$path$membershipExternalId/';
    }

    final deleteRequest = Uri(
      scheme: Environment().config.apiUriScheme,
      host: Environment().config.apiHost,
      port: Environment().config.apiPort,
      path: path,
    );

    final deleteResponse = await _httpClient.post(
      deleteRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
      encoding: Encoding.getByName(constants.encodingTypeUTF8),
    );

    if (deleteResponse.statusCode != HttpStatus.ok) {
      throw deleteUserRecipeFailedGeneric();
    }
  }

  /// Delete UserMeal from user's kitchen.
  Future<void> deleteUserMeal({
    String? key,
    required String externalId,
  }) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    final deleteRequest = Uri(
      scheme: Environment().config.apiUriScheme,
      host: Environment().config.apiHost,
      port: Environment().config.apiPort,
      path: '${constants.apiEndpointDeleteUserMeal}$externalId/',
    );

    final deleteResponse = await _httpClient.post(
      deleteRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
      encoding: Encoding.getByName(constants.encodingTypeUTF8),
    );

    if (deleteResponse.statusCode != HttpStatus.ok) {
      throw deleteUserMealFailedGeneric();
    }
  }

  /// Tracker data fetch, returns a [TrackerResponse].
  Future<TrackerResponse> getTracker(String? key, String date) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    final trackerRequest = Uri(
      scheme: Environment().config.apiUriScheme,
      host: Environment().config.apiHost,
      port: Environment().config.apiPort,
      path: '${constants.apiEndpointTracker}$date/',
    );

    final trackerResponse = await _httpClient.get(
      trackerRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
    );

    if (trackerResponse.statusCode != HttpStatus.ok) {
      throw getTrackerFailedGeneric();
    }

    final parsed = jsonDecode(trackerResponse.body) as Map<String, dynamic>;
    return TrackerResponse.fromJson(parsed);
  }

  /// Saves user's nutrition preferences.
  Future<void> saveNutritionPreferences(
    String? key,
    Map<String, dynamic> values,
  ) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    final saveRequest = Uri(
      scheme: Environment().config.apiUriScheme,
      host: Environment().config.apiHost,
      port: Environment().config.apiPort,
      path: constants.apiEndpointMyNutrition,
    );

    final saveResponse = await _httpClient.post(
      saveRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
      body: json.encode(values),
      encoding: Encoding.getByName(constants.encodingTypeUTF8),
    );

    if (saveResponse.statusCode != HttpStatus.ok) {
      throw saveNutritionPreferencesFailedGeneric();
    }
  }

  /// Fetches a user ingredient for edit.
  ///
  /// Returns a [UserIngredientMutable]
  Future<UserIngredientMutable> getMutableUserIngredient({
    required String? key,
    required String externalId,
  }) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    final getRequest = Uri(
      scheme: Environment().config.apiUriScheme,
      host: Environment().config.apiHost,
      port: Environment().config.apiPort,
      path: '${constants.apiEndpointEditUserIngredient}$externalId/',
    );

    final getResponse = await _httpClient.get(
      getRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
    );

    if (getResponse.statusCode != HttpStatus.ok) {
      throw getUserIngredientFailedGeneric();
    }

    final parsed = jsonDecode(getResponse.body) as Map<String, dynamic>;
    if (parsed.isEmpty) {
      throw userIngredientNotFound();
    }

    return UserIngredientMutable.fromJson(parsed);
  }

  /// Fetches a user recipe for edit.
  ///
  /// Returns a [UserRecipeMutable]
  Future<UserRecipeMutable> getMutableUserRecipe({
    required String? key,
    required String externalId,
  }) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    final getRequest = Uri(
      scheme: Environment().config.apiUriScheme,
      host: Environment().config.apiHost,
      port: Environment().config.apiPort,
      path: '${constants.apiEndpointEditUserRecipe}$externalId/',
    );

    final getResponse = await _httpClient.get(
      getRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
    );

    if (getResponse.statusCode != HttpStatus.ok) {
      throw getUserRecipeFailedGeneric();
    }

    final parsed = jsonDecode(getResponse.body) as Map<String, dynamic>;
    if (parsed.isEmpty) {
      throw userRecipeNotFound();
    }

    return UserRecipeMutable.fromJson(parsed);
  }

  /// Fetches a user meal for edit.
  ///
  /// Returns a [UserMealMutable]
  Future<UserMealMutable> getMutableUserMeal({
    required String? key,
    required String externalId,
  }) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    final getRequest = Uri(
      scheme: Environment().config.apiUriScheme,
      host: Environment().config.apiHost,
      port: Environment().config.apiPort,
      path: '${constants.apiEndpointEditUserMeal}$externalId/',
    );

    final getResponse = await _httpClient.get(
      getRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
    );

    if (getResponse.statusCode != HttpStatus.ok) {
      throw getUserMealFailedGeneric();
    }

    final parsed = jsonDecode(getResponse.body) as Map<String, dynamic>;
    if (parsed.isEmpty) {
      throw userMealNotFound();
    }

    return UserMealMutable.fromJson(parsed);
  }

  /// Saves a user ingredient (create/edit).
  ///
  /// Returns the saved user ingredient external ID.
  Future<String> saveUserIngredient({
    required String? key,
    required Map<String, dynamic> values,
  }) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    final saveRequest = Uri(
      scheme: Environment().config.apiUriScheme,
      host: Environment().config.apiHost,
      port: Environment().config.apiPort,
      path: constants.apiEndpointEditUserIngredient,
    );

    final saveResponse = await _httpClient.post(
      saveRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
      body: json.encode(values),
      encoding: Encoding.getByName(constants.encodingTypeUTF8),
    );

    if (saveResponse.statusCode != HttpStatus.ok) {
      throw saveUserIngredientFailedGeneric();
    }

    return jsonDecode(saveResponse.body) as String;
  }

  /// Saves a user recipe (create/edit).
  ///
  /// Returns the saved user recipe external ID.
  Future<String> saveUserRecipe({
    required String? key,
    required Map<String, dynamic> values,
  }) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    final saveRequest = Uri(
      scheme: Environment().config.apiUriScheme,
      host: Environment().config.apiHost,
      port: Environment().config.apiPort,
      path: constants.apiEndpointEditUserRecipe,
    );

    final saveResponse = await _httpClient.post(
      saveRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
      body: json.encode(values),
      encoding: Encoding.getByName(constants.encodingTypeUTF8),
    );

    if (saveResponse.statusCode != HttpStatus.ok) {
      throw saveUserRecipeFailedGeneric();
    }

    return jsonDecode(saveResponse.body) as String;
  }

  /// Saves a user meal (create/edit).
  ///
  /// Returns the saved user meal external ID.
  Future<String> saveUserMeal({
    required String? key,
    required Map<String, dynamic> values,
  }) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    final saveRequest = Uri(
      scheme: Environment().config.apiUriScheme,
      host: Environment().config.apiHost,
      port: Environment().config.apiPort,
      path: constants.apiEndpointEditUserMeal,
    );

    final saveResponse = await _httpClient.post(
      saveRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
      body: json.encode(values),
      encoding: Encoding.getByName(constants.encodingTypeUTF8),
    );

    if (saveResponse.statusCode != HttpStatus.ok) {
      throw saveUserMealFailedGeneric();
    }

    return jsonDecode(saveResponse.body) as String;
  }

  /// Nutrient page data fetch, returns a [NutrientPage].
  Future<NutrientPage> getNutrientPage({
    String? key,
    required int nutrientId,
    int chartDays = constants.DEFAULT_CHART_DAYS,
  }) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    final nutrientRequest = Uri(
      scheme: Environment().config.apiUriScheme,
      host: Environment().config.apiHost,
      port: Environment().config.apiPort,
      path: '${constants.apiEndpointNutrient}$nutrientId/$chartDays/',
    );

    final nutrientResponse = await _httpClient.get(
      nutrientRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
    );

    if (nutrientResponse.statusCode != HttpStatus.ok) {
      throw getNutrientPageFailedGeneric();
    }

    final parsed = jsonDecode(nutrientResponse.body) as Map<String, dynamic>;
    return NutrientPage.fromJson(parsed);
  }

  /// Saves mealplan form one.
  Future<void> saveMealplanFormOne({
    required String? key,
    required Map<String, dynamic> values,
  }) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    final saveRequest = Uri(
      scheme: Environment().config.apiUriScheme,
      host: Environment().config.apiHost,
      port: Environment().config.apiPort,
      path: constants.apiEndpointMealplanFormOne,
    );

    final saveResponse = await _httpClient.post(
      saveRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
      body: json.encode(values),
      encoding: Encoding.getByName(constants.encodingTypeUTF8),
    );

    if (saveResponse.statusCode != HttpStatus.ok) {
      throw saveMealplanFormOneFailedGeneric();
    }
  }

  /// Get mealplan form two.
  Future<List<MealplanPreference>> getMealplanFormTwo(String? key) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    final getRequest = Uri(
      scheme: Environment().config.apiUriScheme,
      host: Environment().config.apiHost,
      port: Environment().config.apiPort,
      path: constants.apiEndpointMealplanFormTwo,
    );

    final getResponse = await _httpClient.get(
      getRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
    );

    if (getResponse.statusCode != HttpStatus.ok) {
      throw getMealplanFormTwoFailedGeneric();
    }

    final parsed = jsonDecode(getResponse.body) as List;
    return parsed
        .map(
          (dynamic e) => MealplanPreference.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  /// Saves mealplan form two.
  Future<void> saveMealplanFormTwo({
    required String? key,
    required Map<String, dynamic> values,
  }) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    final saveRequest = Uri(
      scheme: Environment().config.apiUriScheme,
      host: Environment().config.apiHost,
      port: Environment().config.apiPort,
      path: constants.apiEndpointMealplanFormTwo,
    );

    final saveResponse = await _httpClient.post(
      saveRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
      body: json.encode(values),
      encoding: Encoding.getByName(constants.encodingTypeUTF8),
    );

    if (saveResponse.statusCode != HttpStatus.ok) {
      throw saveMealplanFormTwoFailedGeneric();
    }
  }

  /// Get mealplan form three.
  Future<Mealplan> getMealplanFormThree(String? key) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    final getRequest = Uri(
      scheme: Environment().config.apiUriScheme,
      host: Environment().config.apiHost,
      port: Environment().config.apiPort,
      path: constants.apiEndpointMealplanFormThree,
    );

    final getResponse = await _httpClient.get(
      getRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
    );

    if (getResponse.statusCode != HttpStatus.ok) {
      throw getMealplanFormThreeFailedGeneric();
    }

    final parsed = jsonDecode(getResponse.body) as Map<String, dynamic>;
    return Mealplan.fromJson(parsed);
  }

  /// Saves mealplan form three.
  Future<void> saveMealplanFormThree({
    required String? key,
    required Map<String, dynamic> values,
  }) async {
    if (key?.isEmpty ?? true) {
      throw storedAuthTokenEmpty();
    }

    final saveRequest = Uri(
      scheme: Environment().config.apiUriScheme,
      host: Environment().config.apiHost,
      port: Environment().config.apiPort,
      path: constants.apiEndpointMealplanFormThree,
    );

    final saveResponse = await _httpClient.post(
      saveRequest,
      headers: {
        HttpHeaders.authorizationHeader: 'Token $key',
        HttpHeaders.contentTypeHeader: constants.contentTypeJSON,
        constants.headerAPIKey: dotenv.get('API_KEY'),
      },
      body: json.encode(values),
      encoding: Encoding.getByName(constants.encodingTypeUTF8),
    );

    if (saveResponse.statusCode != HttpStatus.ok) {
      throw saveMealplanFormThreeFailedGeneric();
    }
  }
}
