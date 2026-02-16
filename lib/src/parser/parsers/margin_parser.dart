import 'package:flutter/material.dart';

import '../wind_context.dart';
import '../wind_style.dart';
import 'wind_parser_interface.dart';

/// **Margin Parser**
///
/// Handles `m-*`, `mx-*`, `my-*`, etc.
///
/// ### Supported Utility Classes:
/// - **All Sides:** `m-{value}`, `m-[{arbitrary}]`
/// - **Axis:** `mx-{value}` (horizontal), `my-{value}` (vertical)
/// - **Sides:** `mt-` (top), `mr-` (right), `mb-` (bottom), `ml-` (left)
/// - **Special:** `mx-auto` (horizontal centering)
///
/// ### Values:
/// - **Theme:** `m-4`, `mx-2`, `my-1/2` (fractions supported)
/// - **Arbitrary:** `m-[10px]`, `mx-[3.5]` (px suffix optional)
///
/// ### Notes:
/// - Negative margins (e.g., `-m-4`) are not supported by this parser.
/// - Responsive (`md:`), state (`hover:`), and other prefixes are resolved by WindParser.
///
/// Returns a [WindStyle] with resolved `margin` property.
class MarginParser implements WindParserInterface {
  const MarginParser();

  /// Regex for theme-based margin classes
  /// e.g., m-4, mt-2, mx-1/2
  static final _themeMarginRegex = RegExp(
    r'^(?<root>m|mt|mr|mb|ml|mx|my)-(?<value>[a-zA-Z0-9./]+)$',
  );

  /// Regex for arbitrary margin classes
  /// e.g., m-[10px], mx-[3.5]
  static final _arbitraryMarginRegex = RegExp(
    r'^(?<root>m|mt|mr|mb|ml|mx|my)-\[(?<value>[0-9.]+(?:px)?)\]$',
  );

  /// Parses margin-related classes and returns updated WindStyle
  ///
  /// Example:
  /// ```dart
  /// final parser = MarginParser();
  /// final styles = WindStyle();
  /// final classes = ['m-4', 'mt-8']; // 'mt-8' will win for top margin
  /// final context = WindContext.build(context);
  /// final updatedStyles = parser.parse(styles, classes, context);
  /// ```
  @override
  WindStyle parse(
    WindStyle styles,
    List<String>? classes,
    WindContext context,
  ) {
    if (classes == null) return styles;

    final theme = context.theme;

    // "Last Class Wins" (reverse iteration) requires us to track
    // which values have been set.
    double? mTop;
    double? mBottom;
    double? mLeft;
    double? mRight;
    bool? marginXAuto;

    for (var i = classes.length - 1; i >= 0; i--) {
      final className = classes[i];

      // Handle mx-auto specially
      if (className == 'mx-auto') {
        marginXAuto ??= true;
        continue;
      }

      double? value;
      String? root;

      // 1. Arbitrary Values (e.g., m-[10px])
      final arbitraryMatch = _arbitraryMarginRegex.firstMatch(className);
      if (arbitraryMatch != null) {
        root = arbitraryMatch.namedGroup('root')!;
        final valueStr = arbitraryMatch.namedGroup('value')!;
        // Margin cannot be a percentage, so we ignore %
        value = double.tryParse(valueStr.replaceAll('px', ''));
      }

      // 2. Theme Values (e.g., m-4, mx-1/2)
      final match = _themeMarginRegex.firstMatch(className);
      if (match != null) {
        root = match.namedGroup('root')!;
        final valueKey = match.namedGroup('value')!; // "4", "1/2"

        // Skip 'auto' value - it's handled by mx-auto
        if (valueKey == 'auto') continue;

        // Call the theme's `getSpacing` method
        value = theme.getSpacing(valueKey);
      }

      if (value == null || root == null) continue;

      // Apply "Last Class Wins" logic (only set if null)
      switch (root) {
        case 'm':
          mTop ??= value;
          mBottom ??= value;
          mLeft ??= value;
          mRight ??= value;
          break;
        case 'mt':
          mTop ??= value;
          break;
        case 'mb':
          mBottom ??= value;
          break;
        case 'ml':
          mLeft ??= value;
          break;
        case 'mr':
          mRight ??= value;
          break;
        case 'mx':
          mLeft ??= value;
          mRight ??= value;
          // Explicit mx-{value} (like mx-0) should disable mx-auto centering
          marginXAuto ??= false;
          break;
        case 'my':
          mTop ??= value;
          mBottom ??= value;
          break;
      }
    }

    final bool didChange = mTop != null ||
        mBottom != null ||
        mLeft != null ||
        mRight != null ||
        marginXAuto != null;

    if (!didChange) {
      return styles;
    }

    // `copyWith` intelligently merges with existing margin
    return styles.copyWith(
      margin:
          (mTop != null || mBottom != null || mLeft != null || mRight != null)
              ? EdgeInsets.only(
                  top: mTop ?? 0.0,
                  bottom: mBottom ?? 0.0,
                  left: mLeft ?? 0.0,
                  right: mRight ?? 0.0,
                )
              : null,
      marginXAuto: marginXAuto,
    );
  }

  /// Checks if the parser can parse the given class name
  @override
  bool canParse(String className) {
    return className.startsWith('m-') ||
        className.startsWith('mt-') ||
        className.startsWith('mb-') ||
        className.startsWith('ml-') ||
        className.startsWith('mr-') ||
        className.startsWith('mx-') ||
        className.startsWith('my-');
  }
}
