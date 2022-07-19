import 'dart:io' show Platform;
import 'package:app_repository/app_repository.dart';
import 'package:constants/constants.dart' as constants;
import 'package:health_kit_reporter/health_kit_reporter.dart';
import 'package:health_kit_reporter/model/payload/quantity.dart';
import 'package:health_kit_reporter/model/payload/source.dart';
import 'package:health_kit_reporter/model/payload/source_revision.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';
import 'package:intl/intl.dart';

/// Map Famnom Nutrient IDs to Apple HealthKit Nutrient IDs.
final nutrientIDToQuantityTypeMap = {
  constants.FAT_NUTRIENT_ID: QuantityType.dietaryFatTotal.identifier,
  constants.POLYUNSATURATED_FAT_NUTRIENT_ID:
      QuantityType.dietaryFatPolyunsaturated.identifier,
  constants.MONOUNSATURATED_FAT_NUTRIENT_ID:
      QuantityType.dietaryFatMonounsaturated.identifier,
  constants.SATURATED_FAT_NUTRIENT_ID:
      QuantityType.dietaryFatSaturated.identifier,
  constants.CHOLESTEROL_NUTRIENT_ID: QuantityType.dietaryCholesterol.identifier,
  constants.SODIUM_NUTRIENT_ID: QuantityType.dietarySodium.identifier,
  constants.CARBOHYDRATE_NUTRIENT_ID:
      QuantityType.dietaryCarbohydrates.identifier,
  constants.TOTAL_FIBER_NUTRIENT_ID: QuantityType.dietaryFiber.identifier,
  constants.TOTAL_SUGARS_NUTRIENT_ID: QuantityType.dietarySugar.identifier,
  constants.ENERGY_NUTRIENT_ID: QuantityType.dietaryEnergyConsumed.identifier,
  constants.PROTEIN_NUTRIENT_ID: QuantityType.dietaryProtein.identifier,
  constants.VITAMIN_A_NUTRIENT_ID: QuantityType.dietaryVitaminA.identifier,
  constants.VITAMIN_B6_NUTRIENT_ID: QuantityType.dietaryVitaminB6.identifier,
  constants.VITAMIN_B12_NUTRIENT_ID: QuantityType.dietaryVitaminB12.identifier,
  constants.VITAMIN_C_NUTRIENT_ID: QuantityType.dietaryVitaminC.identifier,
  constants.VITAMIN_D_NUTRIENT_ID: QuantityType.dietaryVitaminD.identifier,
  constants.VITAMIN_E_NUTRIENT_ID: QuantityType.dietaryVitaminE.identifier,
  constants.VITAMIN_K_NUTRIENT_ID: QuantityType.dietaryVitaminK.identifier,
  constants.CALCIUM_NUTRIENT_ID: QuantityType.dietaryCalcium.identifier,
  constants.IRON_NUTRIENT_ID: QuantityType.dietaryIron.identifier,
  constants.THIAMIN_NUTRIENT_ID: QuantityType.dietaryThiamin.identifier,
  constants.RIBOFLAVIN_NUTRIENT_ID: QuantityType.dietaryRiboflavin.identifier,
  constants.NIACIN_NUTRIENT_ID: QuantityType.dietaryNiacin.identifier,
  constants.FOLATE_NUTRIENT_ID: QuantityType.dietaryFolate.identifier,
  constants.BIOTIN_NUTRIENT_ID: QuantityType.dietaryBiotin.identifier,
  constants.PANTOTHENIC_ACID_NUTRIENT_ID:
      QuantityType.dietaryPantothenicAcid.identifier,
  constants.PHOSPHORUS_NUTRIENT_ID: QuantityType.dietaryPhosphorus.identifier,
  constants.IODINE_NUTRIENT_ID: QuantityType.dietaryIodine.identifier,
  constants.MAGNESIUM_NUTRIENT_ID: QuantityType.dietaryMagnesium.identifier,
  constants.ZINC_NUTRIENT_ID: QuantityType.dietaryZinc.identifier,
  constants.SELENIUM_NUTRIENT_ID: QuantityType.dietarySelenium.identifier,
  constants.COPPER_NUTRIENT_ID: QuantityType.dietaryCopper.identifier,
  constants.MANGANESE_NUTRIENT_ID: QuantityType.dietaryManganese.identifier,
  constants.CHROMIUM_NUTRIENT_ID: QuantityType.dietaryChromium.identifier,
  constants.MOLYBDENUM_NUTRIENT_ID: QuantityType.dietaryMolybdenum.identifier,
  constants.CHLORINE_NUTRIENT_ID: QuantityType.dietaryChloride.identifier,
  constants.POTASSIUM_NUTRIENT_ID: QuantityType.dietaryPotassium.identifier,
};

/// Request Apple Health authorization to write nutrition data.
Future<void> requestAuthorization() async {
  try {
    final writeTypes = nutrientIDToQuantityTypeMap.values.toList();
    await HealthKitReporter.requestAuthorization([], writeTypes);
  } catch (_) {}
}

/// Check if Apple Health has been connected.
Future<bool> isAuthorized({String? identifier}) async {
  return HealthKitReporter.isAuthorizedToWrite(
    identifier ?? QuantityType.dietaryEnergyConsumed.identifier,
  );
}

/// Write nutrition data to Apple Health.
Future<void> writeToAppleHealth(DateTime date, Tracker tracker) async {
  if (!constants.enableWritesToAppleHealth) {
    return;
  }

  if (!Platform.isIOS) {
    return;
  }

  try {
    final dateNoon = DateTime(date.year, date.month, date.day, 12);
    for (final entry in nutrientIDToQuantityTypeMap.entries) {
      final canWrite = await isAuthorized(identifier: entry.value);
      if (!canWrite) {
        continue;
      }

      final nutrient = tracker.nutrients.values[entry.key];
      if (nutrient == null || nutrient.amount == null) {
        continue;
      }

      final data = Quantity(
        '',
        entry.value,
        dateNoon.millisecondsSinceEpoch,
        dateNoon.millisecondsSinceEpoch,
        null,
        const SourceRevision(
          Source(constants.appTitle, constants.appBundle),
          null,
          null,
          '',
          OperatingSystem(0, 0, 0),
        ),
        QuantityHarmonized(nutrient.amount!, nutrient.unit!, <String, dynamic>{
          'HKMetadataKeySyncVersion': DateTime.now().millisecondsSinceEpoch,
          'HKMetadataKeySyncIdentifier':
              // ignore: lines_longer_than_80_chars
              '${constants.appTitle}-${DateFormat(constants.DATE_FORMAT).format(date)}-${nutrient.id}',
        }),
      );

      await HealthKitReporter.save(data);
    }
  } catch (_) {}
}
