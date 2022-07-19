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

  @override
  List<Object?> get props => [externalId, name, thresholds];
}
