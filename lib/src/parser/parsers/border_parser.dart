import 'package:flutter/material.dart';

import '../../theme/wind_theme_data.dart';
import '../../utils/color_utils.dart';
import '../wind_context.dart';
import '../wind_style.dart';
import 'wind_parser_interface.dart';

/// **Border & Radius Parser**
///
/// Handles `border-*`, `rounded-*`, and `divide-*` (future) classes.
///
/// ### Supported Utility Classes:
/// - **Width:** `border`, `border-2`, `border-t-4`
/// - **Color:** `border-red-500`, `border-[#FF0000]/50`
/// - **Style:** `border-solid`, `border-none`
/// - **Radius:** `rounded`, `rounded-lg`, `rounded-full`, `rounded-tl-md`
///
/// Returns a [WindStyle] with a resolved `BoxDecoration`, specifically `border` and `borderRadius`.
class BorderParser implements WindParserInterface {
  const BorderParser();

  /// Border style map
  static const Map<String, BorderStyle> _borderStyleMap = {
    'border-solid': BorderStyle.solid,
    'border-none': BorderStyle.none,
  };

  /// Regex for border width with direction: border-t-2, border-r-4, etc.
  static final _directionalBorderWidthRegex = RegExp(
    r'^border-(t|r|b|l)(?:-(\d+))?$',
  );

  /// Regex for border color: border-red-500, border-white, border-[#hex]
  static final _borderColorRegex = RegExp(
    r'^border-(?:(?<color>[a-zA-Z]+)(?:-(?<shade>\d{2,3}))?|(?:\[(?<arbitrary>#(?:[0-9a-fA-F]{3}|[0-9a-fA-F]{4}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8}))\]))$',
  );

  /// Regex for directional radius: rounded-t, rounded-tl, etc.
  static final _directionalRadiusRegex = RegExp(
    r'^rounded-(t|r|b|l|tl|tr|bl|br)(?:-(sm|md|lg|xl|2xl|3xl|full|none))?$',
  );

  /// Regex for uniform border width: border-0, border-2
  static final _uniformBorderWidthRegex = RegExp(r'^border-(\d+)$');

  /// Regex for arbitrary border width: border-[3px]
  static final _arbitraryBorderWidthRegex = RegExp(
    r'^border-\[(?<value>[^\]]+)\]$',
  );

  /// Get border width from theme
  double? _getBorderWidth(String className, WindThemeData theme) {
    if (className == 'border') return theme.borderWidths['DEFAULT'];
    if (className.startsWith('border-')) {
      final suffix = className.substring(7);
      if (theme.borderWidths.containsKey(suffix)) {
        return theme.borderWidths[suffix];
      }
    }
    return null;
  }

  /// Get border radius from theme
  double? _getBorderRadius(String className, WindThemeData theme) {
    if (className == 'rounded') return theme.borderRadius['DEFAULT'];
    if (className == 'rounded-none') return theme.borderRadius['none'];
    if (className == 'rounded-full') return theme.borderRadius['full'];
    if (className.startsWith('rounded-')) {
      final suffix = className.substring(8);
      if (theme.borderRadius.containsKey(suffix)) {
        return theme.borderRadius[suffix];
      }
    }
    return null;
  }

  @override
  WindStyle parse(
    WindStyle styles,
    List<String>? classes,
    WindContext context,
  ) {
    if (classes == null || classes.isEmpty) return styles;

    final border = _parseBorder(classes, context.theme);
    final borderRadius = _parseBorderRadius(classes, context.theme);

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
      // Check for opacity syntax first
      final opacityData = parseColorOpacity(className);
      final effectiveClassName = opacityData.colorPart;
      final opacity = opacityData.opacity;

      // Check border style
      if (_borderStyleMap.containsKey(effectiveClassName)) {
        style = _borderStyleMap[effectiveClassName]!;
        continue;
      }

      // Check uniform border width from theme
      final themeWidth = _getBorderWidth(effectiveClassName, theme);
      if (themeWidth != null) {
        width = themeWidth;
        topWidth = rightWidth = bottomWidth = leftWidth = null;
        continue;
      }

      // Check uniform border width (numeric regex)
      final uniformMatch = _uniformBorderWidthRegex.firstMatch(
        effectiveClassName,
      );
      if (uniformMatch != null) {
        width = double.parse(uniformMatch.group(1)!);
        topWidth = rightWidth = bottomWidth = leftWidth = null;
        continue;
      }

      // Check arbitrary border width
      final arbMatch = _arbitraryBorderWidthRegex.firstMatch(
        effectiveClassName,
      );
      if (arbMatch != null) {
        final val = arbMatch.namedGroup('value')!;
        // Ensure it's not a color (doesn't start with # and usually contains px/rem or is number)
        if (!val.startsWith('#')) {
          width = double.tryParse(val.replaceAll('px', '')) ?? 0.0;
          topWidth = rightWidth = bottomWidth = leftWidth = null;
          continue;
        }
      }

      // Check directional border width
      final dirMatch = _directionalBorderWidthRegex.firstMatch(
        effectiveClassName,
      );
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
        // Reset uniform width when directional is set
        width = null;
        continue;
      }

      // Check border color
      final colorMatch = _borderColorRegex.firstMatch(effectiveClassName);
      if (colorMatch != null) {
        Color? parsedColor;
        if (colorMatch.namedGroup('arbitrary') != null) {
          parsedColor = hexToColor(colorMatch.namedGroup('arbitrary')!);
        } else {
          final colorName = colorMatch.namedGroup('color');
          final shadeStr = colorMatch.namedGroup('shade');
          if (colorName != null) {
            // Use shade if provided, otherwise default to 500 (or handle white/black)
            final shade = shadeStr != null ? int.parse(shadeStr) : 500;
            if (theme.isValidColor(colorName, shade: shade)) {
              parsedColor = theme.getColor(colorName, shade);
            }
          }
        }

        if (parsedColor != null) {
          if (opacity != null) {
            parsedColor = applyOpacity(parsedColor, opacity);
          }
          color = parsedColor;
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

    // Uniform border - including border-0 case (width == 0)
    if (width != null) {
      return Border.all(width: width, color: defaultColor, style: style);
    }

    // Only color was specified, use default width
    if (color != null) {
      return Border.all(width: 1.0, color: color, style: style);
    }

    return null;
  }

  /// Parse border radius from classes
  BorderRadius? _parseBorderRadius(List<String> classes, WindThemeData theme) {
    double? uniformRadius;
    double? topLeft, topRight, bottomLeft, bottomRight;

    for (final className in classes) {
      // Check uniform radius from theme
      final themeRadius = _getBorderRadius(className, theme);
      if (themeRadius != null) {
        uniformRadius = themeRadius;
        topLeft = topRight = bottomLeft = bottomRight = null;
        continue;
      }

      // Check directional radius
      final match = _directionalRadiusRegex.firstMatch(className);
      if (match != null) {
        final direction = match.group(1);
        final sizeStr = match.group(2);
        final radius = sizeStr != null
            ? theme.borderRadius[sizeStr] ??
                theme.borderRadius['DEFAULT'] ??
                4.0
            : theme.borderRadius['DEFAULT'] ?? 4.0;

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
        // Reset uniform radius when directional is set
        uniformRadius = null;
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
