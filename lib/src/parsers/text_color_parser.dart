import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../theme/wind_theme.dart';
import 'screens_parser.dart';

/// Parses text color classes and returns Color
/// Example: text-red-500, text-blue-500, text-green-500
/// Example: text-[#FF0000], text-[#00FF00], text-[#0000FF]
class TextColorParser {
  static final RegExp regExp = RegExp(
      r'^(?:[a-zA-Z0-9]+:)?text-(?<color>[a-zA-Z0-9]+)-?(?<shade>[0-9]{0,3})$');
  static final RegExp regExpDynamic = RegExp(r'^(?:[a-zA-Z0-9]+:)?text-\[#(?<code>[a-zA-Z0-9]+)\]$');

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
      if (match != null &&
          WindTheme.isValidColor(match.namedGroup('color')!) &&
          ScreensParser.canApply(context, name)) {
        color = WindTheme.getColor(match.namedGroup('color')!,
            shade: match.namedGroup('shade')!.isNotEmpty
                ? int.parse(match.namedGroup('shade')!)
                : 500);

        if (hasDebugClassName(className)) {
          print('TextColorParser class name: $name with color: ${match.namedGroup('color')} and shade: ${match.namedGroup('shade')} color: $color');
        }
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
