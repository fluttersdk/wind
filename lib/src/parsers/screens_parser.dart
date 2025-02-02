import 'package:flutter/material.dart';

import '../theme/wind_theme.dart';

/// Parses screen classes and returns boolean
/// Example: sm:w-full, md:w-full, lg:w-full, xl:w-full
class ScreensParser {
  static bool canApply(BuildContext context, String className) {
    List<String> split = className.split(':');
    if (split.length > 1 && WindTheme.hasScreen(split[0])) {

      final Size deviceSize = MediaQuery.of(context).size;
      final int max = WindTheme.getScreenValue(split[0]);
      final int min = WindTheme.getSmallestScreen(split[0]);

      if (deviceSize.width > min && deviceSize.width <= max) {
        return true;
      }

      return false;
    }

    return true;
  }

  static String without(String className) {
    List<String> split = className.split(':');
    if (split.length > 1 && WindTheme.hasScreen(split[0])) {
      return split[1];
    }

    return className;
  }
}