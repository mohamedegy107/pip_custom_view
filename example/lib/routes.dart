import 'package:example/main.dart';
import 'package:flutter/material.dart';

import 'routes_map.dart';

class AppRoutes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    ////
    final arguments = settings.arguments;
    ////
    switch (settings.name) {
      case HomeScreen.id:
        return MaterialPageRoute(
          builder: (context) => HomeScreen(),
        );
      case NavigatedScreen.id:
        return MaterialPageRoute(
          builder: (context) => NavigatedScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('Page not found'),
            ),
          ),
        );
    }
  }

  static PageRouteBuilder pageBuilderRoute(
      {context, Widget child = const Navigator()}) {
    //// SET SYSTEM UI LAYOUT (HIDDEN BOTTOM NVA BAR)
    // ConfigurationStatusBar.systemUiBottomNavBarMode();
    ////
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 600),
      reverseTransitionDuration: const Duration(milliseconds: 600),
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
              Tween(begin: const Offset(1, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOutBack))),
          child: child,
        );
      },
    );
  }
}
