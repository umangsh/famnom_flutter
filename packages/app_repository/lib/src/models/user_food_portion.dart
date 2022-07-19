import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_food_portion.g.dart';

/// {@template user_food_portion}
/// UserFoodPortion model
/// {@endtemplate}
@JsonSerializable()
class UserFoodPortion extends Equatable {
  /// {@macro user_food_portion}
  const UserFoodPortion({
    required this.id,
    required this.externalId,
    this.servingsPerContainer,
    this.householdQuantity,
    this.householdUnit,
    required this.servingSize,
    required this.servingSizeUnit,
  });

  /// Deserialize json to UserFoodPortion object.
  factory UserFoodPortion.fromJson(Map<String, dynamic> json) =>
      _$UserFoodPortionFromJson(json);

  /// Serialize UserFoodPortion object to json.
  Map<String, dynamic> toJson() => _$UserFoodPortionToJson(this);

  /// Portion ID.
  final int id;

  /// Portion external ID.
  final String externalId;

  /// Servings per container.
  final double? servingsPerContainer;

  /// Household quantity.
  final String? householdQuantity;

  /// Household unit.
  final String? householdUnit;

  /// Serving Size.
  final double servingSize;

  /// Servings Size Unit.
  final String servingSizeUnit;

  @override
  List<Object?> get props => [
        id,
        externalId,
        servingsPerContainer,
        householdQuantity,
        householdUnit,
        servingSize,
        servingSizeUnit
      ];
}
