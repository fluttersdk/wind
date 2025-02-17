import 'package:flutter/material.dart';

import '../theme/wind_theme.dart';
import '../helpers.dart';

/// Parses screen classes and returns boolean
/// Example: sm:w-full, md:w-full, lg:w-full, xl:w-full
class ScreensParser {
  static bool canApply(BuildContext context, String className) {
    List<String> split = className.split(':');
    if (split.length > 1) {
      final name = split[0];

      if (name == 'dark') {
        return WindTheme.getType() == Brightness.dark;
      }

      if (name == 'light') {
        return WindTheme.getType() == Brightness.light;
      }

      if (WindTheme.hasOperatingSystem(name)) {
        return WindTheme.checkOperatingSystem(name);
      }

      if (WindTheme.hasScreen(name)) {
        return wScreen(context, name);
      }
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