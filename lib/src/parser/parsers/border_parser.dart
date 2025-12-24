import 'package:flutter/material.dart';

import '../../theme/wind_theme_data.dart';
import '../../utils/color_utils.dart';
import '../wind_context.dart';
import '../wind_style.dart';
import 'wind_parser_interface.dart';

/// Parser for border and rounded related classes
///
/// Example classes:
/// - Border width: border, border-0, border-2, border-4, border-8
/// - Directional borders: border-t, border-r, border-b, border-l
/// - Border colors: border-red-500, border-[#FF5733]
/// - Border styles: border-solid, border-dashed, border-dotted
/// - Border radius: rounded, rounded-sm, rounded-md, rounded-lg, rounded-xl, rounded-full
/// - Directional radius: rounded-t, rounded-r, rounded-b, rounded-l
class BorderParser implements WindParserInterface {
  const BorderParser();

  /// Default border width values
  static const Map<String, double> _borderWidthMap = {
    'border': 1.0,
    'border-0': 0.0,
    'border-2': 2.0,
    'border-4': 4.0,
    'border-8': 8.0,
  };

  /// Border radius values (in rem units, 1rem = 4px)
  static const Map<String, double> _borderRadiusMap = {
    'rounded-none': 0.0,
    'rounded-sm': 2.0, // 0.125rem = 2px
    'rounded': 4.0, // 0.25rem = 4px
    'rounded-md': 6.0, // 0.375rem = 6px
    'rounded-lg': 8.0, // 0.5rem = 8px
    'rounded-xl': 12.0, // 0.75rem = 12px
    'rounded-2xl': 16.0, // 1rem = 16px
    'rounded-3xl': 24.0, // 1.5rem = 24px
    'rounded-full': 9999.0, // full circle
  };

  /// Border style map
  static const Map<String, BorderStyle> _borderStyleMap = {
    'border-solid': BorderStyle.solid,
    'border-none': BorderStyle.none,
  };

  /// Regex for border width with direction: border-t-2, border-r-4, etc.
  static final _directionalBorderWidthRegex = RegExp(
    r'^border-(t|r|b|l)(?:-(\d+))?$',
  );

  /// Regex for border color: border-red-500, border-[#hex]
  static final _borderColorRegex = RegExp(
    r'^border-(?:(?<color>[a-zA-Z]+)-(?<shade>\d{2,3})|(?:\[(?<arbitrary>#(?:[0-9a-fA-F]{3}|[0-9a-fA-F]{6}))\]))$',
  );

  /// Regex for directional radius: rounded-t, rounded-tl, etc.
  static final _directionalRadiusRegex = RegExp(
    r'^rounded-(t|r|b|l|tl|tr|bl|br)(?:-(sm|md|lg|xl|2xl|3xl|full))?$',
  );

  @override
  WindStyle parse(
    WindStyle styles,
    List<String>? classes,
    WindContext context,
  ) {
    if (classes == null || classes.isEmpty) return styles;

    final border = _parseBorder(classes, context.theme);
    final borderRadius = _parseBorderRadius(classes);

    if (border == null && borderRadius == null) {
      return styles;
    }

    final decoration = styles.decoration ?? const BoxDecoration();

    return styles.copyWith(
      decoration: decoration.copyWith(
        border: border ?? decoration.border,
        borderRadius: borderRadius ?? decoration.borderRadius,
      ),
    );
  }

  @override
  bool canParse(String className) {
    return className.startsWith('border') || className.startsWith('rounded');
  }

