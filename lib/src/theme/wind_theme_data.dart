import 'package:flutter/material.dart';

import '../utils/color_utils.dart';
import 'defaults/border_radius.dart' as default_border_radius;
import 'defaults/border_widths.dart' as default_border_widths;
import 'defaults/colors.dart' as default_colors;
import 'defaults/containers.dart' as default_containers;
import 'defaults/font_families.dart' as default_font_families;
import 'defaults/font_sizes.dart' as default_font_sizes;
import 'defaults/font_weights.dart' as default_font_weights;
import 'defaults/leading.dart' as default_leading;
import 'defaults/screens.dart' as default_screens;
import 'defaults/tracking.dart' as default_tracking;

/// The REM unit used for sizing calculations.
const int windRemUnit = 4;

/// The pixel unit used for sizing calculations.
const double windPxUnit = 0.25;

/// Defines the configuration for the Wind theme.
///
/// This class holds the theme data for colors and screen sizes.
class WindThemeData {
  /// The brightness of the theme.
  final Brightness brightness;

  /// A map of color names to color values.
  ///
  /// Defaults to [default_colors.colors].
  final Map<String, MaterialColor> colors;

  /// A map of screen size names to pixel values.
  ///
  /// Defaults to [default_screens.screens].
  final Map<String, int> screens;

  /// A map of container size names to pixel values.
  ///
  /// Defaults to [default_containers.containers].
  final Map<String, int> containers;

  /// A map of font size names to size values.
  ///
  /// Defaults to [default_font_sizes.fontSizes].
  final Map<String, double> fontSizes;

  /// A map of font weight names to weight values.
  ///
  /// Defaults to [default_font_weights.fontWeights].
  final Map<String, FontWeight> fontWeights;

  /// A map of letter spacing names to spacing values.
  ///
  /// Defaults to [default_tracking.tracking].
  final Map<String, double> tracking;

  /// A map of line height names to height values.
  ///
  /// Defaults to [default_leading.leading].
  final Map<String, double> leading;

  /// A map of border width names to width values.
  ///
  /// Defaults to [default_border_widths.borderWidths].
  final Map<String, double> borderWidths;

  /// A map of border radius names to radius values.
  ///
  /// Defaults to [default_border_radius.borderRadius].
  final Map<String, double> borderRadius;

  /// A map of font family names to font family values.
  ///
  /// Defaults to [default_font_families.fontFamilies].
  final Map<String, String> fontFamilies;

  /// Whether to apply the default 'sans' font family to all text.
  ///
  /// When true, WindTheme wraps its child with DefaultTextStyle
  /// using the 'sans' font family from [fontFamilies].
  ///
  /// Defaults to true (like Tailwind CSS).
  final bool applyDefaultFontFamily;

  /// The base spacing unit used for spacing calculations.
  ///
  /// Defaults to 4.0.
  final double baseSpacingUnit;

  /// The resolved colors based on the theme's brightness.
  late final Map<String, MaterialColor> _resolvedColors;

  /// Creates a new [WindThemeData] instance.
  ///
  /// If [colors] or [screens] are not provided, they will default
  /// to the predefined values.
  WindThemeData({
    this.brightness = Brightness.light,
    Map<String, MaterialColor>? colors,
    Map<String, int>? screens,
    Map<String, int>? containers,
    Map<String, double>? fontSizes,
    Map<String, FontWeight>? fontWeights,
    Map<String, double>? tracking,
    Map<String, double>? leading,
    Map<String, double>? borderWidths,
    Map<String, double>? borderRadius,
    Map<String, String>? fontFamilies,
    this.applyDefaultFontFamily = true,
    this.baseSpacingUnit = 4.0,
  }) : colors = colors ?? _initColors(),
       fontSizes = fontSizes ?? default_font_sizes.fontSizes,
       fontWeights = fontWeights ?? default_font_weights.fontWeights,
       tracking = tracking ?? default_tracking.tracking,
       leading = leading ?? default_leading.leading,
       borderWidths = borderWidths ?? default_border_widths.borderWidths,
       borderRadius = borderRadius ?? default_border_radius.borderRadius,
       fontFamilies = fontFamilies ?? default_font_families.fontFamilies,
       containers = containers ?? default_containers.containers,
       screens = screens ?? default_screens.screens {
    _resolvedColors = _resolveColors();
  }

  /// Initializes the default colors from the predefined color map.
  ///
  /// Converts the dynamic color definitions into MaterialColor instances.
  static Map<String, MaterialColor> _initColors() {
    return default_colors.colors.map((key, value) {
      if (value is Map<int, Color>) {
        return MapEntry(key, MaterialColor(value[500]!.toARGB32(), value));
      }
      if (value is Color) {
        final shades = {
          for (var i = 50; i <= 900; i += (i == 50 ? 50 : 100)) i: value,
        };
        return MapEntry(key, MaterialColor(value.toARGB32(), shades));
      }
      return MapEntry(key, MaterialColor(0, {}));
    })..removeWhere((key, value) => value.toARGB32() == 0);
  }

