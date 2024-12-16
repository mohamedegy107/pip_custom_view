import 'package:flutter/widgets.dart';

/// Service to handle PIP view navigation
class PIPNavigationService {
  static final PIPNavigationService _instance =
      PIPNavigationService._internal();
  factory PIPNavigationService() => _instance;
  PIPNavigationService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<bool> maybePop() async {
    final NavigatorState? navigator = navigatorKey.currentState;
    if (navigator == null) return false;
    return await navigator.maybePop();
  }
}
