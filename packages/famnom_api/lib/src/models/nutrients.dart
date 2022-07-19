import 'package:equatable/equatable.dart';
import 'package:famnom_api/famnom_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'nutrients.g.dart';

/// {@template nutrient}
/// Nutrient model
/// {@endtemplate}
@JsonSerializable()
class Nutrient extends Equatable {
  /// {@macro nutrient}
  const Nutrient({
    required this.id,
    required this.name,
    this.amount,
    this.unit,
  });

  /// Deserialize json to Nutrient object.
  factory Nutrient.fromJson(Map<String, dynamic> json) =>
      _$NutrientFromJson(json);

  /// Serialize Nutrient object to json.
  Map<String, dynamic> toJson() => _$NutrientToJson(this);

  /// Nutrient ID.
  final int id;

  /// Nutrient name.
  final String name;

  /// Optional nutrient amount.
  final double? amount;

  /// Nutrient unit name.
  final String? unit;

  @override
  List<Object?> get props => [id, name, amount, unit];
}

/// {@template nutrients}
/// Nutrients model
/// {@endtemplate}
@JsonSerializable()
class Nutrients extends Equatable {
  /// {@macro nutrients}
  const Nutrients({
    this.servingSize,
    this.servingSizeUnit,
    required this.values,
  });

  /// Deserialize json to Nutrients object.
  factory Nutrients.fromJson(Map<String, dynamic> json) =>
      _$NutrientsFromJson(json);

  /// Serialize Nutrients object to json.
  Map<String, dynamic> toJson() => _$NutrientsToJson(this);

  /// Nutrient values are applicable per servingSize.
  final double? servingSize;

  /// Serving size unit.
  final String? servingSizeUnit;

  /// List of Nutrients.
  final List<Nutrient> values;

  @override
  List<Object?> get props => [servingSize, servingSizeUnit, values];
}

/// {@template nutrient_page}
/// NutrientPage model
/// {@endtemplate}
@JsonSerializable()
class NutrientPage extends Equatable {
  /// {@macro nutrient_page}
  const NutrientPage({
    required this.id,
    required this.name,
    this.unit,
    this.description,
    this.wikipediaUrl,
    this.recentLfoods,
    this.topCfoods,
    this.threshold,
    this.amountPerDay,
  });

  /// Deserialize json to NutrientPage object.
  factory NutrientPage.fromJson(Map<String, dynamic> json) =>
      _$NutrientPageFromJson(json);

  /// Serialize NutrientPage object to json.
  Map<String, dynamic> toJson() => _$NutrientPageToJson(this);

  /// Nutrient ID.
  final int id;

  /// Nutrient name.
  final String name;

  /// Nutrient unit name.
  final String? unit;

  /// Nutrient description.
  final String? description;

  /// Wiki URL.
  final String? wikipediaUrl;

  /// Recent foods.
  final List<UserIngredientDisplay>? recentLfoods;

  /// Top db foods.
  final List<DBFood>? topCfoods;

  /// Nutrient threshold.
  final double? threshold;

  /// Nutrient amounts per day.
  final Map<String, double?>? amountPerDay;

  @override
  List<Object?> get props => [
        id,
        name,
        unit,
        description,
        wikipediaUrl,
        recentLfoods,
        topCfoods,
        threshold,
        amountPerDay
      ];
}
