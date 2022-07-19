import 'package:equatable/equatable.dart';
import 'package:famnom_api/famnom_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'my_recipes_response.g.dart';

/// {@template my_recipes_response}
/// MyRecipesResponse model
/// {@endtemplate}
@JsonSerializable()
class MyRecipesResponse extends Equatable {
  /// {@macro my_recipes_response}
  const MyRecipesResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  /// Deserialize json to MyRecipesResponse object.
  factory MyRecipesResponse.fromJson(Map<String, dynamic> json) =>
      _$MyRecipesResponseFromJson(json);

  /// Serialize MyRecipesResponse object to json.
  Map<String, dynamic> toJson() => _$MyRecipesResponseToJson(this);

  /// Total result count for the search query.
  final int count;

  /// Next result page URL.
  final String? next;

  /// Previous result page URL.
  final String? previous;

  /// List of results in the response.
  final List<UserRecipeDisplay> results;

  @override
  List<Object?> get props => [count, next, previous, results];
}
