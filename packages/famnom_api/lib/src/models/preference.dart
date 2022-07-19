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

  @override
  List<Object?> get props => [foodNutrientId, thresholds];
}
