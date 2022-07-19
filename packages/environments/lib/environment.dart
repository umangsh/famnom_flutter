library environments;

import 'package:environments/src/base.dart';
import 'package:environments/src/dev.dart';
import 'package:environments/src/prod.dart';

/// Environment config singleton class.
class Environment {
  /// Init factory.
  factory Environment() {
    return _singleton;
  }

  Environment._internal();

  static final Environment _singleton = Environment._internal();

  /// DEV environment string.
  static const String dev = 'DEV';

  /// PROD environment string.
  static const String prod = 'PROD';

  /// Environment config.
  late BaseConfig config;

  /// Init environment config.
  void initConfig(String environment) {
    config = _getConfig(environment);
  }

  BaseConfig _getConfig(String environment) {
    switch (environment) {
      case Environment.prod:
        return ProdConfig();
      default:
        return DevConfig();
    }
  }
}
