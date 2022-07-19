import 'package:equatable/equatable.dart';
import 'package:famnom_api/famnom_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tracker_response.g.dart';

/// {@template tracker_response}
/// TrackerResponse model
/// {@endtemplate}
@JsonSerializable()
class TrackerResponse extends Equatable {
  /// {@macro tracker_response}
  const TrackerResponse({
    required this.meals,
    required this.nutrients,
  });

  /// Deserialize json to TrackerResponse object.
  factory TrackerResponse.fromJson(Map<String, dynamic> json) =>
      _$TrackerResponseFromJson(json);

  /// Serialize TrackerResponse object to json.
  Map<String, dynamic> toJson() => _$TrackerResponseToJson(this);

  /// List of meals.
  @JsonKey(name: 'display_meals')
  final List<UserMealDisplay> meals;

  /// List of nutrients.
  @JsonKey(name: 'display_nutrients')
  final Nutrients nutrients;

  @override
  List<Object?> get props => [meals, nutrients];
}
