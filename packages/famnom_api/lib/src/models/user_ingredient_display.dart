import 'package:equatable/equatable.dart';
import 'package:famnom_api/famnom_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_ingredient_display.g.dart';

/// {@template user_ingredient_display}
/// UserIngredientDisplay model
/// {@endtemplate}
@JsonSerializable()
class UserIngredientDisplay extends Equatable {
  /// {@macro user_ingredient_display}
  const UserIngredientDisplay({
    required this.externalId,
    required this.name,
    this.brand,
    this.portions,
    this.nutrients,
    this.category,
    this.membership,
  });

  /// Deserialize json to UserIngredientDisplay object.
  factory UserIngredientDisplay.fromJson(Map<String, dynamic> json) =>
      _$UserIngredientDisplayFromJson(json);

  /// Serialize UserIngredientDisplay object to json.
  Map<String, dynamic> toJson() => _$UserIngredientDisplayToJson(this);

  /// External ID (UUID).
  final String externalId;

  /// Display name.
  @JsonKey(name: 'display_name')
  final String name;

  /// Display brand information.
  @JsonKey(name: 'display_brand')
  final Brand? brand;

  /// List of portions.
  @JsonKey(name: 'display_portions')
  final List<Portion>? portions;

  /// List of nutrients.
  @JsonKey(name: 'display_nutrients')
  final Nutrients? nutrients;

  /// Category.
  @JsonKey(name: 'display_category')
  final String? category;

  /// Membership details. Present for parent meals and recipes.
  @JsonKey(name: 'display_membership')
  final UserMemberIngredientDisplay? membership;

  @override
  List<Object?> get props =>
      [externalId, name, brand, portions, nutrients, category, membership];
}
