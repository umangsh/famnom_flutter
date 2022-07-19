import 'package:equatable/equatable.dart';
import 'package:famnom_api/famnom_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_recipe_mutable.g.dart';

/// {@template user_recipe_mutable}
/// UserRecipeMutable model
/// {@endtemplate}
@JsonSerializable()
class UserRecipeMutable extends Equatable {
  /// {@macro user_recipe_mutable}
  const UserRecipeMutable({
    required this.externalId,
    required this.name,
    required this.recipeDate,
    this.portions,
    this.memberIngredients,
    this.memberRecipes,
  });

  /// Deserialize json to UserRecipeMutable object.
  factory UserRecipeMutable.fromJson(Map<String, dynamic> json) =>
      _$UserRecipeMutableFromJson(json);

  /// Serialize UserRecipeMutable object to json.
  Map<String, dynamic> toJson() => _$UserRecipeMutableToJson(this);

  /// External ID (UUID).
  final String externalId;

  /// Name.
  final String name;

  /// Recipe date.
  final String recipeDate;

  /// Portions.
  final List<UserFoodPortion>? portions;

  /// Member foods.
  final List<UserFoodMembership>? memberIngredients;

  /// Member recipes.
  final List<UserFoodMembership>? memberRecipes;

  @override
  List<Object?> get props => [
        externalId,
        name,
        recipeDate,
        portions,
        memberIngredients,
        memberRecipes
      ];
}
