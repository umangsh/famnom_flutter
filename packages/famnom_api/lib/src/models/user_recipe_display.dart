import 'package:equatable/equatable.dart';
import 'package:famnom_api/famnom_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_recipe_display.g.dart';

/// {@template user_recipe_display}
/// UserRecipeDisplay model
/// {@endtemplate}
@JsonSerializable()
class UserRecipeDisplay extends Equatable {
  /// {@macro user_recipe_display}
  const UserRecipeDisplay({
    required this.externalId,
    required this.name,
    this.recipeDate,
    this.portions,
    this.nutrients,
    this.memberIngredients,
    this.memberRecipes,
    this.membership,
  });

  /// Deserialize json to UserRecipeDisplay object.
  factory UserRecipeDisplay.fromJson(Map<String, dynamic> json) =>
      _$UserRecipeDisplayFromJson(json);

  /// Serialize UserRecipeDisplay object to json.
  Map<String, dynamic> toJson() => _$UserRecipeDisplayToJson(this);

  /// External ID (UUID).
  final String externalId;

  /// Name.
  final String name;

  /// Recipe date.
  final String? recipeDate;

  /// List of portions.
  @JsonKey(name: 'display_portions')
  final List<Portion>? portions;

  /// List of nutrients.
  @JsonKey(name: 'display_nutrients')
  final Nutrients? nutrients;

  /// List of ingredients.
  final List<UserMemberIngredientDisplay>? memberIngredients;

  /// List of recipes.
  final List<UserMemberRecipeDisplay>? memberRecipes;

  /// Membership details. Present for parent meals and recipes.
  @JsonKey(name: 'display_membership')
  final UserMemberRecipeDisplay? membership;

  @override
  List<Object?> get props => [
        externalId,
        name,
        recipeDate,
        portions,
        nutrients,
        memberIngredients,
        memberRecipes,
        membership,
      ];
}
