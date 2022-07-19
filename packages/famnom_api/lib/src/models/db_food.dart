import 'package:equatable/equatable.dart';
import 'package:famnom_api/famnom_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'db_food.g.dart';

/// {@template db_food}
/// DBFood model
/// {@endtemplate}
@JsonSerializable()
class DBFood extends Equatable {
  /// {@macro db_food}
  const DBFood({
    required this.externalId,
    required this.description,
    this.brand,
    this.portions,
    this.nutrients,
    this.lfoodExternalId,
  });

  /// Deserialize json to DBFood object.
  factory DBFood.fromJson(Map<String, dynamic> json) => _$DBFoodFromJson(json);

  /// Serialize DBFood object to json.
  Map<String, dynamic> toJson() => _$DBFoodToJson(this);

  /// External ID (UUID).
  final String externalId;

  /// DBFood description.
  final String description;

  /// DBFood brand information.
  final DBBrandedFood? brand;

  /// List of portions.
  final List<Portion>? portions;

  /// List of nutrients.
  final Nutrients? nutrients;

  /// LFood external ID (UUID).
  final String? lfoodExternalId;

  @override
  List<Object?> get props =>
      [externalId, description, brand, portions, nutrients, lfoodExternalId];
}
