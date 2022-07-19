import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'portion.g.dart';

/// {@template portion}
/// Portion model
/// {@endtemplate}
@JsonSerializable()
class Portion extends Equatable {
  /// {@macro portion}
  const Portion({
    required this.externalId,
    required this.name,
    required this.servingSize,
    required this.servingSizeUnit,
    this.servingsPerContainer,
    this.quantity,
  });

  /// Deserialize json to Portion object.
  factory Portion.fromJson(Map<String, dynamic> json) =>
      _$PortionFromJson(json);

  /// Serialize Portion object to json.
  Map<String, dynamic> toJson() => _$PortionToJson(this);

  /// External ID (UUID).
  final String externalId;

  /// Portion name.
  final String name;

  /// Portion servingSize.
  final double servingSize;

  /// Portion servingSizeUnit.
  final String servingSizeUnit;

  /// Portion servings per container.
  final double? servingsPerContainer;

  /// Portion quantity.
  final double? quantity;

  /// Custom comparing function to check if two UserIngredientDisplays
  /// are equal. Required by dropdown_search package.
  bool isEqual(Portion model) {
    return externalId == model.externalId;
  }

  @override
  String toString() => name;

  @override
  List<Object?> get props => [
        externalId,
        name,
        servingSize,
        servingSizeUnit,
        servingsPerContainer,
        quantity
      ];
}