  /// Parse border width, color, and style from classes
  Border? _parseBorder(List<String> classes, WindThemeData theme) {
    double? width;
    Color? color;
    BorderStyle style = BorderStyle.solid;

    // Directional widths
    double? topWidth, rightWidth, bottomWidth, leftWidth;

    // Process classes in order (last wins)
    for (final className in classes) {
      // Check border style
      if (_borderStyleMap.containsKey(className)) {
        style = _borderStyleMap[className]!;
        continue;
      }

      // Check uniform border width
      if (_borderWidthMap.containsKey(className)) {
        width = _borderWidthMap[className];
        // Reset directional when uniform is set
        topWidth = rightWidth = bottomWidth = leftWidth = null;
        continue;
      }

      // Check directional border width
      final dirMatch = _directionalBorderWidthRegex.firstMatch(className);
      if (dirMatch != null) {
        final direction = dirMatch.group(1);
        final widthStr = dirMatch.group(2);
        final dirWidth = widthStr != null ? double.parse(widthStr) : 1.0;

        switch (direction) {
          case 't':
            topWidth = dirWidth;
            break;
          case 'r':
            rightWidth = dirWidth;
            break;
          case 'b':
            bottomWidth = dirWidth;
            break;
          case 'l':
            leftWidth = dirWidth;
            break;
        }
        continue;
      }

      // Check border color
      final colorMatch = _borderColorRegex.firstMatch(className);
      if (colorMatch != null) {
        if (colorMatch.namedGroup('arbitrary') != null) {
          color = hexToColor(colorMatch.namedGroup('arbitrary')!);
        } else {
          final colorName = colorMatch.namedGroup('color');
          final shadeStr = colorMatch.namedGroup('shade');
          if (colorName != null && shadeStr != null) {
            final shade = int.parse(shadeStr);
            if (theme.isValidColor(colorName, shade: shade)) {
              color = theme.getColor(colorName, shade);
            }
          }
        }
        continue;
      }
    }

    // Build border
    final defaultColor = color ?? const Color(0xFFE5E7EB); // gray-200

    // If directional widths are set, use Border with different sides
    if (topWidth != null ||
        rightWidth != null ||
        bottomWidth != null ||
        leftWidth != null) {
      return Border(
        top: topWidth != null && topWidth > 0
            ? BorderSide(width: topWidth, color: defaultColor, style: style)
            : BorderSide.none,
        right: rightWidth != null && rightWidth > 0
            ? BorderSide(width: rightWidth, color: defaultColor, style: style)
            : BorderSide.none,
        bottom: bottomWidth != null && bottomWidth > 0
            ? BorderSide(width: bottomWidth, color: defaultColor, style: style)
            : BorderSide.none,
        left: leftWidth != null && leftWidth > 0
            ? BorderSide(width: leftWidth, color: defaultColor, style: style)
            : BorderSide.none,
      );
    }

    // Uniform border
    if (width != null && width > 0) {
      return Border.all(width: width, color: defaultColor, style: style);
    }

    // Only color was specified, use default width
    if (color != null) {
      return Border.all(width: 1.0, color: color, style: style);
    }

    return null;
  }

  /// Parse border radius from classes
  BorderRadius? _parseBorderRadius(List<String> classes) {
    double? uniformRadius;
    double? topLeft, topRight, bottomLeft, bottomRight;

    for (final className in classes) {
      // Check uniform radius
      if (_borderRadiusMap.containsKey(className)) {
        uniformRadius = _borderRadiusMap[className];
        // Reset directional when uniform is set
        topLeft = topRight = bottomLeft = bottomRight = null;
        continue;
      }

      // Check directional radius
      final match = _directionalRadiusRegex.firstMatch(className);
      if (match != null) {
        final direction = match.group(1);
        final sizeStr = match.group(2);
        final radius = sizeStr != null
            ? _borderRadiusMap['rounded-$sizeStr'] ?? 4.0
            : 4.0;

        switch (direction) {
          case 't':
            topLeft = radius;
            topRight = radius;
            break;
          case 'r':
            topRight = radius;
            bottomRight = radius;
            break;
          case 'b':
            bottomLeft = radius;
            bottomRight = radius;
            break;
          case 'l':
            topLeft = radius;
            bottomLeft = radius;
            break;
          case 'tl':
            topLeft = radius;
            break;
          case 'tr':
            topRight = radius;
            break;
          case 'bl':
            bottomLeft = radius;
            break;
          case 'br':
            bottomRight = radius;
            break;
        }
        continue;
      }
    }

    // If directional radii are set
    if (topLeft != null ||
        topRight != null ||
        bottomLeft != null ||
        bottomRight != null) {
      return BorderRadius.only(
        topLeft: Radius.circular(topLeft ?? 0),
        topRight: Radius.circular(topRight ?? 0),
        bottomLeft: Radius.circular(bottomLeft ?? 0),
        bottomRight: Radius.circular(bottomRight ?? 0),
      );
    }

    // Uniform radius
    if (uniformRadius != null) {
      return BorderRadius.circular(uniformRadius);
    }

    return null;
  }
}
