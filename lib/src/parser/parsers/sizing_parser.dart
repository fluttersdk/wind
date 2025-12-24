import 'package:flutter/material.dart';

import '../wind_context.dart';
import '../wind_style.dart';
import 'wind_parser_interface.dart';

/// Parser for sizing related classes
///
/// Example classes:
/// - Width: w-10, w-full, w-screen, w-[50%], w-[200px]
/// - Height: h-20, h-full, h-screen, h-[75%], h-[300px]
/// - Max Width: max-w-40, max-w-screen, max-w-[80%], max-w-[400px]
/// - Max Height: max-h-60, max-h-screen, max-h-[90%], max-h-[500px]
/// - Min Width: min-w-15, min-w-[30%], min-w-[150px]
/// - Min Height: min-h-25, min-h-[40%], min-h-[200px]
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
        } else {
          String type = 'absolute';
          double value = 0.0;

          if (valueKey == 'full') {
            type = 'factor';
            value = 1.0;
          } else if (valueKey == 'auto') {
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

    final didChange =
        width != null ||
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

    final constraintsChanged =
        minWidth != null ||
        maxWidth != null ||
        minHeight != null ||
        maxHeight != null;

    if (constraintsChanged) {
      final newConstraints = (styles.constraints ?? const BoxConstraints())
          .copyWith(
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
