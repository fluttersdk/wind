import 'package:flutter/material.dart';

import '../wind_context.dart';
import '../wind_style.dart';
import 'wind_parser_interface.dart';

/// **Sizing Parser**
///
/// Handles width, height, and constraint utilities for widgets.
///
/// ### Supported Utility Classes:
/// - **Width (`w-`):** `w-4` (spacing), `w-full` (100%), `w-screen` (viewport width), `w-1/2` (factor), `w-[300px]` (arbitrary)
/// - **Height (`h-`):** `h-4`, `h-full`, `h-screen`, `h-3/4`, `h-[50%]`
/// - **Min Width (`min-w-`):** `min-w-0`, `min-w-full`, `min-w-screen`, `min-w-[100px]`
/// - **Max Width (`max-w-`):** `max-w-md` (named), `max-w-7xl`, `max-w-full`, `max-w-prose`, `max-w-screen`
/// - **Min Height (`min-h-`):** `min-h-0`, `min-h-full`, `min-h-screen`
/// - **Max Height (`max-h-`):** `max-h-full`, `max-h-screen`
///
/// ### Features:
/// - **Theme Spacing:** Numeric values like `w-4` use `WindThemeData.getSpacing()`.
/// - **Fractions:** Supports fraction-based sizing like `w-1/2`, `h-3/5`, etc.
/// - **Named Max-Widths:** Implements Tailwind scales from `xs` (320px) to `7xl` (1280px) and `prose`.
/// - **Arbitrary Values:** Supports `[px]` and `[%]` values like `w-[500px]` or `h-[25%]`.
/// - **Responsive & State:** Supports standard prefixes (e.g., `md:w-full`, `hover:h-20`) after they
///   are resolved by the core parser.
///
/// Returns a [WindStyle] with `width`, `height`, `widthFactor`, `heightFactor`, and `constraints`.
class SizingParser implements WindParserInterface {
  const SizingParser();

  /// Regular expression to match sizing classes
  static final RegExp _sizingRegExp = RegExp(
    r'^(?<root>w|h|min-w|max-w|min-h|max-h)-(?<value>[a-zA-Z0-9./]+|screen)$',
  );

  /// Regular expression to match arbitrary sizing classes
  static final RegExp _arbitraryRegExp = RegExp(
    r'^(?<root>w|h|min-w|max-w|min-h|max-h)-\[(?<value>[0-9.]+%?(?:px)?)\]$',
  );

  /// Named max-width sizes from Tailwind CSS default config
  /// https://tailwindcss.com/docs/max-width
  static const Map<String, double> _namedMaxWidths = {
    'xs': 320,
    'sm': 384,
    'md': 448,
    'lg': 512,
    'xl': 576,
    '2xl': 672,
    '3xl': 768,
    '4xl': 896,
    '5xl': 1024,
    '6xl': 1152,
    '7xl': 1280,
    // Deliberate fixed-px divergence from Tailwind's font-relative 65ch: 512px
    // matches max-w-lg and avoids font-size dependency at render time.
    'prose': 512,
  };

