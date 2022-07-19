import 'dart:async';

import 'package:app_repository/app_repository.dart';
import 'package:cache/cache.dart';
import 'package:constants/constants.dart' as constants;
import 'package:famnom_api/famnom_api.dart' as famnom;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template app_repository}
/// Repository which manages all app flows besides search and Auth.
/// {@endtemplate}
class AppRepository {
  /// {@macro app_repository}
  AppRepository({
    CacheClient? cache,
    famnom.FamnomApiClient? famnomApiClient,
  })  : _cache = cache ?? CacheClient(),
        _famnomApiClient = famnomApiClient ?? famnom.FamnomApiClient();

  final CacheClient _cache;
  final famnom.FamnomApiClient _famnomApiClient;

  /// App constants cache key.
  static const appConstantsCacheKey = '__app_constants_cache_key__';

  /// FDA RDI cache key.
  static const fdaRDIsCacheKey = '__fda_rdis_cache_key__';

  /// Label nutrients metadata cache key.
  static const labelNutrientsCacheKey = '__label_nutrients_cache_key__';

  /// Nutrition preferences cache key.
  static const nutritionPreferencesCacheKey =
      '__nutrition_preferences_cache_key__';

  /// URI to fetch the next my foods page results.
  String? myFoodsNextURI;

  /// URI to fetch the next my recipes page results.
  String? myRecipesNextURI;

  /// URI to fetch the next my meals page results.
  String? myMealsNextURI;

  /// Global app constants, to be fetched and cached once per session.
  AppConstants? get appConstants {
    return _cache.read<AppConstants>(key: appConstantsCacheKey);
  }

  /// FDA RDI values for all age groups.
  Map<FDAGroup, Map<int, FdaRdi>> get fdaRDIs {
    return _cache.read<Map<FDAGroup, Map<int, FdaRdi>>>(key: fdaRDIsCacheKey) ??
        <FDAGroup, Map<int, FdaRdi>>{};
  }

  /// Label nutrient metadata.
  Map<int, Nutrient> get labelNutrientsMetadata {
    return _cache.read<Map<int, Nutrient>>(key: labelNutrientsCacheKey) ??
        <int, Nutrient>{};
  }

  /// Nutrition preferences.
  Map<int, Preference> get nutritionPreferences {
    return _cache.read<Map<int, Preference>>(
          key: nutritionPreferencesCacheKey,
        ) ??
        <int, Preference>{};
  }

