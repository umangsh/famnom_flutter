import 'package:equatable/equatable.dart';
import 'package:famnom_api/famnom_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fda_rdi_response.g.dart';

/// {@template FdaRdiResponse}
/// FdaRdiResponse model
/// {@endtemplate}
@JsonSerializable()
class FdaRdiResponse extends Equatable {
  /// {@macro FdaRdiResponse}
  const FdaRdiResponse({
    required this.results,
  });

  /// Deserialize json to FdaRdiResponse object.
  factory FdaRdiResponse.fromJson(Map<String, dynamic> json) =>
      _$FdaRdiResponseFromJson(json);

  /// Serialize FdaRdiResponse object to json.
  Map<String, dynamic> toJson() => _$FdaRdiResponseToJson(this);

  /// FDA RDIs for all FDA age groups.
  final Map<FDAGroup, Map<String, FdaRdi>> results;

  @override
  List<Object?> get props => [results];
}
