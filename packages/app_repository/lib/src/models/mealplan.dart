import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mealplan.g.dart';

/// {@template mealplan_item}
/// MealplanItem model
/// {@endtemplate}
@JsonSerializable()
class MealplanItem extends Equatable {
  /// {@macro mealplan_item}
  const MealplanItem({
    required this.externalId,
    required this.name,
    required this.quantity,
  });

  /// Deserialize json to MealplanItem object.
  factory MealplanItem.fromJson(Map<String, dynamic> json) =>
      _$MealplanItemFromJson(json);

  /// Serialize MealplanItem object to json.
  Map<String, dynamic> toJson() => _$MealplanItemToJson(this);

  /// External ID.
  final String externalId;

  /// Name.
  final String name;

  /// Quantity.
  final double quantity;

  @override
  List<Object?> get props => [externalId, name, quantity];
}

/// {@template mealplan}
/// Mealplan model
/// {@endtemplate}
@JsonSerializable()
class Mealplan extends Equatable {
  /// {@macro mealplan}
  const Mealplan({
    required this.infeasible,
    required this.results,
  });

  /// Deserialize json to Mealplan object.
  factory Mealplan.fromJson(Map<String, dynamic> json) =>
      _$MealplanFromJson(json);

  /// Serialize Mealplan object to json.
  Map<String, dynamic> toJson() => _$MealplanToJson(this);

  /// Is the mealplan infeasible?
  final bool infeasible;

  /// List of mealplan items.
  final List<MealplanItem> results;

  @override
  List<Object?> get props => [infeasible, results];
}