  /// Gets [DBFood] details.
  ///
  /// Throws a [GetDBFoodFailure] if an exception occurs.
  Future<DBFood> getDBFood(String externalId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      final famnomAPIDBFood = await _famnomApiClient.getDBFood(key, externalId);
      final dbFood =
          // ignore: unnecessary_null_comparison
          famnomAPIDBFood == null ? DBFood.empty : famnomAPIDBFood.toDBFood;
      return dbFood;
    } on famnom.FamnomAPIException catch (e) {
      throw GetDBFoodFailure.fromAPIException(e);
    } catch (_) {
      throw const GetDBFoodFailure();
    }
  }

  /// Gets [UserIngredientDisplay] details.
  ///
  /// Throws a [GetUserIngredientFailure] if an exception occurs.
  Future<UserIngredientDisplay> getUserIngredient(
    String externalId, [
    String? membershipExternalId,
  ]) async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      final famnomAPIUserIngredient = await _famnomApiClient.getUserIngredient(
        key,
        externalId,
        membershipExternalId,
      );
      final userIngredient =
          // ignore: unnecessary_null_comparison
          famnomAPIUserIngredient == null
              ? UserIngredientDisplay.empty
              : famnomAPIUserIngredient.toUserIngredientDisplay;
      return userIngredient;
    } on famnom.FamnomAPIException catch (e) {
      throw GetUserIngredientFailure.fromAPIException(e);
    } catch (_) {
      throw const GetUserIngredientFailure();
    }
  }

  /// Gets [UserIngredientMutable] details.
  ///
  /// Throws a [GetUserIngredientFailure] if an exception occurs.
  Future<UserIngredientMutable> getMutableUserIngredient({
    required String externalId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      final famnomAPIUserIngredient = await _famnomApiClient
          .getMutableUserIngredient(key: key, externalId: externalId);
      final userIngredient =
          // ignore: unnecessary_null_comparison
          famnomAPIUserIngredient == null
              ? UserIngredientMutable.empty
              : famnomAPIUserIngredient.toUserIngredientMutable;
      return userIngredient;
    } on famnom.FamnomAPIException catch (e) {
      throw GetUserIngredientFailure.fromAPIException(e);
    } catch (_) {
      throw const GetUserIngredientFailure();
    }
  }

  /// Gets [UserRecipeDisplay] details.
  ///
  /// Throws a [GetUserRecipeFailure] if an exception occurs.
  Future<UserRecipeDisplay> getUserRecipe(
    String externalId, [
    String? membershipExternalId,
  ]) async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      final famnomAPIUserRecipe = await _famnomApiClient.getUserRecipe(
        key,
        externalId,
        membershipExternalId,
      );
      final userRecipe =
          // ignore: unnecessary_null_comparison
          famnomAPIUserRecipe == null
              ? UserRecipeDisplay.empty
              : famnomAPIUserRecipe.toUserRecipeDisplay;
      return userRecipe;
    } on famnom.FamnomAPIException catch (e) {
      throw GetUserRecipeFailure.fromAPIException(e);
    } catch (_) {
      throw const GetUserRecipeFailure();
    }
  }

  /// Gets [UserRecipeMutable] details.
  ///
  /// Throws a [GetUserRecipeFailure] if an exception occurs.
  Future<UserRecipeMutable> getMutableUserRecipe({
    required String externalId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      final famnomAPIUserRecipe = await _famnomApiClient.getMutableUserRecipe(
        key: key,
        externalId: externalId,
      );
      final userRecipe =
          // ignore: unnecessary_null_comparison
          famnomAPIUserRecipe == null
              ? UserRecipeMutable.empty
              : famnomAPIUserRecipe.toUserRecipeMutable;
      return userRecipe;
    } on famnom.FamnomAPIException catch (e) {
      throw GetUserRecipeFailure.fromAPIException(e);
    } catch (_) {
      throw const GetUserRecipeFailure();
    }
  }

  /// Gets [UserMealDisplay] details.
  ///
  /// Throws a [GetUserMealFailure] if an exception occurs.
  Future<UserMealDisplay> getUserMeal(String externalId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      final famnomAPIUserMeal =
          await _famnomApiClient.getUserMeal(key, externalId);
      final userMeal =
          // ignore: unnecessary_null_comparison
          famnomAPIUserMeal == null
              ? UserMealDisplay.empty
              : famnomAPIUserMeal.toUserMealDisplay;
      return userMeal;
    } on famnom.FamnomAPIException catch (e) {
      throw GetUserMealFailure.fromAPIException(e);
    } catch (_) {
      throw const GetUserMealFailure();
    }
  }

  /// Gets [UserMealMutable] details.
  ///
  /// Throws a [GetUserMealFailure] if an exception occurs.
  Future<UserMealMutable> getMutableUserMeal({
    required String externalId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      final famnomAPIUserMeal = await _famnomApiClient.getMutableUserMeal(
        key: key,
        externalId: externalId,
      );
      final userMeal =
          // ignore: unnecessary_null_comparison
          famnomAPIUserMeal == null
              ? UserMealMutable.empty
              : famnomAPIUserMeal.toUserMealMutable;
      return userMeal;
    } on famnom.FamnomAPIException catch (e) {
      throw GetUserMealFailure.fromAPIException(e);
    } catch (_) {
      throw const GetUserMealFailure();
    }
  }

  /// Gets [FdaRdi] nutrition values map.
  ///
  /// Throws a [GetConfigNutritionFailure] if an exception occurs
  Future<Map<FDAGroup, Map<int, FdaRdi>>> getConfigNutrition() async {
    final cachedConfig = fdaRDIs;
    if (cachedConfig.isNotEmpty) {
      return cachedConfig;
    }

    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      final response = await _famnomApiClient.getConfigNutrition(key);
      final config = response.toFDARDIMap;
      _cache.write(key: fdaRDIsCacheKey, value: config);
      return config;
    } on famnom.FamnomAPIException catch (e) {
      throw GetConfigNutritionFailure.fromAPIException(e);
    } catch (_) {
      throw const GetConfigNutritionFailure();
    }
  }

  /// Gets [Nutrient] nutrition values map.
  ///
  /// Throws a [GetConfigNutritionLabelFailure] if an exception occurs
  Future<Map<int, Nutrient>> getConfigNutritionLabel() async {
    final cachedConfig = labelNutrientsMetadata;
    if (cachedConfig.isNotEmpty) {
      return cachedConfig;
    }

    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      final response = await _famnomApiClient.getConfigNutritionLabel(key);
      final config = response.toNutrientMap;
      _cache.write(key: labelNutrientsCacheKey, value: config);
      return config;
    } on famnom.FamnomAPIException catch (e) {
      throw GetConfigNutritionLabelFailure.fromAPIException(e);
    } catch (_) {
      throw const GetConfigNutritionLabelFailure();
    }
  }

  /// Fetches globals [AppConstants].
  ///
  /// Throws a [GetAppConstantsFailure] if an exception occurs
  Future<AppConstants> getAppConstants() async {
    final cachedConfig = appConstants;
    if (cachedConfig != null) {
      return cachedConfig;
    }

    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      final response = await _famnomApiClient.getAppConstants(key);
      final config = response.toAppConstants;
      _cache.write(key: appConstantsCacheKey, value: config);

      if (config.fdaRdis != null) {
        _cache.write(key: fdaRDIsCacheKey, value: config.fdaRdis!);
      }

      if (config.labelNutrients != null) {
        _cache.write(
          key: labelNutrientsCacheKey,
          value: config.labelNutrients!,
        );
      }

      return config;
    } on famnom.FamnomAPIException catch (e) {
      throw GetAppConstantsFailure.fromAPIException(e);
    } catch (_) {
      throw const GetAppConstantsFailure();
    }
  }

  /// Gets nutrition [Preference] map.
  ///
  /// Throws a [GetNutritionPreferencesFailure] if an exception occurs
  Future<Map<int, Preference>> getNutritionPreferences({
    bool skipCache = false,
  }) async {
    if (!skipCache) {
      final cachedPreferences = nutritionPreferences;
      if (cachedPreferences.isNotEmpty) {
        return cachedPreferences;
      }
    }
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      final response = await _famnomApiClient.getNutritionPreferences(key);
      final preferences = {
        for (var preference in response)
          preference.foodNutrientId!: preference.toPreference
      };
      _cache.write(key: nutritionPreferencesCacheKey, value: preferences);
      return preferences;
    } on famnom.FamnomAPIException catch (e) {
      throw GetNutritionPreferencesFailure.fromAPIException(e);
    } catch (_) {
      throw const GetNutritionPreferencesFailure();
    }
  }

  /// Save [DBFood] to Kitchen.
  ///
  /// Throws a [SaveDBFoodFailure] if an exception occurs.
  Future<void> saveDBFood(String externalId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      await _famnomApiClient.saveDBFood(key, externalId);
    } on famnom.FamnomAPIException catch (e) {
      throw SaveDBFoodFailure.fromAPIException(e);
    } catch (_) {
      throw const SaveDBFoodFailure();
    }
  }

  /// Log [DBFood] in a meal.
  ///
  /// Throws a [LogDBFoodFailure] if an exception occurs.
  Future<void> logDBFood({
    required String externalId,
    required String mealType,
    required DateTime mealDate,
    required String serving,
    double? quantity,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      await _famnomApiClient.logDBFood(
        key: key,
        externalId: externalId,
        mealType: mealType,
        mealDate: DateFormat(constants.DATE_FORMAT).format(mealDate),
        serving: serving,
        quantity: quantity,
      );
    } on famnom.FamnomAPIException catch (e) {
      throw LogDBFoodFailure.fromAPIException(e);
    } catch (_) {
      throw const LogDBFoodFailure();
    }
  }

  /// Log [UserIngredientDisplay] in a meal.
  ///
  /// Throws a [LogUserIngredientFailure] if an exception occurs.
  Future<void> logUserIngredient({
    required String externalId,
    String? membershipExternalId,
    required String mealType,
    required DateTime mealDate,
    required String serving,
    double? quantity,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      await _famnomApiClient.logUserIngredient(
        key: key,
        externalId: externalId,
        membershipExternalId: membershipExternalId,
        mealType: mealType,
        mealDate: DateFormat(constants.DATE_FORMAT).format(mealDate),
        serving: serving,
        quantity: quantity,
      );
    } on famnom.FamnomAPIException catch (e) {
      throw LogUserIngredientFailure.fromAPIException(e);
    } catch (_) {
      throw const LogUserIngredientFailure();
    }
  }

  /// Log [UserRecipeDisplay] in a meal.
  ///
  /// Throws a [LogUserRecipeFailure] if an exception occurs.
  Future<void> logUserRecipe({
    required String externalId,
    String? membershipExternalId,
    required String mealType,
    required DateTime mealDate,
    required String serving,
    double? quantity,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      await _famnomApiClient.logUserRecipe(
        key: key,
        externalId: externalId,
        membershipExternalId: membershipExternalId,
        mealType: mealType,
        mealDate: DateFormat(constants.DATE_FORMAT).format(mealDate),
        serving: serving,
        quantity: quantity,
      );
    } on famnom.FamnomAPIException catch (e) {
      throw LogUserRecipeFailure.fromAPIException(e);
    } catch (_) {
      throw const LogUserRecipeFailure();
    }
  }

  /// Searches my foods with a [query] .
  ///
  /// Throws a [MyFoodsFailure] if an exception occurs.
  Future<List<UserIngredientDisplay>> myFoodsWithQuery({
    String query = '',
    String? flagSet,
    String? flagUnset,
    int? pageSize,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      final myFoodsResponse = await _famnomApiClient.getMyFoods(
        key,
        query,
        null,
        flagSet,
        flagUnset,
        pageSize,
      );
      myFoodsNextURI = myFoodsResponse.next;
      return myFoodsResponse.toResults;
    } on famnom.FamnomAPIException catch (e) {
      throw MyFoodsFailure.fromAPIException(e);
    } catch (_) {
      throw const MyFoodsFailure();
    }
  }

  /// Searches with a [myFoodsNextURI].
  ///
  /// Throws a [MyFoodsFailure] if an exception occurs.
  Future<List<UserIngredientDisplay>> myFoodsWithURI() async {
    if (myFoodsNextURI == null) {
      return [];
    }

    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      final myFoodsResponse =
          await _famnomApiClient.getMyFoods(key, null, myFoodsNextURI);
      myFoodsNextURI = myFoodsResponse.next;
      return myFoodsResponse.toResults;
    } on famnom.FamnomAPIException catch (e) {
      throw MyFoodsFailure.fromAPIException(e);
    } catch (_) {
      throw const MyFoodsFailure();
    }
  }

  /// Searches my recipes with a [query] .
  ///
  /// Throws a [MyRecipesFailure] if an exception occurs.
  Future<List<UserRecipeDisplay>> myRecipesWithQuery({
    String query = '',
    String? flagSet,
    String? flagUnset,
    int? pageSize,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      final myRecipesResponse = await _famnomApiClient.getMyRecipes(
        key,
        query,
        null,
        flagSet,
        flagUnset,
        pageSize,
      );
      myRecipesNextURI = myRecipesResponse.next;
      return myRecipesResponse.toResults;
    } on famnom.FamnomAPIException catch (e) {
      throw MyRecipesFailure.fromAPIException(e);
    } catch (_) {
      throw const MyRecipesFailure();
    }
  }

  /// Searches with a [myRecipesNextURI].
  ///
  /// Throws a [MyRecipesFailure] if an exception occurs.
  Future<List<UserRecipeDisplay>> myRecipesWithURI() async {
    if (myRecipesNextURI == null) {
      return [];
    }

    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      final myRecipesResponse =
          await _famnomApiClient.getMyRecipes(key, null, myRecipesNextURI);
      myRecipesNextURI = myRecipesResponse.next;
      return myRecipesResponse.toResults;
    } on famnom.FamnomAPIException catch (e) {
      throw MyRecipesFailure.fromAPIException(e);
    } catch (_) {
      throw const MyRecipesFailure();
    }
  }

  /// Get initial my meals.
  ///
  /// Throws a [MyMealsFailure] if an exception occurs.
  Future<List<UserMealDisplay>> myMeals() async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      final myMealsResponse = await _famnomApiClient.getMyMeals(key, null);
      myMealsNextURI = myMealsResponse.next;
      return myMealsResponse.toResults;
    } on famnom.FamnomAPIException catch (e) {
      throw MyMealsFailure.fromAPIException(e);
    } catch (_) {
      throw const MyMealsFailure();
    }
  }

  /// Searches with a [myMealsNextURI].
  ///
  /// Throws a [MyMealsFailure] if an exception occurs.
  Future<List<UserMealDisplay>> myMealsWithURI() async {
    if (myMealsNextURI == null) {
      return [];
    }

    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      final myMealsResponse =
          await _famnomApiClient.getMyMeals(key, myRecipesNextURI);
      myMealsNextURI = myMealsResponse.next;
      return myMealsResponse.toResults;
    } on famnom.FamnomAPIException catch (e) {
      throw MyMealsFailure.fromAPIException(e);
    } catch (_) {
      throw const MyMealsFailure();
    }
  }

  /// Delete [UserIngredientDisplay] from Kitchen.
  ///
  /// Throws a [DeleteUserIngredientFailure] if an exception occurs.
  Future<void> deleteUserIngredient({
    required String externalId,
    String? membershipExternalId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      await _famnomApiClient.deleteUserIngredient(
        key: key,
        externalId: externalId,
        membershipExternalId: membershipExternalId,
      );
    } on famnom.FamnomAPIException catch (e) {
      throw DeleteUserIngredientFailure.fromAPIException(e);
    } catch (_) {
      throw const DeleteUserIngredientFailure();
    }
  }

  /// Delete [UserRecipeDisplay] from Kitchen.
  ///
  /// Throws a [DeleteUserRecipeFailure] if an exception occurs.
  Future<void> deleteUserRecipe({
    required String externalId,
    String? membershipExternalId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      await _famnomApiClient.deleteUserRecipe(
        key: key,
        externalId: externalId,
        membershipExternalId: membershipExternalId,
      );
    } on famnom.FamnomAPIException catch (e) {
      throw DeleteUserRecipeFailure.fromAPIException(e);
    } catch (_) {
      throw const DeleteUserRecipeFailure();
    }
  }

  /// Delete [UserMealDisplay] from Kitchen.
  ///
  /// Throws a [DeleteUserMealFailure] if an exception occurs.
  Future<void> deleteUserMeal({required String externalId}) async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      await _famnomApiClient.deleteUserMeal(
        key: key,
        externalId: externalId,
      );
    } on famnom.FamnomAPIException catch (e) {
      throw DeleteUserMealFailure.fromAPIException(e);
    } catch (_) {
      throw const DeleteUserMealFailure();
    }
  }

  /// Gets [Tracker] details.
  ///
  /// Throws a [GetTrackerFailure] if an exception occurs.
  Future<Tracker> getTracker(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      final trackerDate = DateFormat(constants.DATE_FORMAT).format(date);
      final famnomAPITrackerResponse =
          await _famnomApiClient.getTracker(key, trackerDate);
      final tracker =
          // ignore: unnecessary_null_comparison
          famnomAPITrackerResponse == null
              ? Tracker.empty
              : famnomAPITrackerResponse.toTracker;
      return tracker;
    } on famnom.FamnomAPIException catch (e) {
      throw GetTrackerFailure.fromAPIException(e);
    } catch (_) {
      throw const GetTrackerFailure();
    }
  }

  /// Save Nutrition Preferences to Kitchen.
  ///
  /// Throws a [SaveNutritionPreferencesFailure] if an exception occurs.
  Future<void> saveNutritionPreferences(Map<String, dynamic> values) async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      await _famnomApiClient.saveNutritionPreferences(key, values);
    } on famnom.FamnomAPIException catch (e) {
      throw SaveNutritionPreferencesFailure.fromAPIException(e);
    } catch (_) {
      throw const SaveNutritionPreferencesFailure();
    }
  }

  /// Save user ingredient. Creates / edits as needed, and returns the saved
  /// user ingredient.
  ///
  /// Throws a [SaveUserIngredientFailure] if an exception occurs.
  Future<String> saveUserIngredient({
    required Map<String, dynamic> values,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      return _famnomApiClient.saveUserIngredient(
        key: key,
        values: values,
      );
    } on famnom.FamnomAPIException catch (e) {
      throw SaveUserIngredientFailure.fromAPIException(e);
    } catch (_) {
      throw const SaveUserIngredientFailure();
    }
  }

  /// Save user recipe. Creates / edits as needed, and returns the saved
  /// user recipe.
  ///
  /// Throws a [SaveUserRecipeFailure] if an exception occurs.
  Future<String> saveUserRecipe({
    required Map<String, dynamic> values,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      return _famnomApiClient.saveUserRecipe(
        key: key,
        values: values,
      );
    } on famnom.FamnomAPIException catch (e) {
      throw SaveUserRecipeFailure.fromAPIException(e);
    } catch (_) {
      throw const SaveUserRecipeFailure();
    }
  }

  /// Save user meal. Creates / edits as needed, and returns the saved
  /// user meal.
  ///
  /// Throws a [SaveUserMealFailure] if an exception occurs.
  Future<String> saveUserMeal({
    required Map<String, dynamic> values,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      return _famnomApiClient.saveUserMeal(key: key, values: values);
    } on famnom.FamnomAPIException catch (e) {
      throw SaveUserMealFailure.fromAPIException(e);
    } catch (_) {
      throw const SaveUserMealFailure();
    }
  }

  /// Gets [NutrientPage] details.
  ///
  /// Throws a [GetNutrientPageFailure] if an exception occurs.
  Future<NutrientPage> getNutrientPage({
    required int nutrientId,
    int chartDays = constants.DEFAULT_CHART_DAYS,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      final famnomAPIResponse = await _famnomApiClient.getNutrientPage(
        key: key,
        nutrientId: nutrientId,
        chartDays: chartDays,
      );
      return famnomAPIResponse.toNutrientPage;
    } on famnom.FamnomAPIException catch (e) {
      throw GetNutrientPageFailure.fromAPIException(e);
    } catch (_) {
      throw const GetNutrientPageFailure();
    }
  }

  /// Save mealplan form one.
  ///
  /// Throws a [SaveMealplanFormOneFailure] if an exception occurs.
  Future<void> saveMealplanFormOne({
    required Map<String, dynamic> values,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      return _famnomApiClient.saveMealplanFormOne(key: key, values: values);
    } on famnom.FamnomAPIException catch (e) {
      throw SaveMealplanFormOneFailure.fromAPIException(e);
    } catch (_) {
      throw const SaveMealplanFormOneFailure();
    }
  }

  /// Get mealplan form two.
  ///
  /// Throws a [GetMealplanFormTwoFailure] if an exception occurs
  Future<List<MealplanPreference>> getMealplanFormTwo() async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      final response = await _famnomApiClient.getMealplanFormTwo(key);
      return response.map((e) => e.toPreference).toList();
    } on famnom.FamnomAPIException catch (e) {
      throw GetMealplanFormTwoFailure.fromAPIException(e);
    } catch (_) {
      throw const GetMealplanFormTwoFailure();
    }
  }

  /// Save mealplan form two.
  ///
  /// Throws a [SaveMealplanFormTwoFailure] if an exception occurs.
  Future<void> saveMealplanFormTwo({
    required Map<String, dynamic> values,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      return _famnomApiClient.saveMealplanFormTwo(key: key, values: values);
    } on famnom.FamnomAPIException catch (e) {
      throw SaveMealplanFormTwoFailure.fromAPIException(e);
    } catch (_) {
      throw const SaveMealplanFormTwoFailure();
    }
  }

  /// Get mealplan form three.
  ///
  /// Throws a [GetMealplanFormThreeFailure] if an exception occurs
  Future<Mealplan> getMealplanFormThree() async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      final response = await _famnomApiClient.getMealplanFormThree(key);
      return response.toMealplan;
    } on famnom.FamnomAPIException catch (e) {
      throw GetMealplanFormThreeFailure.fromAPIException(e);
    } catch (_) {
      throw const GetMealplanFormThreeFailure();
    }
  }

  /// Save mealplan form three.
  ///
  /// Throws a [SaveMealplanFormThreeFailure] if an exception occurs.
  Future<void> saveMealplanFormThree({
    required Map<String, dynamic> values,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      return _famnomApiClient.saveMealplanFormThree(key: key, values: values);
    } on famnom.FamnomAPIException catch (e) {
      throw SaveMealplanFormThreeFailure.fromAPIException(e);
    } catch (_) {
      throw const SaveMealplanFormThreeFailure();
    }
  }
}

