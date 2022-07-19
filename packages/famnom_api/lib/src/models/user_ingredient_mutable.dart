import 'package:equatable/equatable.dart';
import 'package:famnom_api/famnom_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_ingredient_mutable.g.dart';

/// {@template user_ingredient_mutable}
/// UserIngredientMutable model
/// {@endtemplate}
@JsonSerializable()
class UserIngredientMutable extends Equatable {
  /// {@macro user_ingredient_mutable}
  const UserIngredientMutable({
    required this.externalId,
    required this.name,
    this.brand,
    this.portions,
    required this.nutrients,
    this.category,
  });

  /// Deserialize json to UserIngredientMutable object.
  factory UserIngredientMutable.fromJson(Map<String, dynamic> json) =>
      _$UserIngredientMutableFromJson(json);

  /// Serialize UserIngredientMutable object to json.
  Map<String, dynamic> toJson() => _$UserIngredientMutableToJson(this);

  /// External ID (UUID).
  final String externalId;

  /// Name.
  final String name;

  /// Display brand information.
  final Brand? brand;

  /// List of portions.
  final List<UserFoodPortion>? portions;

  /// List of nutrients.
  final Nutrients nutrients;

  /// Category.
  final String? category;

  @override
  List<Object?> get props => [
        externalId,
        name,
        brand,
        portions,
        nutrients,
        category,
      ];
}
