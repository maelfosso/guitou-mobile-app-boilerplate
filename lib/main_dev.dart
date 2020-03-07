
import 'package:flutter/widgets.dart';
import 'package:muitou/app_config.dart';

import 'main.dart';

void main() async {

  // await start();

  var configuredApp = AppConfig(
    apiBaseUrl: 'http://192.168.8.100:3000/api',
    child: await start(),
  );

  runApp(configuredApp);
}