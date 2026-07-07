import 'package:flutter/widgets.dart';

import 'wind_parser_interface.dart';
import '../wind_style.dart';
import '../wind_context.dart';
import '../../utils/color_utils.dart';
import '../../theme/wind_theme_data.dart';

/// **SVG Parser**
///
/// Handles SVG-specific styling utilities.
///
/// ### Supported Utility Classes:
/// - **Fill:** `fill-red-500`, `fill-none`, `fill-current`
/// - **Stroke:** `stroke-blue-500`, `stroke-none`, `stroke-[2px]` (future)
/// - **Preserve:** `preserve-colors`: disables any [ColorFilter] on the SVG,
///   rendering embedded colours unchanged (ideal for QR codes and logos).
///
/// Returns a [WindStyle] with `fillColor`, `strokeColor`, and `preserveColors`.
/// Used by [WSvg] and `flutter_svg`.
class SvgParser implements WindParserInterface {
  const SvgParser();

  @override
  bool canParse(String className) {
    if (className.startsWith('fill-')) return true;
    if (className.startsWith('stroke-')) return true;
    if (className == 'preserve-colors') return true;
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
    bool? preserveColors;
    final theme = context.theme;

    for (final className in classes) {
      // Handle preserve-colors: disables ColorFilter entirely for multi-colour SVGs.
      if (className == 'preserve-colors') {
        preserveColors = true;
      }

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

    return styles.copyWith(
      fillColor: fillColor,
      strokeColor: strokeColor,
      preserveColors: preserveColors ?? styles.preserveColors,
    );
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
