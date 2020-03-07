
import 'package:flutter/widgets.dart';

class AppConfig extends InheritedWidget {
  final String apiBaseUrl;

  AppConfig({
    @required this.apiBaseUrl,
    @required Widget child
  }) : super(child: child);


  static AppConfig of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfig>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

}