/// Conversion extension for famnom DBBrandedFood => App Repository Brand.
extension FamnomAPIToAppDBBrandConversion on famnom.DBBrandedFood {
  /// Converter method.
  Brand get toBrand {
    return Brand(
      brandOwner: brandOwner,
      brandName: brandName,
      subBrandName: subBrandName,
      gtinUpc: gtinUpc,
      ingredients: ingredients,
      notASignificantSourceOf: notASignificantSourceOf,
    );
  }
}

/// Conversion extension for famnom DBBrandedFood => App Repository Brand.
extension FamnomAPIToAppBrandConversion on famnom.Brand {
  /// Converter method.
  Brand get toBrand {
    return Brand(
      brandOwner: brandOwner,
      brandName: brandName,
      subBrandName: subbrandName,
      gtinUpc: gtinUpc,
    );
  }
}

/// Conversion extension for famnom Portion => App Repository Portion.
extension FamnomAPIToAppPortionConversion on famnom.Portion {
  /// Converter method.
  Portion get toPortion {
    return Portion(
      externalId: externalId,
      name: name,
      servingSize: servingSize,
      servingSizeUnit: servingSizeUnit,
      servingsPerContainer: servingsPerContainer,
      quantity: quantity,
    );
  }
}

/// Conversion extension for famnom UserFoodPortion =>
/// App Repository UserFoodPortion.
extension FamnomAPIToAppUserFoodPortionConversion on famnom.UserFoodPortion {
  /// Converter method.
  UserFoodPortion get toPortion {
    return UserFoodPortion(
      id: id,
      externalId: externalId,
      servingsPerContainer: servingsPerContainer,
      householdQuantity: householdQuantity,
      householdUnit: householdUnit,
      servingSize: servingSize,
      servingSizeUnit: servingSizeUnit,
    );
  }
}

