import 'package:flutter/material.dart';

import '../theme/wind_theme.dart';
import 'screens_parser.dart';

/// Parses the border from a class name
/// Example: border-2 or border[4]
/// Example: border-red-500 or border-[#ff0000]
/// Example: rounded-lg or rounded-[12]
class BorderParser {
  static final RegExp roundedRegExp =
      RegExp(r'^(?:[a-zA-Z0-9]+:)?rounded-?(?<size>[a-zA-Z0-9]*)$');
  static final RegExp roundedRegExpDynamic =
      RegExp(r'^(?:[a-zA-Z0-9]+:)?rounded-\[(?<size>[0-9]+)\]$');

  static final RegExp widthRegExp =
      RegExp(r'^(?:[a-zA-Z0-9]+:)?border-?(?<size>[0-9]*)$');
  static final RegExp widthRegExpDynamic =
      RegExp(r'^(?:[a-zA-Z0-9]+:)?border-\[(?<size>[0-9]+)\]$');

  static final RegExp colorRegExp = RegExp(
      r'^(?:[a-zA-Z0-9]+:)?border-(?<color>[a-zA-Z0-9]+)-?(?<shade>[0-9]{0,3})$');
  static final RegExp colorRegExpDynamic = RegExp(
      r'^(?:[a-zA-Z0-9]+:)?border-\[#(?<code>[a-zA-Z0-9]+)\]$');

  static ShapeBorder? applyBorder(BuildContext context, String className) {
    OutlinedBorder? border;
    double? borderWidth;
    Color? borderColor;

    for (var name in className.split(' ')) {
      final matchRounded = roundedRegExp.firstMatch(name);
      if (matchRounded != null && ScreensParser.canApply(context, name)) {
        final size = matchRounded.namedGroup('size')!;
        final radius = calculateRadius(context, size);
        border = RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        );
      } else {
        final matchRounded = roundedRegExpDynamic.firstMatch(name);
        if (matchRounded != null && ScreensParser.canApply(context, name)) {
          String size = matchRounded.namedGroup('size')!;

          if (double.tryParse(size) != null) {
            final radius = double.parse(size);
            border = RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            );
          }
        }
      }

      final matchWidth = widthRegExp.firstMatch(name);
      if (matchWidth != null && ScreensParser.canApply(context, name)) {
        final size = matchWidth.namedGroup('size')!.isEmpty
            ? '1'
            : matchWidth.namedGroup('size')!;
        borderWidth = double.parse(size);
      } else {
        final matchWidth = widthRegExpDynamic.firstMatch(name);
        if (matchWidth != null && ScreensParser.canApply(context, name)) {
          String size = matchWidth.namedGroup('size')!;

          if (double.tryParse(size) != null) {
            borderWidth = double.parse(size);
          }
        }
      }

