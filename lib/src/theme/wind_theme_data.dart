import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
import 'defaults/ring_widths.dart' as default_ring_widths;
import 'defaults/box_shadows.dart';
import 'defaults/opacities.dart' as default_opacities;
import 'defaults/z_indices.dart' as default_z_indices;
import 'defaults/transitions.dart' as default_transitions;
import 'defaults/animations.dart' as default_animations;
import '../parser/wind_style.dart';

/// The REM unit used for sizing calculations.
const int windRemUnit = 4;

/// The pixel unit used for sizing calculations.
const double windPxUnit = 0.25;

/// **Theme Configuration**
///
/// `WindThemeData` holds the configuration for the entire design system, including
/// colors, typography, spacing, and breakpoints. It is the "Tailwind Config" of Wind.
///
/// Use [WindThemeData.copyWith] to override default values or add custom ones.
///
/// ### Customization Example:
///
/// ```dart
/// WindThemeData(
///   // Override or add colors
///   colors: {
///     'primary': Colors.indigo,
///     'brand': Color(0xFF1E3A8A),
///   },
///   // Custom font family
///   fontFamilies: {
///     'sans': 'Inter',
///     'display': 'Oswald',
///   },
///   // Custom spacing scale
///   baseSpacingUnit: 4.0, // 1 unit = 4px
/// )
/// ```
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

  /// A map of ring width names to width values.
  ///
  /// Defaults to [default_ring_widths.WindRingWidths.widths].
  final Map<String, double> ringWidths;

  /// A map of ring offset names to offset values.
  ///
  /// Defaults to [default_ring_widths.WindRingWidths.offsets].
  final Map<String, double> ringOffsets;

  /// Whether to apply the default 'sans' font family to all text.
  ///
  /// When true, WindTheme wraps its child with DefaultTextStyle
  /// using the 'sans' font family from [fontFamilies].
  ///
  /// Defaults to true (like Tailwind CSS).
  final bool applyDefaultFontFamily;

  /// Whether to sync theme brightness with system settings.
  ///
  /// When true (default), WindTheme will automatically sync with the
  /// system's brightness setting on startup and when it changes.
  ///
  /// When false, the explicitly set [brightness] will be preserved,
  /// ignoring system preferences.
  ///
  /// Defaults to true.
  final bool syncWithSystem;

  /// The base spacing unit used for spacing calculations.
  ///
  /// Defaults to 4.0.
  final double baseSpacingUnit;

  /// The default color for ring utility.
  ///
  /// Defaults to Tailwind's blue-500 (#3B82F6).
  final Color ringColor;

  /// A map of opacity names to opacity values.
  final Map<String, double> opacities;

  /// A map of z-index names to z-index values.
  final Map<String, int> zIndices;

  /// A map of shadow names to shadow lists.
  final Map<String, List<BoxShadow>> shadows;

  /// A map of transition duration names to durations.
  final Map<String, Duration> transitionDurations;

  /// A map of transition curve names to curves.
  final Map<String, Curve> transitionCurves;

  /// A map of animation class names to animation types.
  final Map<String, WindAnimationType> animations;

  /// User-defined className shortcut aliases; expanded before parsing. See
  /// WindParser alias expansion. This is developer configuration: expansion is
  /// bounded against cyclic and fan-out maps, but values are not a place to
  /// interpolate untrusted runtime strings.
  final Map<String, String> aliases;

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
    Map<String, double>? ringWidths,
    Map<String, double>? ringOffsets,
    this.applyDefaultFontFamily = true,
    this.syncWithSystem = true,
    this.baseSpacingUnit = 4.0,
    this.ringColor = const Color(0xFF3B82F6), // Tailwind blue-500
    Map<String, double>? opacities,
    Map<String, int>? zIndices,
    Map<String, List<BoxShadow>>? shadows,
    Map<String, Duration>? transitionDurations,
    Map<String, Curve>? transitionCurves,
    Map<String, WindAnimationType>? animations,
    Map<String, String>? aliases,
  })  : colors = (Map<String, MaterialColor>.from(_initColors())
          ..addAll(colors ?? {})),
        fontSizes = (Map<String, double>.from(default_font_sizes.fontSizes)
          ..addAll(fontSizes ?? {})),
        fontWeights = (Map<String, FontWeight>.from(
          default_font_weights.fontWeights,
        )..addAll(fontWeights ?? {})),
        tracking = (Map<String, double>.from(default_tracking.tracking)
          ..addAll(tracking ?? {})),
        leading = (Map<String, double>.from(default_leading.leading)
          ..addAll(leading ?? {})),
        borderWidths = (Map<String, double>.from(
          default_border_widths.borderWidths,
        )..addAll(borderWidths ?? {})),
        borderRadius = (Map<String, double>.from(
          default_border_radius.borderRadius,
        )..addAll(borderRadius ?? {})),
        fontFamilies = (Map<String, String>.from(
          default_font_families.fontFamilies,
        )..addAll(fontFamilies ?? {})),
        ringWidths = (Map<String, double>.from(
          default_ring_widths.WindRingWidths.widths,
        )..addAll(ringWidths ?? {})),
        ringOffsets = (Map<String, double>.from(
          default_ring_widths.WindRingWidths.offsets,
        )..addAll(ringOffsets ?? {})),
        containers = (Map<String, int>.from(default_containers.containers)
          ..addAll(containers ?? {})),
        screens = (Map<String, int>.from(default_screens.screens)
          ..addAll(screens ?? {})),
        opacities = (Map<String, double>.from(default_opacities.opacities)
          ..addAll(opacities ?? {})),
        zIndices = (Map<String, int>.from(default_z_indices.zIndices)
          ..addAll(zIndices ?? {})),
        shadows = (Map<String, List<BoxShadow>>.from(WindBoxShadows.shadows)
          ..addAll(shadows ?? {})),
        transitionDurations = (Map<String, Duration>.from(
          default_transitions.transitionDurations,
        )..addAll(transitionDurations ?? {})),
        transitionCurves = (Map<String, Curve>.from(
          default_transitions.transitionCurves,
        )..addAll(transitionCurves ?? {})),
        animations = (Map<String, WindAnimationType>.from(
          default_animations.animations,
        )..addAll(animations ?? {})),
        aliases = Map<String, String>.from(aliases ?? const {});

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
    })
      ..removeWhere((key, value) => value.toARGB32() == 0);
  }

  /// Returns a color from the theme.
  ///
  /// If the theme is dark, it will return the inverted color.
  Color? getColor(String colorName, int shade) {
    if (colors[colorName] == null) {
      return null;
    }

    if (colors[colorName]![shade] == null) {
      return null;
    }

    return colors[colorName]?[shade];
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
    Map<String, double>? ringWidths,
    Map<String, double>? ringOffsets,
    bool? applyDefaultFontFamily,
    bool? syncWithSystem,
    double? baseSpacingUnit,
    Color? ringColor,
    Map<String, double>? opacities,
    Map<String, int>? zIndices,
    Map<String, List<BoxShadow>>? shadows,
    Map<String, Duration>? transitionDurations,
    Map<String, Curve>? transitionCurves,
    Map<String, WindAnimationType>? animations,
    Map<String, String>? aliases,
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
      ringWidths: ringWidths != null
          ? (Map.from(this.ringWidths)..addAll(ringWidths))
          : this.ringWidths,
      ringOffsets: ringOffsets != null
          ? (Map.from(this.ringOffsets)..addAll(ringOffsets))
          : this.ringOffsets,
      applyDefaultFontFamily:
          applyDefaultFontFamily ?? this.applyDefaultFontFamily,
      syncWithSystem: syncWithSystem ?? this.syncWithSystem,
      baseSpacingUnit: baseSpacingUnit ?? this.baseSpacingUnit,
      ringColor: ringColor ?? this.ringColor,
      opacities: opacities != null
          ? (Map.from(this.opacities)..addAll(opacities))
          : this.opacities,
      zIndices: zIndices != null
          ? (Map.from(this.zIndices)..addAll(zIndices))
          : this.zIndices,
      shadows: shadows != null
          ? (Map.from(this.shadows)..addAll(shadows))
          : this.shadows,
      transitionDurations: transitionDurations != null
          ? (Map.from(this.transitionDurations)..addAll(transitionDurations))
          : this.transitionDurations,
      transitionCurves: transitionCurves != null
          ? (Map.from(this.transitionCurves)..addAll(transitionCurves))
          : this.transitionCurves,
      animations: animations != null
          ? (Map.from(this.animations)..addAll(animations))
          : this.animations,
      aliases: aliases != null
          ? (Map.from(this.aliases)..addAll(aliases))
          : this.aliases,
    );
  }

  /// Returns a new [WindThemeData] with the brightness toggled.
  ///
  /// If currently light, returns dark. If currently dark, returns light.
  WindThemeData toggleTheme() {
    return copyWith(
      brightness:
          brightness == Brightness.light ? Brightness.dark : Brightness.light,
    );
  }

  /// Converts this [WindThemeData] into a Flutter [ThemeData].
  ///
  /// This allows binding the Wind theme to the Material application theme,
  /// ensuring consistency between Wind utility classes and standard Material widgets.
  ///
  /// The logic tries to map 'primary', 'secondary', and 'error' colors from
  /// the [colors] map. If not found, it falls back to defaults.
  ThemeData toThemeData() {
    // Helper to safely fetch default material color
    MaterialColor getDefault(String name) {
      final raw = default_colors.colors[name] as Map<int, Color>;
      return MaterialColor(raw[500]!.toARGB32(), raw);
    }

    // Resolve colors or use defaults
    final primary = colors['primary'] ?? getDefault('indigo');
    final secondary = colors['secondary'] ?? getDefault('teal');
    final error = colors['error'] ?? getDefault('red');

    final surface = colors['white'] ?? default_colors.colors['white'] as Color;

    Color background;
    if (colors.containsKey('background')) {
      background = colors['background']!;
    } else {
      if (brightness == Brightness.dark) {
        final gray = default_colors.colors['gray'] as Map<int, Color>;
        background = gray[900]!;
      } else {
        background = default_colors.colors['white'] as Color;
      }
    }

    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
      primary: primary,
      secondary: secondary,
      error: error,
      surface: surface,
      // Use surfaceContainerHighest for background effect in Material 3
      surfaceContainerHighest: background,
    );

    // Resolve Typography
    final defaultFontFamily = fontFamilies['sans'];
    TextTheme? textTheme;
    if (defaultFontFamily != null) {
      textTheme = ThemeData(
        brightness: brightness,
      ).textTheme.apply(fontFamily: defaultFontFamily);
    }

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      fontFamily: defaultFontFamily,
      canvasColor: Colors.transparent,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WindThemeData &&
        other.brightness == brightness &&
        other.applyDefaultFontFamily == applyDefaultFontFamily &&
        other.syncWithSystem == syncWithSystem &&
        other.baseSpacingUnit == baseSpacingUnit &&
        other.ringColor == ringColor &&
        mapEquals(other.colors, colors) &&
        mapEquals(other.screens, screens) &&
        mapEquals(other.containers, containers) &&
        mapEquals(other.fontSizes, fontSizes) &&
        mapEquals(other.fontWeights, fontWeights) &&
        mapEquals(other.tracking, tracking) &&
        mapEquals(other.leading, leading) &&
        mapEquals(other.borderWidths, borderWidths) &&
        mapEquals(other.borderRadius, borderRadius) &&
        mapEquals(other.fontFamilies, fontFamilies) &&
        mapEquals(other.ringWidths, ringWidths) &&
        mapEquals(other.ringOffsets, ringOffsets) &&
        mapEquals(other.opacities, opacities) &&
        mapEquals(other.zIndices, zIndices) &&
        mapEquals(other.shadows, shadows) &&
        mapEquals(other.transitionDurations, transitionDurations) &&
        mapEquals(other.transitionCurves, transitionCurves) &&
        mapEquals(other.animations, animations) &&
        mapEquals(other.aliases, aliases);
  }

  // hashCode is composed from the scalar fields only. The map fields are
  // rebuilt (merged with defaults) on every construction, so hashing them by
  // identity would break the equal-objects-share-a-hashCode contract that the
  // value-based `operator ==` establishes. A scalar-only hash stays consistent
  // with `==` (equal objects always agree on every scalar) at the cost of more
  // collisions between themes that differ only in their maps, which is fine.
  @override
  int get hashCode => Object.hash(
        brightness,
        applyDefaultFontFamily,
        syncWithSystem,
        baseSpacingUnit,
        ringColor,
      );
}
