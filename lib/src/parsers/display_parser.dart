import 'package:flutter/material.dart';

import 'screens_parser.dart';

/// Parses the display from a class name and returns bool
/// Example: hide, show
class DisplayParser {
  static final RegExp hideRegExp = RegExp(r'^(?:[a-zA-Z0-9]+:)?hide$');
  static final RegExp showRegExp = RegExp(r'^(?:[a-zA-Z0-9]+:)?show$');

  static bool? toDisplay(String className) {
    bool? display;
    for (var name in className.split(' ')) {
      if (hideRegExp.hasMatch(name)) {
        display = false;
      } else if (showRegExp.hasMatch(name)) {
        display = true;
      }
    }
    return display;
  }

  static bool? applyDisplay(BuildContext context, String className) {
    bool? display;
    for (var name in className.split(' ')) {
      if (hideRegExp.hasMatch(name) && ScreensParser.canApply(context, name)) {
        display = false;
      } else if (showRegExp.hasMatch(name) &&
          ScreensParser.canApply(context, name)) {
        display = true;
      }
    }

    return display;
  }

  static bool hide(BuildContext context, String className) {
    return applyDisplay(context, className) == false;
  }
}
