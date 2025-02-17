import 'package:flutter/material.dart';

import 'screens_parser.dart';

/// Parses the display from a class name and returns bool
/// Example: hidden, show
class DisplayParser {
  static const String _hidden = 'hidden';
  static const String _show = 'show';

  static bool? toDisplay(String className) {
    bool? display;
    for (var name in className.split(' ')) {
      if (name == _hidden) {
        display = false;
      } else if (name == _show) {
        display = true;
      }
    }
    return display;
  }

  static bool? applyDisplay(BuildContext context, String className) {
    bool? display;
    for (var name in className.split(' ')) {
      if (name == _hidden && ScreensParser.canApply(context, name)) {
        display = false;
      } else if (name == _show && ScreensParser.canApply(context, name)) {
        display = true;
      }
    }
    return display;
  }
}