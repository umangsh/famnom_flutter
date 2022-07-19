import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'db_branded_food.g.dart';

/// {@template db_branded_food}
/// DBBrandedFood model
/// {@endtemplate}
@JsonSerializable()
class DBBrandedFood extends Equatable {
  /// {@macro db_branded_food}
  const DBBrandedFood({
    this.brandOwner,
    this.brandName,
    this.subBrandName,
    this.gtinUpc,
    this.ingredients,
    this.notASignificantSourceOf,
  });

  /// Deserialize json to DBBrandedFood object.
  factory DBBrandedFood.fromJson(Map<String, dynamic> json) =>
      _$DBBrandedFoodFromJson(json);

  /// Serialize DBBrandedFood object to json.
  Map<String, dynamic> toJson() => _$DBBrandedFoodToJson(this);

  /// Brand owner.
  final String? brandOwner;

  /// Brand name.
  final String? brandName;

  /// Sub Brand name.
  final String? subBrandName;

  /// GTIN/UPC.
  final String? gtinUpc;

  /// Ingredients list.
  final String? ingredients;

  /// Not a significant source of.
  final String? notASignificantSourceOf;

  @override
  List<Object?> get props => [
        brandOwner,
        brandName,
        subBrandName,
        gtinUpc,
        ingredients,
        notASignificantSourceOf
      ];
}
