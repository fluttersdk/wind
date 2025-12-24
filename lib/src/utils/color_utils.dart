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
