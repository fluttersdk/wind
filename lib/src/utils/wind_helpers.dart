import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// **Global Color Resolver**
///
/// Resolves a color by name/shade from the active [WindTheme].
///
/// Supports:
/// - `wColor(context, 'blue', 500)`
/// - `wColor(context, '#FFAABB')`
/// - `wColor(context, 'primary')`
Color? wColor(
  BuildContext context,
  String colorName, {
  int shade = 500,
  String? darkColorName,
  int darkShade = 500,
}) {
  final theme = WindTheme.dataOf(context);

  // Handle dark mode
  if (theme.brightness == Brightness.dark) {
    if (darkColorName != null) {
      return theme.getColor(darkColorName, darkShade);
    }
  }

  // Handle hex colors
  if (colorName.startsWith('#')) {
    return hexToColor(colorName);
  }

  // Handle color-shade format (e.g., 'blue-600')
  final match = RegExp(r'^([a-z]+)-(\d+)$').firstMatch(colorName);
  if (match != null) {
    colorName = match.group(1)!;
    shade = int.parse(match.group(2)!);
  }
  return theme.getColor(colorName, shade);
}

/// Returns a spacing value based on the multiplier.
///
/// The spacing is calculated as: `multiplier * baseSpacingUnit (default 4.0)`
///
/// Example:
/// ```dart
/// double space = wSpacing(context, 4); // 16.0
/// double half = wSpacing(context, 0.5); // 2.0
/// ```
double wSpacing(BuildContext context, num multiplier) {
  final theme = WindTheme.dataOf(context);
  return multiplier * theme.baseSpacingUnit;
}

/// Returns a font size by name.
///
/// Supports: xs, sm, base, lg, xl, 2xl, 3xl, 4xl, 5xl, 6xl, 7xl, 8xl, 9xl
///
/// Example:
/// ```dart
/// double size = wFontSize(context, 'lg'); // 18.0
/// double size = wFontSize(context, '2xl'); // 24.0
/// ```
double? wFontSize(BuildContext context, String sizeName) {
  final theme = WindTheme.dataOf(context);
  return theme.fontSizes[sizeName];
}

/// Returns a font weight by name.
///
/// Supports: thin, extralight, light, normal, medium, semibold, bold, extrabold, black
///
/// Example:
/// ```dart
/// FontWeight weight = wFontWeight(context, 'bold')!; // FontWeight.w700
/// FontWeight weight = wFontWeight(context, 'semibold')!; // FontWeight.w600
/// ```
FontWeight? wFontWeight(BuildContext context, String weightName) {
  final theme = WindTheme.dataOf(context);
  return theme.fontWeights[weightName];
}

/// Returns the pixel value for a breakpoint name.
///
/// Returns null if the breakpoint name is not valid.
///
/// Example:
/// ```dart
/// int? md = wScreen(context, 'md'); // 768
/// int? lg = wScreen(context, 'lg'); // 1024
/// int? invalid = wScreen(context, 'invalid'); // null
/// ```
int? wScreen(BuildContext context, String name) {
  final theme = WindTheme.dataOf(context);
  return theme.screens[name];
}

/// Checks if the current screen width is at least the given breakpoint.
///
/// Example:
/// ```dart
/// if (wScreenIs(context, 'md')) {
///   // Screen is tablet or larger
/// }
/// ```
bool wScreenIs(BuildContext context, String name) {
  final screenWidth = MediaQuery.of(context).size.width;
  final breakpointValue = wScreen(context, name);

  if (breakpointValue == null) return false;

  return screenWidth >= breakpointValue;
}

/// Returns the current active breakpoint name.
///
/// Example:
/// ```dart
/// String bp = wScreenCurrent(context); // 'md', 'lg', etc.
/// ```
String wScreenCurrent(BuildContext context) {
  final theme = WindTheme.dataOf(context);
  final screenWidth = MediaQuery.of(context).size.width;

  // Sort breakpoints by value descending
  final sortedBreakpoints = theme.screens.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  for (final entry in sortedBreakpoints) {
    if (screenWidth >= entry.value) {
      return entry.key;
    }
  }

  return 'base';
}

/// **Style Parser Helper**
///
/// Parses a utility string on the fly. Useful for debugging or One-off parsing.
///
/// Example:
/// ```dart
/// final style = wStyle(context, 'bg-red-500 p-4');
/// ```
WindStyle wStyle(BuildContext context, String className) {
  return WindParser.parse(className, context);
}
