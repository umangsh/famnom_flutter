// ignore_for_file: constant_identifier_names, public_member_api_docs
/// Shared preferences.
/// Auth Token shared preference key.
const String prefAuthToken = 'auth_token';

/// Autocomplete suggestions.
const String prefAutocompleteSuggestions = 'autocomplete_suggestions';

/// API Headers.
/// API Key header.
const String headerAPIKey = 'X-API-KEY';

/// JSON content type.
const String contentTypeJSON = 'application/json';

/// utf-8 encoding type.
const String encodingTypeUTF8 = 'utf-8';

/// API endpoints.
/// User API endpoint.
const String apiEndpointAuthUser = 'api/auth/user/';

/// Login API endpoint.
const String apiEndpointAuthLogin = 'api/auth/login/';

/// Logout API endpoint.
const String apiEndpointAuthLogout = 'api/auth/logout/';

/// SignUp/Registration API endpoint.
const String apiEndpointAuthSignUp = 'api/auth/registration/';

/// Search API endpoint.
const String apiEndpointSearch = 'api/search/';

/// DBFood details endpoint.
const String apiEndpointDetailsDBFood = 'api/details/dbfood/';

/// UserIngredient details endpoint.
const String apiEndpointDetailsUserIngredient = 'api/details/useringredient/';

/// UserMeal details endpoint.
const String apiEndpointDetailsUserMeal = 'api/details/usermeal/';

/// UserRecipe details endpoint.
const String apiEndpointDetailsUserRecipe = 'api/details/userrecipe/';

/// FDI Nutrient RDIs endpoint.
const String apiEndpointNutritionFDA = 'api/config/nutrition/fda/';

/// FDI Nutrient RDIs endpoint.
const String apiEndpointNutritionLabel = 'api/config/nutrition/label/';

/// App constants endpoint.
const String apiEndpointAppConstants = 'api/config/appconstants/';

/// Nutrition preferences endpoint.
const String apiEndpointNutritionPreferences = 'api/preferences/nutrition/';

/// Log DBFood to meal endpoint.
const String apiEndpointLogDBFood = 'api/log/dbfood/';

/// Log UserIngredient to meal endpoint.
const String apiEndpointLogUserIngredient = 'api/log/useringredient/';

/// Log UserRecipe to meal endpoint.
const String apiEndpointLogUserRecipe = 'api/log/userrecipe/';

/// Delete UserIngredient.
const String apiEndpointDeleteUserIngredient = 'api/delete/useringredient/';

/// Delete UserRecipe.
const String apiEndpointDeleteUserRecipe = 'api/delete/userrecipe/';

/// Delete UserMeal.
const String apiEndpointDeleteUserMeal = 'api/delete/usermeal/';

/// Create/Edit UserIngredient.
const String apiEndpointEditUserIngredient = 'api/edit/useringredient/';

/// Create/Edit UserRecipe.
const String apiEndpointEditUserRecipe = 'api/edit/userrecipe/';

/// Create/Edit UserMeal.
const String apiEndpointEditUserMeal = 'api/edit/usermeal/';

/// Browse my foods endpoint.
const String apiEndpointMyFoods = 'api/myfoods/';

/// Browse my recipes endpoint.
const String apiEndpointMyRecipes = 'api/myrecipes/';

/// Browse my meals endpoint.
const String apiEndpointMyMeals = 'api/mymeals/';

/// Save food to kitchen endpoint.
const String apiEndpointSaveFoodToKitchen = 'api/savedbfood/';

/// Save nutrition preferences endpoint.
const String apiEndpointMyNutrition = 'api/mynutrition/';

/// Tracker data endpoint.
const String apiEndpointTracker = 'api/tracker/';

/// Nutrient page endpoint.
const String apiEndpointNutrient = 'api/nutrient/';

/// Save Mealplan form one endpoint.
const String apiEndpointMealplanFormOne = 'api/savemealplan/formone/';

/// Save Mealplan form two endpoint.
const String apiEndpointMealplanFormTwo = 'api/savemealplan/formtwo/';

