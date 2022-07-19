import 'package:equatable/equatable.dart';
import 'package:famnom_api/famnom_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_response.g.dart';

/// {@template search_response}
/// SearchResponse model
/// {@endtemplate}
@JsonSerializable()
class SearchResponse extends Equatable {
  /// {@macro search_response}
  const SearchResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  /// Deserialize json to SearchResponse object.
  factory SearchResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseFromJson(json);

  /// Serialize SearchResponse object to json.
  Map<String, dynamic> toJson() => _$SearchResponseToJson(this);

  /// Total result count for the search query.
  final int count;

  /// Next result page URL.
  final String? next;

  /// Previous result page URL.
  final String? previous;

  /// List of results in the response.
  final List<SearchResult> results;

  @override
  List<Object?> get props => [count, next, previous, results];
}
