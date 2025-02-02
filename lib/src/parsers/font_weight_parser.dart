import 'package:flutter/material.dart';

import '../theme/wind_theme.dart';
import 'screens_parser.dart';

/// Parses the font weight from a class name
/// Example: font-bold
class FontWeightParser {
  static final RegExp regExp = RegExp(r'^(?:[a-zA-Z0-9]+:)?font-(?<size>[a-zA-Z0-9]+)$');

  static FontWeight? toFontWeight(String className) {
    FontWeight? fontWeight;

    for (var name in className.split(' ')) {
      final match = regExp.firstMatch(name);
      if (match != null && WindTheme.hasFontWeight(match.namedGroup('size')!)) {
        fontWeight = WindTheme.getFontWeight(match.namedGroup('size')!);
      }
    }

    return fontWeight;
  }

  static FontWeight? applyFontWeight(BuildContext context, String className) {
    FontWeight? fontWeight;

    for (var name in className.split(' ')) {
      final match = regExp.firstMatch(name);
      if (match != null && WindTheme.hasFontWeight(match.namedGroup('size')!) && ScreensParser.canApply(context, name)) {
        fontWeight = WindTheme.getFontWeight(match.namedGroup('size')!);
      }
    }

    return fontWeight;
  }
}