/// Save Mealplan form three endpoint.
const String apiEndpointMealplanFormThree = 'api/savemealplan/formthree/';

/// Server error messages.
/// Incorrect username/password.
const String errorLoginFailed = 'Unable to log in with provided credentials.';

/// Email not verified.
const String errorEmailUnverified = 'E-mail is not verified.';

/// Email already registered.
const String errorEmailExists =
    'A user is already registered with this e-mail address.';

/// Password too common.
const String errorCommonPassword = 'This password is too common.';

/// Display constants.
/// App title.
const String appTitle = 'FAMNOM';

/// App bundle.
const String appBundle = 'com.famnom.famnom';

/// App logo path.
const String appLogoPath = 'assets/app_logo_56.png';

/// Nutrient constants.
const int PROTEIN_NUTRIENT_ID = 1003;
const int FAT_NUTRIENT_ID = 1004;
const int CARBOHYDRATE_NUTRIENT_ID = 1005;
const int ENERGY_NUTRIENT_ID = 1008;
const int STARCH_NUTRIENT_ID = 1009;
const int TOTAL_SUGARS_NUTRIENT_ID = 1063;
const int TOTAL_FIBER_NUTRIENT_ID = 1079;
const int SOLUBLE_FIBER_NUTRIENT_ID = 1082;
const int INSOLUBLE_FIBER_NUTRIENT_ID = 1084;
const int SUGAR_ALCOHOL_NUTRIENT_ID = 1086;
const int CALCIUM_NUTRIENT_ID = 1087;
const int CHLORINE_NUTRIENT_ID = 1088;
const int IRON_NUTRIENT_ID = 1089;
const int MAGNESIUM_NUTRIENT_ID = 1090;
const int PHOSPHORUS_NUTRIENT_ID = 1091;
const int POTASSIUM_NUTRIENT_ID = 1092;
const int SODIUM_NUTRIENT_ID = 1093;
const int SULFUR_NUTRIENT_ID = 1094;
const int ZINC_NUTRIENT_ID = 1095;
const int CHROMIUM_NUTRIENT_ID = 1096;
const int COBALT_NUTRIENT_ID = 1097;
const int COPPER_NUTRIENT_ID = 1098;
const int FLOURIDE_NUTRIENT_ID = 1099;
const int IODINE_NUTRIENT_ID = 1100;
const int MANGANESE_NUTRIENT_ID = 1101;
const int MOLYBDENUM_NUTRIENT_ID = 1102;
const int SELENIUM_NUTRIENT_ID = 1103;
const int VITAMIN_A_NUTRIENT_ID = 1106;
const int VITAMIN_E_NUTRIENT_ID = 1109;
const int VITAMIN_D_NUTRIENT_ID_IU = 1110;
const int VITAMIN_D_NUTRIENT_ID = 1114;
const int VITAMIN_C_NUTRIENT_ID = 1162;
const int THIAMIN_NUTRIENT_ID = 1165;
const int RIBOFLAVIN_NUTRIENT_ID = 1166;
const int NIACIN_NUTRIENT_ID = 1167;
const int PANTOTHENIC_ACID_NUTRIENT_ID = 1170;
const int VITAMIN_B6_NUTRIENT_ID = 1175;
const int BIOTIN_NUTRIENT_ID = 1176;
const int FOLATE_NUTRIENT_ID = 1177;
const int VITAMIN_B12_NUTRIENT_ID = 1178;
const int CHOLINE_NUTRIENT_ID = 1180;
const int VITAMIN_K_NUTRIENT_ID = 1183;
const int ADDED_SUGARS_NUTRIENT_ID = 1235;
const int CHOLESTEROL_NUTRIENT_ID = 1253;
const int TRANS_FAT_NUTRIENT_ID = 1257;
const int SATURATED_FAT_NUTRIENT_ID = 1258;
const int OMEGA_3_DHA_NUTRIENT_ID = 1272;
const int OMEGA_3_EPA_NUTRIENT_ID = 1278;
const int OMEGA_3_DPA_NUTRIENT_ID = 1280;
const int OMEGA_3_ALA_NUTRIENT_ID = 1404;
const int MONOUNSATURATED_FAT_NUTRIENT_ID = 1292;
const int POLYUNSATURATED_FAT_NUTRIENT_ID = 1293;