  /// Resolves the colors based on the current brightness.
  ///
  /// In dark mode, colors are inverted using [invertMaterialColor].
  Map<String, MaterialColor> _resolveColors() {
    if (brightness == Brightness.dark) {
      return Map.fromEntries(
        colors.entries.map((entry) {
          if (entry.key == 'white') {
            return MapEntry(entry.key, invertMaterialColor(colors['gray']!));
          }
          if (entry.key == 'black') {
            return MapEntry(entry.key, colors['gray']!);
          }
          return MapEntry(entry.key, invertMaterialColor(entry.value));
        }),
      );
    } else {
      return colors;
    }
  }

  /// Returns a color from the theme.
  ///
  /// If the theme is dark, it will return the inverted color.
  Color? getColor(String colorName, int shade) {
    return _resolvedColors[colorName]?[shade];
  }

  /// Returns the original color from the theme, regardless of brightness.
  Color? getOriginalColor(String colorName, int shade) {
    return colors[colorName]?[shade];
  }

  /// Checks if the given color name (and optional shade) exists in the theme.
  bool isValidColor(String colorName, {int? shade}) {
    if (shade != null) {
      return colors.containsKey(colorName) &&
          colors[colorName]!.keys.contains(shade);
    }

    return colors.containsKey(colorName);
  }

  /// Returns spacing based on the given [multiplier].
  ///
  /// Supports integer multipliers (e.g., '2', '3.5'),
  /// container keys (e.g., 'xs', 'sm', 'md', 'lg', 'xl'),
  /// and special values like 'full' which returns [double.infinity].
  ///
  /// Examples:
  /// - `getSpacing('2')` returns `8.0` (2 * baseSpacingUnit)
  /// - `getSpacing('md')` returns the spacing for the 'md' container.
  /// - `getSpacing('full')` returns `double.infinity`.
  double getSpacing(String multiplier) {
    // Handle special 'full' case
    if (multiplier == 'full') {
      return double.infinity;
    }

    if (containers.containsKey(multiplier)) {
      return containers[multiplier]!.toDouble() * baseSpacingUnit;
    } else {
      final value = double.tryParse(multiplier);
      if (value != null) {
        return value * baseSpacingUnit;
      } else {
        throw ArgumentError('Invalid spacing multiplier: $multiplier');
      }
    }
  }

  /// Creates a copy of this theme data but with the given fields replaced.
  ///
  /// Example:
  /// ```dart
  /// final newTheme = oldTheme.copyWith(brightness: Brightness.dark);
  /// ```
  WindThemeData copyWith({
    Brightness? brightness,
    Map<String, MaterialColor>? colors,
    Map<String, int>? screens,
    Map<String, int>? containers,
    Map<String, double>? fontSizes,
    Map<String, FontWeight>? fontWeights,
    Map<String, double>? tracking,
    Map<String, double>? leading,
    Map<String, double>? borderWidths,
    Map<String, double>? borderRadius,
    Map<String, String>? fontFamilies,
    bool? applyDefaultFontFamily,
    double? baseSpacingUnit,
  }) {
    return WindThemeData(
      brightness: brightness ?? this.brightness,
      colors: colors != null
          ? (Map.from(this.colors)..addAll(colors))
          : this.colors,
      screens: screens != null
          ? (Map.from(this.screens)..addAll(screens))
          : this.screens,
      containers: containers != null
          ? (Map.from(this.containers)..addAll(containers))
          : this.containers,
      fontSizes: fontSizes != null
          ? (Map.from(this.fontSizes)..addAll(fontSizes))
          : this.fontSizes,
      fontWeights: fontWeights != null
          ? (Map.from(this.fontWeights)..addAll(fontWeights))
          : this.fontWeights,
      tracking: tracking != null
          ? (Map.from(this.tracking)..addAll(tracking))
          : this.tracking,
      leading: leading != null
          ? (Map.from(this.leading)..addAll(leading))
          : this.leading,
      borderWidths: borderWidths != null
          ? (Map.from(this.borderWidths)..addAll(borderWidths))
          : this.borderWidths,
      borderRadius: borderRadius != null
          ? (Map.from(this.borderRadius)..addAll(borderRadius))
          : this.borderRadius,
      fontFamilies: fontFamilies != null
          ? (Map.from(this.fontFamilies)..addAll(fontFamilies))
          : this.fontFamilies,
      applyDefaultFontFamily:
          applyDefaultFontFamily ?? this.applyDefaultFontFamily,
      baseSpacingUnit: baseSpacingUnit ?? this.baseSpacingUnit,
    );
  }
}
