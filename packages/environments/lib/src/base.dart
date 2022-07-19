/// Environment BaseConfig
abstract class BaseConfig {
  /// API host for Famnom
  String get apiHost;

  /// URI Scheme for API server.
  /// Dev supports http, while prod supports https
  String get apiUriScheme;

  /// Port for the API server.
  int? get apiPort;

  /// Print debug statements.
  bool? get debugPrint;
}