/// Conversion extension for famnom UserFoodMembership =>
/// App Repository UserFoodMembership.
extension FamnomAPIToAppUserFoodMembershipConversion
    on famnom.UserFoodMembership {
  /// Converter method.
  UserFoodMembership get toMembership {
    return UserFoodMembership(
      id: id,
      externalId: externalId,
      childId: childId,
      childExternalId: childExternalId,
      childName: childName,
      childPortionExternalId: childPortionExternalId,
      childPortionName: childPortionName,
      quantity: quantity,
    );
  }
}

/// Conversion extension for famnom Nutrient => App Repository Nutrient.
extension FamnomAPIToAppNutrientConversion on famnom.Nutrient {
  /// Converter method.
  Nutrient get toNutrient {
    return Nutrient(id: id, name: name, amount: amount, unit: unit);
  }
}

/// Conversion extension for famnom Nutrients => App Repository Nutrients.
extension FamnomAPIToAppNutrientsConversion on famnom.Nutrients {
  /// Converter method.
  Nutrients get toNutrients {
    return Nutrients(
      servingSize: servingSize,
      servingSizeUnit: servingSizeUnit,
      values: {for (var nutrient in values) nutrient.id: nutrient.toNutrient},
    );
  }
}

/// Conversion extension for famnom NutrientPage => App Repository NutrientPage.
extension FamnomAPIToAppNutrientPage on famnom.NutrientPage {
  /// Converter method.
  NutrientPage get toNutrientPage {
    return NutrientPage(
      id: id,
      name: name,
      description: description,
      unit: unit,
      wikipediaUrl: wikipediaUrl,
      recentLfoods:
          recentLfoods?.map((value) => value.toUserIngredientDisplay).toList(),
      topCfoods: topCfoods?.map((value) => value.toDBFood).toList(),
      threshold: threshold,
      amountPerDay: amountPerDay,
    );
  }
}

