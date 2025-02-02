import 'package:flutter/material.dart';

import '../theme/wind_theme.dart';
import 'screens_parser.dart';

/// Parses the letter spacing from a class name
/// Example: tracking-2 or tracking-[2]
class LetterSpacingParser {
  static final RegExp regExp = RegExp(r'^(?:[a-zA-Z0-9]+:)?tracking-(?<size>[a-zA-Z0-9]+)$');
  static final RegExp regExpDynamic = RegExp(r'^(?:[a-zA-Z0-9]+:)?tracking-\[(?<size>[0-9\.]+)\]$');

  static double? toLetterSpacing(String className) {
    double? letterSpacing;

    for (var name in className.split(' ')) {
      final match = regExp.firstMatch(name);
      if (match != null && WindTheme.hasLetterSpacing(match.namedGroup('size')!)) {
        letterSpacing = WindTheme.getLetterSpacing(match.namedGroup('size')!) * WindTheme.getPixelFactor();
      } else {
        final match = regExpDynamic.firstMatch(name);
        if (match != null) {
          String size = match.namedGroup('size')!;

          if (double.tryParse(size) != null) {
            letterSpacing = double.parse(size);
          }
        }
      }
    }

    return letterSpacing;
  }

  static double? applyLetterSpacing(BuildContext context, String className) {
    double? letterSpacing;

    for (var name in className.split(' ')) {
      final match = regExp.firstMatch(name);
      if (match != null && WindTheme.hasLetterSpacing(match.namedGroup('size')!) && ScreensParser.canApply(context, name)) {
        letterSpacing = WindTheme.getLetterSpacing(match.namedGroup('size')!) * WindTheme.getPixelFactor();
      } else {
        final match = regExpDynamic.firstMatch(name);
        if (match != null && ScreensParser.canApply(context, name)) {
          String size = match.namedGroup('size')!;

          if (double.tryParse(size) != null) {
            letterSpacing = double.parse(size);
          }
        }
      }
    }

    return letterSpacing;
  }
}