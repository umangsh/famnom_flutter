import 'package:equatable/equatable.dart';
import 'package:famnom_api/famnom_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'label_response.g.dart';

/// {@template LabelResponse}
/// LabelResponse model
/// {@endtemplate}
@JsonSerializable()
class LabelResponse extends Equatable {
  /// {@macro LabelResponse}
  const LabelResponse({
    required this.results,
  });

  /// Deserialize json to LabelResponse object.
  factory LabelResponse.fromJson(Map<String, dynamic> json) =>
      _$LabelResponseFromJson(json);

  /// Serialize LabelResponse object to json.
  Map<String, dynamic> toJson() => _$LabelResponseToJson(this);

  /// Label nutrient metadata.
  final List<Nutrient> results;

  @override
  List<Object?> get props => [results];
}