/// Conversion extension for famnom DBFood => App Repository DBFood.
extension FamnomAPIToAppDBFoodConversion on famnom.DBFood {
  /// Converter method.
  DBFood get toDBFood {
    return DBFood(
      externalId: externalId,
      name: description,
      brand: brand?.toBrand,
      portions: portions?.map((value) => value.toPortion).toList(),
      nutrients: nutrients?.toNutrients,
      lfoodExternalId: lfoodExternalId,
    );
  }
}

/// Conversion extension for famnom AppConstants => App Repository AppConstants.
extension FamnomAPIToAppRepositoryAppConstantsConversion
    on famnom.AppConstants {
  /// Converter method.
  AppConstants get toAppConstants {
    return AppConstants(
      fdaRdis: fdaRdis == null
          ? null
          : famnom.FdaRdiResponse(results: fdaRdis!).toFDARDIMap,
      labelNutrients: labelNutrients == null
          ? null
          : famnom.LabelResponse(results: labelNutrients!).toNutrientMap,
      categories: categories,
      householdQuantities: householdQuantities,
      householdUnits: householdUnits,
      servingSizeUnits: servingSizeUnits,
    );
  }
}

/// Conversion extension for famnom FdaRdiResponse => App Repository FdaRdi Map.
extension FamnomAPIToAppConfigNutritionConversion on famnom.FdaRdiResponse {
  /// Converter method.
  Map<FDAGroup, Map<int, FdaRdi>> get toFDARDIMap {
    final config = <FDAGroup, Map<int, FdaRdi>>{};
    results.forEach((key, value) {
      final newKey = FDAGroup.values
          .firstWhere((element) => element.toString() == key.toString());
      config[newKey] = <int, FdaRdi>{};
      value.forEach((key, value) {
        config[newKey]![int.parse(key)] = FdaRdi(
          id: int.parse(key),
          name: value.name,
          value: value.value,
          unit: value.unit,
          threshold: Threshold.values.firstWhere(
            (element) => element.toString() == value.threshold.toString(),
          ),
        );
      });
    });
    return config;
  }
}

