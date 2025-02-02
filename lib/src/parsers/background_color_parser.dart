import 'package:flutter/material.dart';

import '../theme/wind_theme.dart';
import 'screens_parser.dart';

/// Parses the background color from a class name
/// Example: bg-red-500 or bg-[#ff0000]
class BackgroundColorParser {
  static final RegExp regExp = RegExp(r'^(?:[a-zA-Z0-9]+:)?bg-(?<color>[a-zA-Z0-9]+)-?(?<shade>[0-9]{0,3})$');
  static final RegExp regExpDynamic = RegExp(r'^(?:[a-zA-Z0-9]+:)?bg-\[#(?<code>[a-zA-Z0-9]+)\]$');

  static Color toColor(String className) {
    Color color = Colors.transparent;
    for (var name in className.split(' ')) {
      final match = regExp.firstMatch(name);
      if (match != null && WindTheme.isValidColor(match.namedGroup('color')!)) {
        color = WindTheme.getColor(match.namedGroup('color')!,
            shade: match.namedGroup('shade')!.isNotEmpty
                ? int.parse(match.namedGroup('shade')!)
                : 500);
      } else {
        final match = regExpDynamic.firstMatch(name);
        if (match != null) {
          color = WindTheme.hexToColor('#' + match.namedGroup('code')!);
        }
      }
    }
    return color;
  }

  static Color? applyColor(BuildContext context, String className) {
    Color? color;

    for (var name in className.split(' ')) {
      final match = regExp.firstMatch(name);
      if (match != null && ScreensParser.canApply(context, name)) {
        color = WindTheme.getColor(match.namedGroup('color')!,
            shade: match.namedGroup('shade')!.isNotEmpty
                ? int.parse(match.namedGroup('shade')!)
                : 500);
      } else {
        final match = regExpDynamic.firstMatch(name);
        if (match != null && ScreensParser.canApply(context, name)) {
          color = WindTheme.hexToColor('#' + match.namedGroup('code')!);
        }
      }
    }

    return color;
  }
}