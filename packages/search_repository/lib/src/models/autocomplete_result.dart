import 'package:flutter/material.dart';

/// {@template autocomplete_result}
/// AutocompleteResult model
/// {@endtemplate}
@immutable
class AutocompleteResult {
  /// {@macro autocomplete_result}
  const AutocompleteResult({
    required this.query,
    required this.timestamp,
  });

  /// Deseralize json to [AutocompleteResult] object.
  AutocompleteResult.fromJson(Map<String, dynamic> json)
      : query = json['query'] as String,
        timestamp = json['timestamp'] as int;

  /// [AutocompleteResult] query.
  final String query;

  /// [AutocompleteResult] timestamp, when the suggestion was made by the user.
  final int timestamp;

  @override
  String toString() {
    return query;
  }

  /// Seralize [AutocompleteResult] object to json.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'query': query,
        'timestamp': timestamp,
      };

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is AutocompleteResult &&
        other.query == query &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode => query.hashCode;
}
