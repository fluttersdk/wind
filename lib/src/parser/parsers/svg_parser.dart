import 'package:flutter/widgets.dart';

import 'wind_parser_interface.dart';
import '../wind_style.dart';
import '../wind_context.dart';
import '../../utils/color_utils.dart';
import '../../theme/wind_theme_data.dart';

/// Parses SVG-specific utility classes.
///
/// ### Supported Classes:
///
/// | Class Pattern | Example | Description |
/// |---------------|---------|-------------|
/// | `fill-{color}` | `fill-red-500` | SVG fill color |
/// | `fill-current` | `fill-current` | Use current text color |
/// | `fill-none` | `fill-none` | No fill |
/// | `stroke-{color}` | `stroke-blue-500` | SVG stroke color |
/// | `stroke-current` | `stroke-current` | Use current text color |
/// | `stroke-none` | `stroke-none` | No stroke |
class SvgParser implements WindParserInterface {
  const SvgParser();

  @override
  bool canParse(String className) {
    if (className.startsWith('fill-')) return true;
    if (className.startsWith('stroke-')) return true;
    return false;
  }

  @override
  WindStyle parse(
    WindStyle styles,
    List<String>? classes,
    WindContext context,
  ) {
    if (classes == null || classes.isEmpty) return styles;

    Color? fillColor;
    Color? strokeColor;
    final theme = context.theme;

    for (final className in classes) {
      // Handle fill classes
      if (className.startsWith('fill-')) {
        final value = className.substring(5); // Remove 'fill-'

        if (value == 'none') {
          fillColor = const Color(0x00000000);
        } else if (value == 'current') {
          // Will use inherited text color - leave as null
        } else {
          fillColor = _parseColor(className, 'fill-', theme);
        }
      }

      // Handle stroke classes
      if (className.startsWith('stroke-')) {
        final value = className.substring(7); // Remove 'stroke-'

        if (value == 'none') {
          strokeColor = const Color(0x00000000);
        } else if (value == 'current') {
          // Will use inherited text color
        } else {
          // Parse as color
          strokeColor = _parseColor(className, 'stroke-', theme);
        }
      }
    }

    return styles.copyWith(fillColor: fillColor, strokeColor: strokeColor);
  }

  /// Parses a color from a className using theme.getColor
  Color? _parseColor(String className, String prefix, WindThemeData theme) {
    final opacityData = parseColorOpacity(className.substring(prefix.length));
    final colorPart = opacityData.colorPart;
    final opacity = opacityData.opacity;

    Color? color;

    // Handle arbitrary color [#RRGGBB]
    if (colorPart.startsWith('[') && colorPart.endsWith(']')) {
      final hex = colorPart.substring(1, colorPart.length - 1);
      color = hexToColor(hex);
    } else {
      // Parse color-shade format (e.g., red-500)
      final parts = colorPart.split('-');
      if (parts.isNotEmpty) {
        final colorName = parts[0];
        final shade = parts.length > 1 ? int.tryParse(parts[1]) ?? 500 : 500;
        color = theme.getColor(colorName, shade);
      }
    }

    // Apply opacity if specified
    if (color != null && opacity != null) {
      color = applyOpacity(color, opacity);
    }

    return color;
  }
}
