import 'package:constants/constants.dart' as constants;
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'preference.g.dart';

/// {@template preference}
/// Preference model
/// {@endtemplate}
@JsonSerializable()
class Preference extends Equatable {
  /// {@macro preference}
  const Preference({
    this.foodNutrientId,
    required this.thresholds,
  });

  /// Deserialize json to Preference object.
  factory Preference.fromJson(Map<String, dynamic> json) =>
      _$PreferenceFromJson(json);

  /// Serialize Preference object to json.
  Map<String, dynamic> toJson() => _$PreferenceToJson(this);

  /// Nutrient ID.
  final int? foodNutrientId;

  /// Preference threshold value.
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
  List<Object?> get props => [foodNutrientId, thresholds];
}
