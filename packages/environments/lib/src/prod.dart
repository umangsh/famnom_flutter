import 'package:environments/src/base.dart';

/// Environment config for PROD.
class ProdConfig implements BaseConfig {
  @override
  String get apiHost => 'www.famnom.com';

  @override
  String get apiUriScheme => 'https';

  @override
  int? get apiPort => null;

  @override
  bool? get debugPrint => false;
}
