import 'package:flutter/material.dart';

/// Inverts the shades of a [MaterialColor].
///
/// This is used to automatically generate a dark mode color palette from a
/// light mode palette.
MaterialColor invertMaterialColor(MaterialColor color) {
  return MaterialColor(color.toARGB32(), <int, Color>{
    50: color.shade900,
    100: color.shade800,
    200: color.shade700,
    300: color.shade600,
    400: color.shade500,
    500: color.shade400,
    600: color.shade300,
    700: color.shade200,
    800: color.shade100,
    900: color.shade50,
  });
}

/// Converts a hex color code to a [Color] object.
///
/// Supports the following formats:
/// - `#RRGGBB`
/// - `#AARRGGBB`
/// - `#RGB` (shorthand for `#RRGGBB`)
/// - `#ARGB` (shorthand for `#AARRGGBB`)
///
/// Examples:
/// - `#FF5733`
/// - `#80FF5733`
/// - `#F53`
/// - `#8F53`
///
/// Returns a [Color] object representing the color.
Color hexToColor(String code) {
  // If has `#` prefix, remove it
  if (code.startsWith('#')) {
    code = code.substring(1);
  }

  // If has 3 or 4 characters, expand to 6 or 8 characters
  if (code.length == 3) {
    code = code.split('').map((c) => c + c).join();
  } else if (code.length == 4) {
    code = code.split('').map((c) => c + c).join();
  }

  // If has 6 characters, add `FF` for alpha
  if (code.length == 6) {
    code = 'FF$code';
  }

  return Color(int.parse(code, radix: 16));
}

/// Parses a color class with optional opacity modifier.
///
/// Supports the format: `{color}-{shade}/{opacity}` where opacity is 0-100.
///
/// Examples:
/// - `blue-500/50` -> blue-500 with 50% opacity
/// - `red-500/75` -> red-500 with 75% opacity
/// - `[#FF5733]/25` -> #FF5733 with 25% opacity
///
/// Returns a tuple of (colorPart, opacityValue) where opacityValue is null if no opacity.
({String colorPart, double? opacity}) parseColorOpacity(String colorClass) {
  final parts = colorClass.split('/');

  if (parts.length == 2) {
    final opacityStr = parts[1];
    // Handle arbitrary opacity like /[0.5] or /[50]
    if (opacityStr.startsWith('[') && opacityStr.endsWith(']')) {
      final inner = opacityStr.substring(1, opacityStr.length - 1);
      final val = double.tryParse(inner);
      if (val != null) {
        // If <= 1.0, assume factor (0.0 - 1.0). If > 1.0, assume percentage (0 - 100).
        return (colorPart: parts[0], opacity: val <= 1.0 ? val : val / 100.0);
      }
    }
    // Handle standard opacity like /50
    final val = int.tryParse(opacityStr);
    if (val != null) {
      return (colorPart: parts[0], opacity: val / 100.0);
    }
  }

  return (colorPart: parts[0], opacity: null);
}

/// Applies opacity to a Color.
///
/// [opacity] should be 0.0-1.0 where 0 is fully transparent and 1 is fully opaque.
Color applyOpacity(Color color, double opacity) {
  final alpha = (opacity * 255).round().clamp(0, 255);
  return color.withAlpha(alpha);
}
