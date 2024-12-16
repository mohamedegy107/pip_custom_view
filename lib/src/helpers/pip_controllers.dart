import 'package:flutter/widgets.dart';

/// Interface for controlling PIP view behavior
abstract class PIPController {
  /// Present a widget below the current PIP view
  void presentBelow(Widget widget);

  /// Stop floating mode and return to normal view
  void stopFloating();

  /// Check if PIP view is currently active
  bool get isPIPActive;
}