  /// Parses sizing related classes and returns updated WindStyle
  ///
  /// Example:
  /// ```dart
  /// final parser = SizingParser();
  /// final styles = WindStyle();
  /// final classes = ['w-100', 'h-[50%]', 'max-w-screen'];
  /// final context = WindContext(screenWidth: 400, screenHeight: 800);
  /// final updatedStyles = parser.parse(styles, classes, context);
  /// ```
  @override
  WindStyle parse(
    WindStyle styles,
    List<String>? classes,
    WindContext context,
  ) {
    if (classes == null) return styles;

    double? width;
    double? height;
    double? minWidth;
    double? maxWidth;
    double? minHeight;
    double? maxHeight;
    double? widthFactor;
    double? heightFactor;

    for (var i = classes.length - 1; i >= 0; i--) {
      final className = classes[i];

      final arbitraryMatch = _arbitraryRegExp.firstMatch(className);
      if (arbitraryMatch != null) {
        final root = arbitraryMatch.namedGroup('root')!;
        final valueStr = arbitraryMatch.namedGroup('value')!;

        if (valueStr.endsWith('%')) {
          final factor =
              (double.tryParse(valueStr.replaceAll('%', '')) ?? 0.0) / 100.0;

          if (root == 'w' && widthFactor == null) widthFactor = factor;
          if (root == 'h' && heightFactor == null) heightFactor = factor;
        } else {
          final value = double.tryParse(valueStr.replaceAll('px', '')) ?? 0.0;

          if (root == 'w' && width == null) width = value;
          if (root == 'h' && height == null) height = value;
          if (root == 'min-w' && minWidth == null) minWidth = value;
          if (root == 'max-w' && maxWidth == null) maxWidth = value;
          if (root == 'min-h' && minHeight == null) minHeight = value;
          if (root == 'max-h' && maxHeight == null) maxHeight = value;
        }
        continue;
      }

      final match = _sizingRegExp.firstMatch(className);
      if (match != null) {
        final root = match.namedGroup('root')!;
        final valueKey = match.namedGroup('value')!;

        if (valueKey == 'screen') {
          if (root == 'w' && width == null) width = context.screenWidth;
          if (root == 'h' && height == null) height = context.screenHeight;
          if (root == 'min-w' && minWidth == null) {
            minWidth = context.screenWidth;
          }
          if (root == 'max-w' && maxWidth == null) {
            maxWidth = context.screenWidth;
          }
          if (root == 'min-h' && minHeight == null) {
            minHeight = context.screenHeight;
          }
          if (root == 'max-h' && maxHeight == null) {
            maxHeight = context.screenHeight;
          }
        } else if (valueKey == 'full') {
          // Handle full for all roots
          if (root == 'w' && widthFactor == null) {
            widthFactor = 1.0;
          } else if (root == 'h' && heightFactor == null) {
            heightFactor = 1.0;
          } else if (root == 'min-w' && minWidth == null) {
            // min-w-full means minimum width should be parent's full width
            // Use screen width as fallback since ConstrainedBox doesn't support factors
            minWidth = context.screenWidth;
          } else if (root == 'min-h' && minHeight == null) {
            // min-h-full means minimum height should be parent's full height
            // Use screen height as fallback
            minHeight = context.screenHeight;
          } else if (root == 'max-w' && maxWidth == null) {
            maxWidth = double.infinity;
          } else if (root == 'max-h' && maxHeight == null) {
            maxHeight = double.infinity;
          }
        } else if (root == 'max-w' && _namedMaxWidths.containsKey(valueKey)) {
          // Handle named max-widths: max-w-xs, max-w-sm, max-w-md, etc.
          maxWidth ??= _namedMaxWidths[valueKey];
        } else {
          String type = 'absolute';
          double value = 0.0;

          if (valueKey == 'auto') {
            // skip 'auto' values
            continue;
          } else {
            // Handle fractions (e.g. 1/2, 2/5)
            if (valueKey.contains('/')) {
              final parts = valueKey.split('/');
              if (parts.length == 2) {
                final numerator = double.tryParse(parts[0]);
                final denominator = double.tryParse(parts[1]);
                if (numerator != null &&
                    denominator != null &&
                    denominator != 0) {
                  type = 'factor';
                  value = numerator / denominator;
                  // Parsed successfully, proceeds to assignment below
                } else {
                  continue;
                }
              } else {
                continue;
              }
            } else {
              // Try parsing as number first to validate check
              final parsedValue = double.tryParse(valueKey);
              if (parsedValue != null) {
                type = 'absolute';
                // CRITICAL FIX: Use theme spacing scale
                value = context.theme.getSpacing(valueKey);
              } else {
                continue;
              }
            }
          }

          if (type == 'factor') {
            if (root == 'w' && widthFactor == null) widthFactor = value;
            if (root == 'h' && heightFactor == null) heightFactor = value;
            if (root == 'max-w' && (value == double.infinity || value == 1.0)) {
              maxWidth ??= double.infinity;
            }
            if (root == 'min-w' && value == 0.0) minWidth ??= 0.0;
          } else {
            if (root == 'w' && width == null) width = value;
            if (root == 'h' && height == null) height = value;
            if (root == 'min-w' && minWidth == null) minWidth = value;
            if (root == 'max-w' && maxWidth == null) maxWidth = value;
            if (root == 'min-h' && minHeight == null) minHeight = value;
            if (root == 'max-h' && maxHeight == null) maxHeight = value;
          }
        }
      }
    }

    final didChange = width != null ||
        height != null ||
        widthFactor != null ||
        heightFactor != null ||
        minWidth != null ||
        maxWidth != null ||
        minHeight != null ||
        maxHeight != null;

    if (!didChange) {
      return styles;
    }

    final constraintsChanged = minWidth != null ||
        maxWidth != null ||
        minHeight != null ||
        maxHeight != null;

    if (constraintsChanged) {
      final newConstraints =
          (styles.constraints ?? const BoxConstraints()).copyWith(
        minWidth: minWidth,
        maxWidth: maxWidth,
        minHeight: minHeight,
        maxHeight: maxHeight,
      );

      return styles.copyWith(
        width: width,
        height: height,
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        constraints: newConstraints,
      );
    }

    return styles.copyWith(
      width: width,
      height: height,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
    );
  }

  /// Checks if the parser can parse the given class name
  ///
  /// Example: w-10, h-20, max-w-30, max-h-40, min-w-50, min-h-60
  @override
  bool canParse(String className) {
    return className.startsWith('w-') ||
        className.startsWith('h-') ||
        className.startsWith('max-w-') ||
        className.startsWith('max-h-') ||
        className.startsWith('min-w-') ||
        className.startsWith('min-h-');
  }
}
