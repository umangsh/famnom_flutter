import 'package:app_repository/app_repository.dart';
import 'package:equatable/equatable.dart';
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
    required this.name,
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

  /// Food name.
  final String name;

  /// Brand owner.
  final Brand? brand;

  /// List of portions.
  final List<Portion>? portions;

  /// Get Portion mapping to defaultPortionId
  Portion? get defaultPortion {
    return portions?[0];
  }

  /// List of nutrients.
  final Nutrients? nutrients;

  /// LFood external ID (UUID).
  final String? lfoodExternalId;

  /// Empty dbfood.
  static const empty = DBFood(
    externalId: '',
    name: '',
    portions: [],
    nutrients: Nutrients(servingSize: 0, servingSizeUnit: 'g', values: {}),
  );

  /// Convenience getter to determine whether the current dbfood is empty.
  bool get isEmpty => this == DBFood.empty;

  /// Convenience getter to determine whether the current dbfood is not empty.
  bool get isNotEmpty => this != DBFood.empty;

  @override
  List<Object?> get props =>
      [externalId, name, brand, portions, nutrients, lfoodExternalId];
}
