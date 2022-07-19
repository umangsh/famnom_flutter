import 'package:equatable/equatable.dart';
import 'package:famnom_api/famnom_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'my_foods_response.g.dart';

/// {@template my_foods_response}
/// MyFoodsResponse model
/// {@endtemplate}
@JsonSerializable()
class MyFoodsResponse extends Equatable {
  /// {@macro my_foods_response}
  const MyFoodsResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  /// Deserialize json to MyFoodsResponse object.
  factory MyFoodsResponse.fromJson(Map<String, dynamic> json) =>
      _$MyFoodsResponseFromJson(json);

  /// Serialize MyFoodsResponse object to json.
  Map<String, dynamic> toJson() => _$MyFoodsResponseToJson(this);

  /// Total result count for the search query.
  final int count;

  /// Next result page URL.
  final String? next;

  /// Previous result page URL.
  final String? previous;

  /// List of results in the response.
  final List<UserIngredientDisplay> results;

  @override
  List<Object?> get props => [count, next, previous, results];
}