const List<int> LABEL_TOP_HALF_NUTRIENT_IDS = [
  FAT_NUTRIENT_ID,
  SATURATED_FAT_NUTRIENT_ID,
  TRANS_FAT_NUTRIENT_ID,
  POLYUNSATURATED_FAT_NUTRIENT_ID,
  MONOUNSATURATED_FAT_NUTRIENT_ID,
  CHOLESTEROL_NUTRIENT_ID,
  SODIUM_NUTRIENT_ID,
  FLOURIDE_NUTRIENT_ID,
  CARBOHYDRATE_NUTRIENT_ID,
  TOTAL_FIBER_NUTRIENT_ID,
  SOLUBLE_FIBER_NUTRIENT_ID,
  INSOLUBLE_FIBER_NUTRIENT_ID,
  TOTAL_SUGARS_NUTRIENT_ID,
  ADDED_SUGARS_NUTRIENT_ID,
  SUGAR_ALCOHOL_NUTRIENT_ID,
  PROTEIN_NUTRIENT_ID,
];

const List<int> LABEL_VITAMIN_MINERAL_NUTRIENT_IDS = [
  VITAMIN_D_NUTRIENT_ID,
  CALCIUM_NUTRIENT_ID,
  IRON_NUTRIENT_ID,
  POTASSIUM_NUTRIENT_ID,
  VITAMIN_A_NUTRIENT_ID,
  VITAMIN_C_NUTRIENT_ID,
  VITAMIN_E_NUTRIENT_ID,
  VITAMIN_K_NUTRIENT_ID,
  THIAMIN_NUTRIENT_ID,
  RIBOFLAVIN_NUTRIENT_ID,
  NIACIN_NUTRIENT_ID,
  VITAMIN_B6_NUTRIENT_ID,
  FOLATE_NUTRIENT_ID,
  VITAMIN_B12_NUTRIENT_ID,
  BIOTIN_NUTRIENT_ID,
  PANTOTHENIC_ACID_NUTRIENT_ID,
  PHOSPHORUS_NUTRIENT_ID,
  IODINE_NUTRIENT_ID,
  MAGNESIUM_NUTRIENT_ID,
  ZINC_NUTRIENT_ID,
  SELENIUM_NUTRIENT_ID,
  COPPER_NUTRIENT_ID,
  MANGANESE_NUTRIENT_ID,
  CHROMIUM_NUTRIENT_ID,
  MOLYBDENUM_NUTRIENT_ID,
  CHOLINE_NUTRIENT_ID,
];

// ignore: non_constant_identifier_names
List<int> LABEL_NUTRIENT_IDs = List.from(<int>[ENERGY_NUTRIENT_ID])
  ..addAll(LABEL_TOP_HALF_NUTRIENT_IDS)
  ..addAll(LABEL_VITAMIN_MINERAL_NUTRIENT_IDS);

const List<int> LABEL_BOLD_NUTRIENTS = [
  PROTEIN_NUTRIENT_ID,
  FAT_NUTRIENT_ID,
  CARBOHYDRATE_NUTRIENT_ID,
  ENERGY_NUTRIENT_ID,
  SODIUM_NUTRIENT_ID,
  FLOURIDE_NUTRIENT_ID,
  CHOLESTEROL_NUTRIENT_ID,
];

const List<int> LABEL_ITALIC_NUTRIENTS = [
  TRANS_FAT_NUTRIENT_ID,
];

