import 'package:flutter/material.dart';

import '../parser/wind_style.dart';
import '../theme/wind_theme.dart';
import '../theme/wind_theme_data.dart';
import 'wind_helpers.dart';

/// Extension on BuildContext for convenient Wind theme access.
///
/// Provides quick access to theme data and helper function shortcuts.
///
/// Example:
/// ```dart
/// // Theme access
/// final theme = context.windTheme;
/// final colors = context.windColors;
///
/// // Helper shortcuts
/// Color blue = context.wColorExt('blue', 500)!;
/// double space = context.wSpacingExt(4);
/// ```
extension WindContextExtension on BuildContext {
  /// Returns the WindThemeData from the nearest WindTheme ancestor.
  WindThemeData get windTheme => WindTheme.of(this);

  /// Returns the colors map from the theme.
  Map<String, MaterialColor> get windColors => windTheme.colors;

  /// Returns the screens (breakpoints) map from the theme.
  Map<String, int> get windScreens => windTheme.screens;

  /// Returns the current brightness of the theme.
  Brightness get windBrightness => windTheme.brightness;

  /// Returns true if the theme is in dark mode.
  bool get windIsDark => windTheme.brightness == Brightness.dark;

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
