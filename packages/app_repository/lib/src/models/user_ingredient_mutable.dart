import 'package:app_repository/app_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_ingredient_mutable.g.dart';

/// {@template user_ingredient_mutable}
/// UserIngredientMutable model
/// {@endtemplate}
@JsonSerializable()
class UserIngredientMutable extends Equatable {
  /// {@macro user_ingredient_mutable}
  const UserIngredientMutable({
    required this.externalId,
    required this.name,
    this.brand,
    this.portions,
    required this.nutrients,
    this.category,
  });

  /// Deserialize json to UserIngredientMutable object.
  factory UserIngredientMutable.fromJson(Map<String, dynamic> json) =>
      _$UserIngredientMutableFromJson(json);

  /// Serialize UserIngredientMutable object to json.
  Map<String, dynamic> toJson() => _$UserIngredientMutableToJson(this);

  /// External ID (UUID).
  final String externalId;

  /// Name.
  final String name;

  /// Display brand information.
  final Brand? brand;

  /// List of portions.
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

  /// List of nutrients.
  final Nutrients nutrients;

  /// Category.
  final String? category;

  /// Empty UserIngredientMutable.
  static const empty = UserIngredientMutable(
    externalId: '',
    name: '',
    nutrients: Nutrients(servingSize: 0, servingSizeUnit: 'g', values: {}),
  );

  /// Convenience getter to determine whether the current
  /// UserIngredientMutable is empty.
  bool get isEmpty => this == UserIngredientMutable.empty;

  /// Convenience getter to determine whether the current
  /// UserIngredientMutable is not empty.
  bool get isNotEmpty => this != UserIngredientMutable.empty;

  @override
  List<Object?> get props => [
        externalId,
        name,
        brand,
        portions,
        nutrients,
        category,
      ];
}
