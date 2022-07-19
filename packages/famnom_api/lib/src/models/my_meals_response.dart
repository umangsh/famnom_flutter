import 'package:equatable/equatable.dart';
import 'package:famnom_api/famnom_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'my_meals_response.g.dart';

/// {@template my_meals_response}
/// MyMealsResponse model
/// {@endtemplate}
@JsonSerializable()
class MyMealsResponse extends Equatable {
  /// {@macro my_meals_response}
  const MyMealsResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  /// Deserialize json to MyMealsResponse object.
  factory MyMealsResponse.fromJson(Map<String, dynamic> json) =>
      _$MyMealsResponseFromJson(json);

  /// Serialize MyMealsResponse object to json.
  Map<String, dynamic> toJson() => _$MyMealsResponseToJson(this);

  /// Total result count for the search query.
  final int count;

  /// Next result page URL.
  final String? next;

  /// Previous result page URL.
  final String? previous;

  /// List of results in the response.
  final List<UserMealDisplay> results;

  @override
  List<Object?> get props => [count, next, previous, results];
}