/// Conversion extension for famnom LabelResponse => App Repository Nutrient
/// Map.
extension FamnomAPIToAppConfigNutritionLabelConversion on famnom.LabelResponse {
  /// Converter method.
  Map<int, Nutrient> get toNutrientMap {
    return {for (var item in results) item.id: item.toNutrient};
  }
}

/// Conversion extension for famnom nutrition preferences list => App Repository
/// nutrition preferences Map.
extension FamnomAPIToAppPreferenceConversion on famnom.Preference {
  /// Converter method.
  Preference get toPreference {
    return Preference(
      foodNutrientId: foodNutrientId,
      thresholds: thresholds,
    );
  }
}

/// Conversion extension for famnom MealplanPreference => App Repository
/// MealplanPreference.
extension FamnomAPIToAppMealplanPreferenceConversion
    on famnom.MealplanPreference {
  /// Converter method.
  MealplanPreference get toPreference {
    return MealplanPreference(
      externalId: externalId,
      name: name,
      thresholds: thresholds,
    );
  }
}

/// Conversion extension for famnom Mealplan => App Repository Mealplan.
extension FamnomAPIToAppMealplanConversion on famnom.Mealplan {
  /// Converter method.
  Mealplan get toMealplan {
    return Mealplan(
      infeasible: infeasible,
      results: results.map((value) => value.toMealplanItem).toList(),
    );
  }
}