      final matchColor = colorRegExp.firstMatch(name);
      if (matchColor != null && ScreensParser.canApply(context, name)) {
        String colorName = matchColor.namedGroup('color')!;
        if (WindTheme.isValidColor(colorName)) {
          borderColor = WindTheme.getColor(colorName,
              shade: matchColor.namedGroup('shade')!.isNotEmpty
                  ? int.parse(matchColor.namedGroup('shade')!)
                  : 500);
        }
      } else {
        final matchColor = colorRegExpDynamic.firstMatch(name);
        if (matchColor != null && ScreensParser.canApply(context, name)) {
          borderColor = WindTheme.hexToColor('#' + matchColor.namedGroup('code')!);
        }
      }
    }

    if (border == null && (borderWidth != null || borderColor != null)) {
      border = RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      );
    }

    if (border != null) {
      if (borderWidth != null) {
        return border.copyWith(
          side: BorderSide(
            color: borderColor ?? Colors.transparent,
            width: borderWidth,
          ),
        );
      }
    }

    return border;
  }

  static BorderRadiusGeometry? applyBorderRadiusGeometry(BuildContext context, String className) {
    double? radius;

    for (var name in className.split(' ')) {
      final matchRounded = roundedRegExp.firstMatch(name);
      if (matchRounded != null && ScreensParser.canApply(context, name)) {
        final size = matchRounded.namedGroup('size')!;
        radius = calculateRadius(context, size);
      } else {
        final matchRounded = roundedRegExpDynamic.firstMatch(name);
        if (matchRounded != null && ScreensParser.canApply(context, name)) {
          String size = matchRounded.namedGroup('size')!;

          if (double.tryParse(size) != null) {
            radius = double.parse(size);
          }
        }
      }
    }

    if (radius != null) {
      return BorderRadius.circular(radius);
    }

    return null;
  }

  static BorderRadius? applyBorderRadius(BuildContext context, String className) {
    double? radius;

    for (var name in className.split(' ')) {
      final matchRounded = roundedRegExp.firstMatch(name);
      if (matchRounded != null && ScreensParser.canApply(context, name)) {
        final size = matchRounded.namedGroup('size')!;
        radius = calculateRadius(context, size);
      } else {
        final matchRounded = roundedRegExpDynamic.firstMatch(name);
        if (matchRounded != null && ScreensParser.canApply(context, name)) {
          String size = matchRounded.namedGroup('size')!;

          if (double.tryParse(size) != null) {
            radius = double.parse(size);
          }
        }
      }
    }

    if (radius != null) {
      return BorderRadius.circular(radius);
    }

    return null;
  }

  static BoxBorder? applyBoxBorder(BuildContext context, String className) {
    BoxBorder? border;
    double? borderWidth;
    Color? borderColor;

    for (var name in className.split(' ')) {
      final matchWidth = widthRegExp.firstMatch(name);
      if (matchWidth != null && ScreensParser.canApply(context, name)) {
        final size = matchWidth.namedGroup('size')!.isEmpty
            ? '1'
            : matchWidth.namedGroup('size')!;
        borderWidth = double.parse(size);
      } else {
        final matchWidth = widthRegExpDynamic.firstMatch(name);
        if (matchWidth != null && ScreensParser.canApply(context, name)) {
          String size = matchWidth.namedGroup('size')!;

          if (double.tryParse(size) != null) {
            borderWidth = double.parse(size);
          }
        }
      }

      final matchColor = colorRegExp.firstMatch(name);
      if (matchColor != null && ScreensParser.canApply(context, name)) {
        String colorName = matchColor.namedGroup('color')!;
        if (WindTheme.isValidColor(colorName)) {
          borderColor = WindTheme.getColor(colorName,
              shade: matchColor.namedGroup('shade')!.isNotEmpty
                  ? int.parse(matchColor.namedGroup('shade')!)
                  : 500);
        }
      } else {
        final matchColor = colorRegExpDynamic.firstMatch(name);
        if (matchColor != null && ScreensParser.canApply(context, name)) {
          borderColor = WindTheme.hexToColor('#' + matchColor.namedGroup('code')!);
        }
      }
    }

    if (borderWidth != null || borderColor != null) {
      border = Border.all(
        color: borderColor ?? Colors.transparent,
        width: borderWidth ?? 1,
      );
    }

    return border;
  }

  static BorderSide? applyBorderSide(BuildContext context, String className) {
    double? borderWidth;
    Color? borderColor;

    for (var name in className.split(' ')) {
      final matchWidth = widthRegExp.firstMatch(name);
      if (matchWidth != null && ScreensParser.canApply(context, name)) {
        final size = matchWidth.namedGroup('size')!.isEmpty
            ? '1'
            : matchWidth.namedGroup('size')!;
        borderWidth = double.parse(size);
      } else {
        final matchWidth = widthRegExpDynamic.firstMatch(name);
        if (matchWidth != null && ScreensParser.canApply(context, name)) {
          String size = matchWidth.namedGroup('size')!;

          if (double.tryParse(size) != null) {
            borderWidth = double.parse(size);
          }
        }
      }

      final matchColor = colorRegExp.firstMatch(name);
      if (matchColor != null && ScreensParser.canApply(context, name)) {
        String colorName = matchColor.namedGroup('color')!;
        if (WindTheme.isValidColor(colorName)) {
          borderColor = WindTheme.getColor(colorName,
              shade: matchColor.namedGroup('shade')!.isNotEmpty
                  ? int.parse(matchColor.namedGroup('shade')!)
                  : 500);
        }
      } else {
        final matchColor = colorRegExpDynamic.firstMatch(name);
        if (matchColor != null && ScreensParser.canApply(context, name)) {
          borderColor = WindTheme.hexToColor('#' + matchColor.namedGroup('code')!);
        }
      }
    }

    if (borderWidth != null || borderColor != null) {
      return BorderSide(
        color: borderColor ?? Colors.transparent,
        width: borderWidth ?? 1,
      );
    }

    return null;
  }

  static InputBorder? applyInputBorder(BuildContext context, String className) {
    InputBorder? border;

    final borderRadius = BorderParser.applyBorderRadius(context, className);
    final borderSide = BorderParser.applyBorderSide(context, className);

    if (borderRadius != null && borderSide != null) {
      border = OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: borderSide,
      );
    }

    return border;
  }

  static double calculateRadius(BuildContext context, String size) {
    if (WindTheme.hasRoundedSize(size)) {
      return WindTheme.getRoundedSize(size) * WindTheme.getRemFactor();
    }

    return 0;
  }
}
