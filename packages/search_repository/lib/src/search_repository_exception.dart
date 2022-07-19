import 'package:famnom_api/famnom_api.dart' as famnom;

/// {@template search_failure}
/// Thrown during the search request if a failure occurs.
/// {@endtemplate}
class SearchFailure implements Exception {
  /// {@macro search_failure}
  const SearchFailure([
    this.message = 'Something went wrong. Please try again later.',
  ]);

  /// Create an exception message from famnom API exception class.
  factory SearchFailure.fromAPIException(famnom.FamnomAPIException e) {
    return SearchFailure(e.toString());
  }

  /// The associated error message.
  final String message;
}