/// Conversion extension for famnom Mealplan => App Repository Mealplan.
extension FamnomAPIToAppMealplanItemConversion on famnom.MealplanItem {
  /// Converter method.
  MealplanItem get toMealplanItem {
    return MealplanItem(
      externalId: externalId,
      name: name,
      quantity: quantity,
    );
  }
}

/// Conversion extension for famnom UserMemberIngredientDisplay =>
/// App Repository UserMemberIngredientDisplay.
extension FamnomAPIToAppUserMemberIngredientDisplayConversion
    on famnom.UserMemberIngredientDisplay {
  /// Converter method.
  UserMemberIngredientDisplay get toUserMemberIngredientDisplay {
    return UserMemberIngredientDisplay(
      externalId: externalId,
      ingredient: displayIngredient.toUserIngredientDisplay,
      portion: displayPortion?.toPortion,
      ingredientPortionExternalId: ingredientPortionExternalId,
      meal: displayMeal?.toUserMealDisplay,
    );
  }
}

/// Conversion extension for famnom UserMemberRecipeDisplay =>
/// App Repository UserMemberRecipeDisplay.
extension FamnomAPIToAppUserMemberRecipeDisplayConversion
    on famnom.UserMemberRecipeDisplay {
  /// Converter method.
  UserMemberRecipeDisplay get toUserMemberRecipeDisplay {
    return UserMemberRecipeDisplay(
      externalId: externalId,
      recipe: displayRecipe.toUserRecipeDisplay,
      portion: displayPortion?.toPortion,
      recipePortionExternalId: recipePortionExternalId,
      meal: displayMeal?.toUserMealDisplay,
    );
  }
}

/// Conversion extension for famnom UserIngredientDisplay =>
/// App Repository UserIngredientDisplay.
extension FamnomAPIToAppUserIngredientDisplayConversion
    on famnom.UserIngredientDisplay {
  /// Converter method.
  UserIngredientDisplay get toUserIngredientDisplay {
    return UserIngredientDisplay(
      externalId: externalId,
      name: name,
      brand: brand?.toBrand,
      portions: portions?.map((value) => value.toPortion).toList(),
      nutrients: nutrients?.toNutrients,
      category: category,
      membership: membership?.toUserMemberIngredientDisplay,
    );
  }
}

