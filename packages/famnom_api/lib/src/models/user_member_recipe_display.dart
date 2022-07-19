import 'package:equatable/equatable.dart';
import 'package:famnom_api/famnom_api.dart';
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
    required this.displayRecipe,
    this.displayPortion,
    this.recipePortionExternalId,
    this.displayMeal,
  });

  /// Deserialize json to UserMemberRecipeDisplay object.
  factory UserMemberRecipeDisplay.fromJson(Map<String, dynamic> json) =>
      _$UserMemberRecipeDisplayFromJson(json);

  /// Serialize UserMemberRecipeDisplay object to json.
  Map<String, dynamic> toJson() => _$UserMemberRecipeDisplayToJson(this);

  /// External ID (UUID).
  final String externalId;

  /// Display recipe.
  final UserRecipeDisplay displayRecipe;

  /// Display portion.
  final Portion? displayPortion;

  /// Ingredient portion ID.
  final String? recipePortionExternalId;

  /// Parent Meal display.
  final UserMealDisplay? displayMeal;

  @override
  List<Object?> get props => [
        externalId,
        displayRecipe,
        displayPortion,
        recipePortionExternalId,
        displayMeal
      ];
}
