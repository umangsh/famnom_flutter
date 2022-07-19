import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_result.g.dart';

/// {@template search_result}
/// SearchResult model
/// {@endtemplate}
@JsonSerializable()
class SearchResult extends Equatable {
  /// {@macro search_result}
  const SearchResult({
    required this.externalId,
    required this.dname,
    required this.url,
    this.brandName,
    this.brandOwner,
  });

  /// Deserialize json to SearchResult object.
  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);

  /// Serialize SearchResult object to json.
  Map<String, dynamic> toJson() => _$SearchResultToJson(this);

  /// External ID (UUID).
  final String externalId;

  /// Search result name.
  final String dname;

  /// Search result URL.
  final String url;

  /// Brand name.
  final String? brandName;

  /// Brand owner.
  final String? brandOwner;

  @override
  List<Object?> get props => [externalId, dname, url, brandName, brandOwner];
}
