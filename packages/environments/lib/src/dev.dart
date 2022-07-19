import 'package:environments/src/base.dart';

/// Environment config for DEV.
class DevConfig implements BaseConfig {
  @override
  String get apiHost => '192.168.1.3';

  @override
  String get apiUriScheme => 'http';

  @override
  int? get apiPort => 8000;

  @override
  bool? get debugPrint => true;
}
