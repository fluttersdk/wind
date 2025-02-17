import 'package:flutter/material.dart';

import '../theme/wind_theme.dart';
import 'screens_parser.dart';

/// Parses shadow classes and returns double
/// Example: shadow-sm, shadow-md, shadow-lg, shadow-xl
/// Example: shadow-[4], shadow-[8], shadow-[12], shadow-[16]
class ShadowParser {
  static final RegExp _shadowRegExp =
      RegExp(r'^(?:[a-zA-Z0-9]+:)?shadow-?(?<size>[a-zA-Z0-9]*)$');
  static final RegExp _shadowRegExpDynamic =
      RegExp(r'^(?:[a-zA-Z0-9]+:)?shadow-?(?<size>\[[a-zA-Z0-9]*\])$');

  static double? applyElevation(BuildContext context, String className) {
    double? elevation;

    for (var name in className.split(' ')) {
      final match = _shadowRegExp.firstMatch(name);
      if (match != null && ScreensParser.canApply(context, name)) {
        final size = match.namedGroup('size')!.length > 0
            ? match.namedGroup('size')!
            : 'default';
        if (WindTheme.hasShadowSize(size)) {
          elevation = WindTheme.getShadowSize(size);
        }
      } else {
        final match = _shadowRegExpDynamic.firstMatch(name);
        if (match != null && ScreensParser.canApply(context, name)) {
          final size = match.namedGroup('size')!;
          if (double.tryParse(size) != null) {
            elevation = double.parse(size);
          }
        }
      }
    }

    return elevation;
  }

  static BoxShadow? applyBoxShadow(BuildContext context, String className) {
    final elevation = applyElevation(context, className);
    if (elevation != null) {
      return BoxShadow(
        color: Colors.black.withValues(alpha: 25),
        blurRadius: elevation,
        spreadRadius: 0,
        offset: Offset(0, elevation / 2),
      );
    }
    return null;
  }

  static List<BoxShadow>? applyBoxShadows(
      BuildContext context, String className) {
    final elevation = applyElevation(context, className);
    if (elevation != null) {
      return [
        BoxShadow(
          color: Colors.black.withValues(alpha: 25),
          blurRadius: elevation,
          spreadRadius: 0,
          offset: Offset(0, elevation / 2),
        )
      ];
    }
    return null;
  }
}
