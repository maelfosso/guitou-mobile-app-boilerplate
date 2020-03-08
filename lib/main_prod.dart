
import 'package:flutter/widgets.dart';
import 'package:guitou/app_config.dart';

import 'main.dart';

void main() async {

  // await start();

  var configuredApp = AppConfig(
    apiBaseUrl: 'http://api.guitou.cm/api',
    child: await start(),
  );

  runApp(configuredApp);
}