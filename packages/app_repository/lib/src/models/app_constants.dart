import 'package:app_repository/app_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_constants.g.dart';

/// {@template AppConstants}
/// AppConstants model
/// {@endtemplate}
@JsonSerializable()
class AppConstants extends Equatable {
  /// {@macro AppConstants}
  const AppConstants({
    this.fdaRdis,
    this.labelNutrients,
    this.categories,
    this.householdQuantities,
    this.householdUnits,
    this.servingSizeUnits,
  });

  /// Deserialize json to AppConstants object.
  factory AppConstants.fromJson(Map<String, dynamic> json) =>
      _$AppConstantsFromJson(json);

  /// Serialize AppConstants object to json.
  Map<String, dynamic> toJson() => _$AppConstantsToJson(this);

  /// FDA RDIs for all FDA age groups.
  final Map<FDAGroup, Map<int, FdaRdi>>? fdaRdis;

  /// Label nutrient metadata.
  final Map<int, Nutrient>? labelNutrients;

  /// Category data.
  final List<Map<String, String>>? categories;

  /// Household quantity data.
  final List<Map<String, String>>? householdQuantities;

  /// Household unit data.
  final List<Map<String, String>>? householdUnits;

  /// Serving size unit data.
  final List<Map<String, String>>? servingSizeUnits;

  @override
  List<Object?> get props => [
        fdaRdis,
        labelNutrients,
        categories,
        householdQuantities,
        householdUnits,
        servingSizeUnits,
      ];
}
