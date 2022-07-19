import 'package:equatable/equatable.dart';
import 'package:famnom_api/famnom_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_meal_mutable.g.dart';

/// {@template user_meal_mutable}
/// UserMealMutable model
/// {@endtemplate}
@JsonSerializable()
class UserMealMutable extends Equatable {
  /// {@macro user_meal_mutable}
  const UserMealMutable({
    required this.externalId,
    required this.mealType,
    required this.mealDate,
    this.memberIngredients,
    this.memberRecipes,
  });

  /// Deserialize json to UserMealMutable object.
  factory UserMealMutable.fromJson(Map<String, dynamic> json) =>
      _$UserMealMutableFromJson(json);

  /// Serialize UserRecipeDisplay object to json.
  Map<String, dynamic> toJson() => _$UserMealMutableToJson(this);

  /// External ID (UUID).
  final String externalId;

  /// Meal type.
  final String mealType;

  /// Meal date.
  final String mealDate;

  /// Member foods.
  final List<UserFoodMembership>? memberIngredients;

  /// Member recipes.
  final List<UserFoodMembership>? memberRecipes;

  @override
  List<Object?> get props => [
        externalId,
        mealType,
        mealDate,
        memberIngredients,
        memberRecipes,
      ];
}
