///
///
///
class Config {
  static const String version = 'dev';
  static final Config _instance = Config._internal();

  ///
  ///
  ///
  factory Config() => _instance;

  ///
  ///
  ///
  Config._internal();

  String user = '';
  String password = '';
  int timeout = 5000;
  bool verbose = false;
}
