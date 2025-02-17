import 'package:flutter/material.dart';

import '../theme/wind_theme.dart';
import 'screens_parser.dart';

/// Parses the font size from a class name
/// Example: text-2xl or text-[12]
/// Example: text-lg/6 or text-[12]/6
class FontSizeParser {
  static final RegExp regExp = RegExp(
      r'^(?:[a-zA-Z0-9]+:)?text-(?<size>[a-zA-Z0-9]+)(?:\/(?<line>[a-zA-Z0-9]+))?$');

  static final RegExp regExpDynamic = RegExp(
      r'^(?:[a-zA-Z0-9]+:)?text-\[(?<size>[0-9]+)\](?:\/(?<line>[a-zA-Z0-9]+))?$');

  static double? toFontSize(String className) {
    double? fontSize;

    for (var name in className.split(' ')) {
      final match = regExp.firstMatch(name);
      if (match != null) {
        String size = match.namedGroup('size')!;

        if (WindTheme.hasFontSize(size)) {
          fontSize = WindTheme.getFontSize(size) * WindTheme.getRemFactor();
        }
      } else {
        final match = regExpDynamic.firstMatch(name);
        if (match != null) {
          String size = match.namedGroup('size')!;

          if (double.tryParse(size) != null) {
            fontSize = double.parse(size);
          }
        }
      }
    }

    return fontSize;
  }

  static double? applyFontSize(BuildContext context, String className) {
    double? fontSize;

    for (var name in className.split(' ')) {
      final match = regExp.firstMatch(name);
      if (match != null) {
        String size = match.namedGroup('size')!;

        if (WindTheme.hasFontSize(size) &&
            ScreensParser.canApply(context, name)) {
          fontSize = WindTheme.getFontSize(size) * WindTheme.getRemFactor();
        }
      } else {
        final match = regExpDynamic.firstMatch(name);
        if (match != null) {
          String size = match.namedGroup('size')!;

          if (double.tryParse(size) != null &&
              ScreensParser.canApply(context, name)) {
            fontSize = double.parse(size);
          }
        }
      }
    }

    return fontSize;
  }

  static double? toLineHeight(String className) {
    double? height;

    for (var name in className.split(' ')) {
      final match = regExp.firstMatch(name);
      if (match != null && WindTheme.hasLineHeight(match.namedGroup('line')!)) {
        height = WindTheme.getLineHeight(match.namedGroup('line')!);
      } else {
        final match = regExpDynamic.firstMatch(name);
        if (match != null) {
          String size = match.namedGroup('line')!;

          if (double.tryParse(size) != null) {
            height = double.parse(size);
          }
        }
      }
    }

    return height;
  }

  static double? applyLineHeight(BuildContext context, String className) {
    double? height;

    for (var name in className.split(' ')) {
      final match = regExp.firstMatch(name);
      if (match != null &&
          match.namedGroup('line') != null &&
          WindTheme.hasLineHeight(match.namedGroup('line')!) &&
          ScreensParser.canApply(context, name)) {
        height = WindTheme.getLineHeight(match.namedGroup('line')!);
      } else {
        final match = regExpDynamic.firstMatch(name);
        if (match != null &&
            match.namedGroup('line') != null &&
            ScreensParser.canApply(context, name)) {
          String size = match.namedGroup('line')!;

          if (double.tryParse(size) != null) {
            height = double.parse(size);
          }
        }
      }
    }

    return height;
  }
}