const List<int> LABEL_SINGLE_SPACE_NUTRIENTS = [
  TOTAL_SUGARS_NUTRIENT_ID,
  TOTAL_FIBER_NUTRIENT_ID,
  SUGAR_ALCOHOL_NUTRIENT_ID,
  TRANS_FAT_NUTRIENT_ID,
  SATURATED_FAT_NUTRIENT_ID,
  MONOUNSATURATED_FAT_NUTRIENT_ID,
  POLYUNSATURATED_FAT_NUTRIENT_ID,
];

const List<int> LABEL_DOUBLE_SPACE_NUTRIENTS = [
  ADDED_SUGARS_NUTRIENT_ID,
  SOLUBLE_FIBER_NUTRIENT_ID,
  INSOLUBLE_FIBER_NUTRIENT_ID,
];

const List<int> TRACKER_NUTRIENT_IDS = [
  ENERGY_NUTRIENT_ID,
  PROTEIN_NUTRIENT_ID,
  FAT_NUTRIENT_ID,
  CARBOHYDRATE_NUTRIENT_ID,
  TOTAL_FIBER_NUTRIENT_ID,
  SOLUBLE_FIBER_NUTRIENT_ID,
  INSOLUBLE_FIBER_NUTRIENT_ID,
  TOTAL_SUGARS_NUTRIENT_ID,
  ADDED_SUGARS_NUTRIENT_ID,
  SUGAR_ALCOHOL_NUTRIENT_ID,
  SATURATED_FAT_NUTRIENT_ID,
  TRANS_FAT_NUTRIENT_ID,
  POLYUNSATURATED_FAT_NUTRIENT_ID,
  MONOUNSATURATED_FAT_NUTRIENT_ID,
  CHOLESTEROL_NUTRIENT_ID,
  OMEGA_3_DHA_NUTRIENT_ID,
  OMEGA_3_EPA_NUTRIENT_ID,
  OMEGA_3_DPA_NUTRIENT_ID,
  OMEGA_3_ALA_NUTRIENT_ID,
  VITAMIN_D_NUTRIENT_ID,
  CALCIUM_NUTRIENT_ID,
  IRON_NUTRIENT_ID,
  POTASSIUM_NUTRIENT_ID,
  VITAMIN_A_NUTRIENT_ID,
  VITAMIN_C_NUTRIENT_ID,
  VITAMIN_E_NUTRIENT_ID,
  VITAMIN_K_NUTRIENT_ID,
  THIAMIN_NUTRIENT_ID,
  RIBOFLAVIN_NUTRIENT_ID,
  NIACIN_NUTRIENT_ID,
  VITAMIN_B6_NUTRIENT_ID,
  FOLATE_NUTRIENT_ID,
  VITAMIN_B12_NUTRIENT_ID,
  BIOTIN_NUTRIENT_ID,
  PANTOTHENIC_ACID_NUTRIENT_ID,
  PHOSPHORUS_NUTRIENT_ID,
  IODINE_NUTRIENT_ID,
  MAGNESIUM_NUTRIENT_ID,
  ZINC_NUTRIENT_ID,
  SELENIUM_NUTRIENT_ID,
  COPPER_NUTRIENT_ID,
  MANGANESE_NUTRIENT_ID,
  CHROMIUM_NUTRIENT_ID,
  MOLYBDENUM_NUTRIENT_ID,
  CHOLINE_NUTRIENT_ID,
];

const List<int> LOW_COVERAGE_NUTRIENT_IDS = [
  BIOTIN_NUTRIENT_ID,
  CHROMIUM_NUTRIENT_ID,
  MOLYBDENUM_NUTRIENT_ID,
  VITAMIN_K_NUTRIENT_ID,
];

