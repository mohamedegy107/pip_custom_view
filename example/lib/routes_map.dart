import 'package:example/main.dart';
import 'package:flutter/widgets.dart';

class RoutesName {
  static final Map<String, Widget Function(BuildContext)> appRoutes = {
    HomeScreen.id: (context) => HomeScreen(),
    NavigatedScreen.id: (context) => NavigatedScreen(),
  };
}
