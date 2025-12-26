import 'package:flutter/material.dart';

import '../parser/wind_style.dart';
import '../theme/wind_theme.dart';
import '../theme/wind_theme_data.dart';
import 'wind_helpers.dart';

/// **Wind Context Extensions**
///
/// Extensions on [BuildContext] for ergonomic access to Wind's theme and helpers.
///
/// ### Theme Control:
/// - `context.windTheme` -> Returns [WindThemeController] for toggling/updating theme
/// - `context.windThemeData` -> Returns [WindThemeData] for read-only access
///
/// ### Shortcuts:
/// - `context.windColors` -> Access theme colors
/// - `context.wIsMobile` -> Check for mobile breakpoint
/// - `context.wColorExt('red', 500)` -> Resolve color safely
///
/// Example:
/// ```dart
/// // Toggle theme
/// context.windTheme.toggleTheme();
///
/// // Access colors
/// final color = context.windColors['primary'];
/// ```
extension WindContextExtension on BuildContext {
  /// Returns the WindThemeController from the nearest WindTheme ancestor.
  ///
  /// Use this to toggle theme or set new theme data:
  /// ```dart
  /// context.windTheme.toggleTheme();
  /// ```
  WindThemeController get windTheme => WindTheme.of(this);

  /// Returns the WindThemeData from the nearest WindTheme ancestor.
  ///
  /// Use this for read-only access to theme properties:
  /// ```dart
  /// final colors = context.windThemeData.colors;
  /// ```
  WindThemeData get windThemeData => WindTheme.dataOf(this);

  /// Returns the colors map from the theme.
  Map<String, MaterialColor> get windColors => windThemeData.colors;

  /// Returns the screens (breakpoints) map from the theme.
  Map<String, int> get windScreens => windThemeData.screens;

  /// Returns the current brightness of the theme.
  Brightness get windBrightness => windThemeData.brightness;

  /// Returns true if the theme is in dark mode.
  bool get windIsDark => windThemeData.brightness == Brightness.dark;

  /// Shortcut for wColor(context, colorName, shade).
  Color? wColorExt(String colorName, [int shade = 500]) =>
      wColor(this, colorName, shade);

  /// Shortcut for wSpacing(context, multiplier).
  double wSpacingExt(num multiplier) => wSpacing(this, multiplier);

  /// Shortcut for wFontSize(context, sizeName).
  double? wFontSizeExt(String sizeName) => wFontSize(this, sizeName);

  /// Shortcut for wFontWeight(context, weightName).
  FontWeight? wFontWeightExt(String weightName) =>
      wFontWeight(this, weightName);

  /// Shortcut for wScreenIs(context, name).
  bool wScreenIsExt(String name) => wScreenIs(this, name);

  /// Returns the current active breakpoint name.
  String get wActiveBreakpoint => wScreenCurrent(this);

  /// Returns true if current screen is mobile (< md breakpoint).
  bool get wIsMobile => !wScreenIs(this, 'md');

  /// Returns true if current screen is tablet (>= md and < lg).
  bool get wIsTablet => wScreenIs(this, 'md') && !wScreenIs(this, 'lg');

  /// Returns true if current screen is desktop (>= lg).
  bool get wIsDesktop => wScreenIs(this, 'lg');

  /// Shortcut for wStyle(context, className).
  WindStyle wStyleExt(String className) => wStyle(this, className);
}
