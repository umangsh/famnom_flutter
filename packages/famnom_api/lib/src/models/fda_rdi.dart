import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fda_rdi.g.dart';

/// FDA RDI threshold, >= min, <= max, == exact value.
enum Threshold {
  /// FDA recommends RDI <= threshold value.
  @JsonValue('1')
  max,

  /// FDA recommends RDI == threshold value.
  @JsonValue('2')
  exact,

  /// FDA recommends RDI >= threshold value.
  @JsonValue('3')
  min
}

/// FDA RDI thresholds user groups.
enum FDAGroup {
  /// Ages >= 4
  @JsonValue('1')
  adult,

  /// Infants through 12 months
  @JsonValue('2')
  infant,

  /// Children 1 through 3 years
  @JsonValue('3')
  children,

  /// Pregnant and lactating women
  @JsonValue('4')
  pregnant,
}

/// {@template FdaRdi}
/// FdaRdi model
/// {@endtemplate}
@JsonSerializable()
class FdaRdi extends Equatable {
  /// {@macro FdaRdi}
  const FdaRdi({
    required this.name,
    this.value,
    this.unit,
    this.threshold,
  });

  /// Deserialize json to FdaRdi object.
  factory FdaRdi.fromJson(Map<String, dynamic> json) => _$FdaRdiFromJson(json);

  /// Serialize FdaRdi object to json.
  Map<String, dynamic> toJson() => _$FdaRdiToJson(this);

  /// Nutrient name.
  final String name;

  /// Nutrinet unit.
  final String? unit;

  /// FDA RDI threshold value.
  final double? value;

  /// FDA RDI threshold type.
  final Threshold? threshold;

  @override
  List<Object?> get props => [name, value, unit, threshold];
}
