import 'dart:io';

class EnvConfig {
  static const String ENV = 'development';

  static final String API_URL =
      '${Platform.isAndroid ? 'http://192.168.8.101:4000' : 'http://localhost'}';
}