/// Conversion extension for famnom UserIngredientMutable =>
/// App Repository UserIngredientMutable.
extension FamnomAPIToAppUserIngredientMutableConversion
    on famnom.UserIngredientMutable {
  /// Converter method.
  UserIngredientMutable get toUserIngredientMutable {
    return UserIngredientMutable(
      externalId: externalId,
      name: name,
      brand: brand?.toBrand,
      portions: portions?.map((value) => value.toPortion).toList(),
      nutrients: nutrients.toNutrients,
      category: category,
    );
  }
}

/// Conversion extension for famnom UserRecipeDisplay =>
/// App Repository UserRecipeDisplay.
extension FamnomAPIToAppUserRecipeDisplayConversion
    on famnom.UserRecipeDisplay {
  /// Converter method.
  UserRecipeDisplay get toUserRecipeDisplay {
    return UserRecipeDisplay(
      externalId: externalId,
      name: name,
      recipeDate: recipeDate,
      portions: portions?.map((value) => value.toPortion).toList(),
      nutrients: nutrients?.toNutrients,
      memberIngredients: memberIngredients
          ?.map((value) => value.toUserMemberIngredientDisplay)
          .toList(),
      memberRecipes: memberRecipes
          ?.map((value) => value.toUserMemberRecipeDisplay)
          .toList(),
      membership: membership?.toUserMemberRecipeDisplay,
    );
  }
}

/// Conversion extension for famnom UserRecipeMutable =>
/// App Repository UserRecipeMutable.
extension FamnomAPIToAppUserRecipeMutableConversion
    on famnom.UserRecipeMutable {
  /// Converter method.
  UserRecipeMutable get toUserRecipeMutable {
    return UserRecipeMutable(
      externalId: externalId,
      name: name,
      recipeDate: recipeDate,
      portions: portions?.map((value) => value.toPortion).toList(),
      memberIngredients:
          memberIngredients?.map((value) => value.toMembership).toList(),
      memberRecipes: memberRecipes?.map((value) => value.toMembership).toList(),
    );
  }
}

/// Conversion extension for famnom UserMealDisplay =>
/// App Repository UserMealDisplay.
extension FamnomAPIToAppUserMealDisplayConversion on famnom.UserMealDisplay {
  /// Converter method.
  UserMealDisplay get toUserMealDisplay {
    return UserMealDisplay(
      externalId: externalId,
      mealDate: mealDate,
      mealType: mealType,
      nutrients: nutrients?.toNutrients,
      memberIngredients: memberIngredients
          ?.map((value) => value.toUserMemberIngredientDisplay)
          .toList(),
      memberRecipes: memberRecipes
          ?.map((value) => value.toUserMemberRecipeDisplay)
          .toList(),
    );
  }
}

/// Conversion extension for famnom UserMealMutable =>
/// App Repository UserMealMutable.
extension FamnomAPIToAppUserMealMutableConversion on famnom.UserMealMutable {
  /// Converter method.
  UserMealMutable get toUserMealMutable {
    return UserMealMutable(
      externalId: externalId,
      mealType: mealType,
      mealDate: mealDate,
      memberIngredients:
          memberIngredients?.map((value) => value.toMembership).toList(),
      memberRecipes: memberRecipes?.map((value) => value.toMembership).toList(),
    );
  }
}

/// Conversion extension for famnom MyFoodsResponse =>
/// App Repository List<UserIngredientDisplay>.
extension FamnomAPIToAppMyFoodsResponseConversion on famnom.MyFoodsResponse {
  /// Converter method.
  List<UserIngredientDisplay> get toResults {
    return results.map((result) => result.toUserIngredientDisplay).toList();
  }
}

/// Conversion extension for famnom MyRecipesResponse =>
/// App Repository List<UserRecipeDisplay>.
extension FamnomAPIToAppMyRecipesResponseConversion
    on famnom.MyRecipesResponse {
  /// Converter method.
  List<UserRecipeDisplay> get toResults {
    return results.map((result) => result.toUserRecipeDisplay).toList();
  }
}

/// Conversion extension for famnom MyMealsResponse =>
/// App Repository List<UserMealDisplay>.
extension FamnomAPIToAppMyMealsResponseConversion on famnom.MyMealsResponse {
  /// Converter method.
  List<UserMealDisplay> get toResults {
    return results.map((result) => result.toUserMealDisplay).toList();
  }
}

/// Conversion extension for famnom tracker response => App Repository Tracker.
extension FamnomAPIToAppTrackerConversion on famnom.TrackerResponse {
  /// Converter method.
  Tracker get toTracker {
    return Tracker(
      meals: meals.map((result) => result.toUserMealDisplay).toList(),
      nutrients: nutrients.toNutrients,
    );
  }
}
