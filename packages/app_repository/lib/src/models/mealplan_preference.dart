import 'package:constants/constants.dart' as constants;
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mealplan_preference.g.dart';

/// {@template mealplan_preference}
/// MealplanPreference model
/// {@endtemplate}
@JsonSerializable()
class MealplanPreference extends Equatable {
  /// {@macro mealplan_preference}
  const MealplanPreference({
    required this.externalId,
    required this.name,
    required this.thresholds,
  });

  /// Deserialize json to MealplanPreference object.
  factory MealplanPreference.fromJson(Map<String, dynamic> json) =>
      _$MealplanPreferenceFromJson(json);

  /// Serialize MealplanPreference object to json.
  Map<String, dynamic> toJson() => _$MealplanPreferenceToJson(this);

  /// External ID.
  final String externalId;

  /// Name.
  final String name;

  /// Threshold value.
  final List<Map<String, double?>> thresholds;

  /// Get preference threshold value.
  double? get thresholdValue {
    if (thresholds.isEmpty) {
      return null;
    }

    if (thresholds[0]['min_value'] != null) {
      return thresholds[0]['min_value'];
    }

    if (thresholds[0]['max_value'] != null) {
      return thresholds[0]['max_value'];
    }

    if (thresholds[0]['exact_value'] != null) {
      return thresholds[0]['exact_value'];
    }

    return null;
  }

  /// Get preference threshold type.
  String? get thresholdType {
    if (thresholds.isEmpty) {
      return null;
    }

    if (thresholds[0]['min_value'] != null) {
      return constants.THRESHOLD_MORE_THAN;
    }

    if (thresholds[0]['max_value'] != null) {
      return constants.THRESHOLD_LESS_THAN;
    }

    if (thresholds[0]['exact_value'] != null) {
      return constants.THRESHOLD_EXACT;
    }

    return null;
  }

  @override
  List<Object?> get props => [externalId, name, thresholds];
}
