import 'package:app_repository/app_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_member_ingredient_display.g.dart';

/// {@template user_member_ingredient_display}
/// UserMemberIngredientDisplay model
/// {@endtemplate}
@JsonSerializable()
class UserMemberIngredientDisplay extends Equatable {
  /// {@macro user_member_ingredient_display}
  const UserMemberIngredientDisplay({
    required this.externalId,
    required this.ingredient,
    this.portion,
    this.ingredientPortionExternalId,
    this.meal,
  });

  /// Deserialize json to UserMemberIngredientDisplay object.
  factory UserMemberIngredientDisplay.fromJson(Map<String, dynamic> json) =>
      _$UserMemberIngredientDisplayFromJson(json);

  /// Serialize UserMemberIngredientDisplay object to json.
  Map<String, dynamic> toJson() => _$UserMemberIngredientDisplayToJson(this);

  /// External ID (UUID).
  final String externalId;

  /// Display ingredient.
  final UserIngredientDisplay ingredient;

  /// Display portion.
  final Portion? portion;

  /// Ingredient portion ID.
  final String? ingredientPortionExternalId;

  /// Parent Meal display.
  final UserMealDisplay? meal;

  @override
  List<Object?> get props =>
      [externalId, ingredient, portion, ingredientPortionExternalId, meal];
}