const Map<int, int> TRACKER_NUTIRENTS_COLOR_MAP = {
  ENERGY_NUTRIENT_ID: ENERGY_NUTRIENT_COLOR,
  PROTEIN_NUTRIENT_ID: PROTEIN_NUTRIENT_COLOR,
  FAT_NUTRIENT_ID: FAT_NUTRIENT_COLOR,
  SATURATED_FAT_NUTRIENT_ID: FAT_NUTRIENT_COLOR,
  TRANS_FAT_NUTRIENT_ID: FAT_NUTRIENT_COLOR,
  POLYUNSATURATED_FAT_NUTRIENT_ID: FAT_NUTRIENT_COLOR,
  MONOUNSATURATED_FAT_NUTRIENT_ID: FAT_NUTRIENT_COLOR,
  CARBOHYDRATE_NUTRIENT_ID: CARBOHYDRATE_NUTIENT_COLOR,
  TOTAL_FIBER_NUTRIENT_ID: CARBOHYDRATE_NUTIENT_COLOR,
  SOLUBLE_FIBER_NUTRIENT_ID: CARBOHYDRATE_NUTIENT_COLOR,
  INSOLUBLE_FIBER_NUTRIENT_ID: CARBOHYDRATE_NUTIENT_COLOR,
  TOTAL_SUGARS_NUTRIENT_ID: CARBOHYDRATE_NUTIENT_COLOR,
  ADDED_SUGARS_NUTRIENT_ID: CARBOHYDRATE_NUTIENT_COLOR,
  SUGAR_ALCOHOL_NUTRIENT_ID: CARBOHYDRATE_NUTIENT_COLOR,
};

const ENERGY_NUTRIENT_COLOR = 0xFFDC3545;
const PROTEIN_NUTRIENT_COLOR = 0xFFFFC107;
const FAT_NUTRIENT_COLOR = 0xFF28A745;
const CARBOHYDRATE_NUTIENT_COLOR = 0xFF007BFF;
const TRACKER_NUTRTIENT_DEFAULT_COLOR = 0xFF17A2B8;

/// Meal types List[key, value].
const mealTypes = [
  {'id': '', 'name': 'Select meal'},
  {'id': 'Suhur', 'name': 'Suhur'},
  {'id': 'Breakfast', 'name': 'Breakfast'},
  {'id': 'Second Breakfast', 'name': 'Second Breakfast'},
  {'id': 'Elevenses', 'name': 'Elevenses'},
  {'id': 'Brunch', 'name': 'Brunch'},
  {'id': 'Lunch', 'name': 'Lunch'},
  {'id': 'Snack', 'name': 'Snack'},
  {'id': 'Afternoon Tea', 'name': 'Afternoon Tea'},
  {'id': 'Tiffin', 'name': 'Tiffin'},
  {'id': 'Dinner', 'name': 'Dinner'},
  {'id': 'Supper', 'name': 'Supper'},
  {'id': 'Iftar', 'name': 'Iftar'},
  {'id': 'Siu Yeh', 'name': 'Siu Yeh'},
];

const String THRESHOLD_DEFAULT = '';
const String THRESHOLD_LESS_THAN = '1';
const String THRESHOLD_EXACT = '2';
const String THRESHOLD_MORE_THAN = '3';

/// Threshold types List[key, value].
const thresholdTypes = [
  {'id': THRESHOLD_DEFAULT, 'name': 'Select threshold'},
  {'id': THRESHOLD_LESS_THAN, 'name': 'Less than'},
  {'id': THRESHOLD_EXACT, 'name': 'Exactly'},
  {'id': THRESHOLD_MORE_THAN, 'name': 'More than'},
];

/// Default chart days.
const int DEFAULT_CHART_DAYS = 5;

/// Default portion size.
const int DEFAULT_PORTION_SIZE = 100;

/// Default portion size unit.
const String DEFAULT_PORTION_SIZE_UNIT = 'g';

/// Short date format.
const String DATE_FORMAT = 'yyyy-MM-dd';

/// Display date format.
const String DISPLAY_DATE_FORMAT = 'EEEE, d MMM, yyyy';

/// Enable write to apple health.
const bool enableWritesToAppleHealth = false;

/// Food Preference flags.
const String FLAG_IS_NOT_ALLOWED = 'is_not_allowed';
const String FLAG_IS_AVAILABLE = 'is_available';
const String FLAG_IS_NOT_REPEATABLE = 'is_not_repeatable';
const String FLAG_IS_NOT_ZEROABLE = 'is_not_zeroable';
