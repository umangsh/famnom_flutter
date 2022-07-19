import 'package:app_repository/app_repository.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
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
  final String name;

  /// Display formatted name. Used for selection widgets on mealplanner.
  String get displayName {
    return name;
  }

  /// Display brand information.
  final Brand? brand;

  /// List of portions.
  final List<Portion>? portions;

  /// Get default portion.
  Portion? get defaultPortion {
    if (membership != null && membership!.ingredientPortionExternalId != null) {
      return portions?.firstWhereOrNull(
        (element) =>
            element.externalId == membership!.ingredientPortionExternalId,
      );
    }
    return portions?[0];
  }

  /// Get default quantity.
  double? get defaultQuantity {
    return membership?.portion?.quantity;
  }

  /// List of nutrients.
  final Nutrients? nutrients;

  /// Membership details. Present for parent meals and recipes.
  final UserMemberIngredientDisplay? membership;

  /// Category.
  final String? category;

  /// Empty UserIngredientDisplay.
  static const empty = UserIngredientDisplay(
    externalId: '',
    name: '',
    portions: [],
    nutrients: Nutrients(servingSize: 0, servingSizeUnit: 'g', values: {}),
  );

  /// Convenience getter to determine whether the current
  /// UserIngredientDisplay is empty.
  bool get isEmpty => this == UserIngredientDisplay.empty;

  /// Convenience getter to determine whether the current
  /// UserIngredientDisplay is not empty.
  bool get isNotEmpty => this != UserIngredientDisplay.empty;

  /// Custom comparing function to check if two UserIngredientDisplays
  /// are equal. Required by dropdown_search package.
  bool isEqual(UserIngredientDisplay model) {
    return externalId == model.externalId;
  }

  @override
  String toString() => name;

  @override
  List<Object?> get props =>
      [externalId, name, brand, portions, nutrients, category, membership];
}
