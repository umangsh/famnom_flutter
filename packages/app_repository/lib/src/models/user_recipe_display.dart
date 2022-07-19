import 'package:app_repository/app_repository.dart';
import 'package:collection/collection.dart';
import 'package:constants/constants.dart' as constants;
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
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

  /// Display formatted date.
  String get displayDate {
    return recipeDate == null
        ? ''
        : DateFormat(constants.DISPLAY_DATE_FORMAT)
            .format(DateTime.parse(recipeDate!));
  }

  /// Display formatted name.
  String get displayName {
    return displayDate.isEmpty ? name : '$name $displayDate';
  }

  /// List of portions.
  @JsonKey(name: 'display_portions')
  final List<Portion>? portions;

  /// Get default portion.
  Portion? get defaultPortion {
    if (membership != null && membership!.recipePortionExternalId != null) {
      return portions?.firstWhereOrNull(
        (element) => element.externalId == membership!.recipePortionExternalId,
      );
    }
    return portions?[0];
  }

  /// Get default quantity.
  double? get defaultQuantity {
    return membership?.portion?.quantity;
  }

  /// List of nutrients.
  @JsonKey(name: 'display_nutrients')
  final Nutrients? nutrients;

  /// List of ingredients.
  final List<UserMemberIngredientDisplay>? memberIngredients;

  /// List of recipes.
  final List<UserMemberRecipeDisplay>? memberRecipes;

  /// Membership details. Present for parent meals and recipes.
  final UserMemberRecipeDisplay? membership;

  /// Empty UserRecipeDisplay.
  static const empty = UserRecipeDisplay(
    externalId: '',
    name: '',
    portions: [],
    nutrients: Nutrients(servingSize: 0, servingSizeUnit: 'g', values: {}),
  );

  /// Convenience getter to determine whether the current
  /// UserRecipeDisplay is empty.
  bool get isEmpty => this == UserRecipeDisplay.empty;

  /// Convenience getter to determine whether the current
  /// UserRecipeDisplay is not empty.
  bool get isNotEmpty => this != UserRecipeDisplay.empty;

  /// Custom comparing function to check if two UserRecipeDisplays
  /// are equal. Required by dropdown_search package.
  bool isEqual(UserRecipeDisplay model) {
    return externalId == model.externalId;
  }

  @override
  String toString() => displayName;

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
