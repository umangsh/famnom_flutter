import 'package:equatable/equatable.dart';
import 'package:famnom_api/famnom_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_meal_display.g.dart';

/// {@template user_meal_display}
/// UserMealDisplay model
/// {@endtemplate}
@JsonSerializable()
class UserMealDisplay extends Equatable {
  /// {@macro user_meal_display}
  const UserMealDisplay({
    required this.externalId,
    required this.mealDate,
    required this.mealType,
    this.nutrients,
    this.memberIngredients,
    this.memberRecipes,
  });

  /// Deserialize json to [UserMealDisplay] object.
  factory UserMealDisplay.fromJson(Map<String, dynamic> json) =>
      _$UserMealDisplayFromJson(json);

  /// Serialize [UserMealDisplay] object to json.
  Map<String, dynamic> toJson() => _$UserMealDisplayToJson(this);

  /// External ID (UUID).
  final String externalId;

  /// Meal date.
  final String mealDate;

  /// Meal type.
  final String mealType;

  /// List of nutrients.
  @JsonKey(name: 'display_nutrients')
  final Nutrients? nutrients;

  /// List of ingredients.
  final List<UserMemberIngredientDisplay>? memberIngredients;

  /// List of recipes.
  final List<UserMemberRecipeDisplay>? memberRecipes;

  @override
  List<Object?> get props => [
        externalId,
        mealDate,
        mealType,
        nutrients,
        memberIngredients,
        memberRecipes
      ];
}
