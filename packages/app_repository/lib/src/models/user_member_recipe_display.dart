import 'package:app_repository/app_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_member_recipe_display.g.dart';

/// {@template user_member_recipe_display}
/// UserMemberRecipeDisplay model
/// {@endtemplate}
@JsonSerializable()
class UserMemberRecipeDisplay extends Equatable {
  /// {@macro user_member_recipe_display}
  const UserMemberRecipeDisplay({
    required this.externalId,
    required this.recipe,
    this.portion,
    this.recipePortionExternalId,
    this.meal,
  });

  /// Deserialize json to UserMemberRecipeDisplay object.
  factory UserMemberRecipeDisplay.fromJson(Map<String, dynamic> json) =>
      _$UserMemberRecipeDisplayFromJson(json);

  /// Serialize UserMemberRecipeDisplay object to json.
  Map<String, dynamic> toJson() => _$UserMemberRecipeDisplayToJson(this);

  /// External ID (UUID).
  final String externalId;

  /// Display recipe.
  final UserRecipeDisplay recipe;

  /// Display portion.
  final Portion? portion;

  /// Ingredient portion ID.
  final String? recipePortionExternalId;

  /// Parent Meal display.
  final UserMealDisplay? meal;

  @override
  List<Object?> get props =>
      [externalId, recipe, portion, recipePortionExternalId, meal];
}
