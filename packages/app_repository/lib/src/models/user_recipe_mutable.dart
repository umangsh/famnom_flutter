import 'package:app_repository/app_repository.dart';
import 'package:equatable/equatable.dart';
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

  /// Get default user specified portion.
  UserFoodPortion? get defaultPortion {
    if (portions == null) {
      return null;
    }

    if (portions!.isEmpty) {
      return null;
    }

    return portions?[0];
  }

  /// Member foods.
  final List<UserFoodMembership>? memberIngredients;

  /// Member recipes.
  final List<UserFoodMembership>? memberRecipes;

  /// Empty UserRecipeMutable.
  static const empty =
      UserRecipeMutable(externalId: '', name: '', recipeDate: '');

  /// Convenience getter to determine whether the current
  /// UserRecipeMutable is empty.
  bool get isEmpty => this == UserRecipeMutable.empty;

  /// Convenience getter to determine whether the current
  /// UserRecipeMutable is not empty.
  bool get isNotEmpty => this != UserRecipeMutable.empty;

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
