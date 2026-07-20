import 'package:flutter/material.dart';

import '../wind_context.dart';
import '../wind_style.dart';
import 'wind_parser_interface.dart';

/// **Padding Parser**
///
/// Handles padding utility classes. Prefixes (like `hover:`, `md:`, `dark:`) are
/// resolved by the core parser before being passed to this parser.
///
/// ### Supported Utility Classes:
/// - **All Sides:** `p-{value}`
/// - **Horizontal Axis:** `px-{value}`
/// - **Vertical Axis:** `py-{value}`
/// - **Specific Sides:** `pt-{value}` (top), `pr-{value}` (right), `pb-{value}` (bottom), `pl-{value}` (left)
///
/// ### Values:
/// - **Theme Scale:** `p-4`, `px-1.5`, `py-1/2` (resolves via `WindThemeData.getSpacing`)
/// - **Arbitrary Values:** `p-[10px]`, `pt-[5]` (supports numeric values with optional `px` suffix)
///
/// Returns a [WindStyle] with resolved `padding` property using "Last Class Wins" logic.
class PaddingParser implements WindParserInterface {
  const PaddingParser();

  /// Regex for theme-based padding classes
  /// e.g., p-4, pt-2, px-1/2
  static final _themePaddingRegex = RegExp(
    r'^(?<root>p|pt|pr|pb|pl|px|py)-(?<value>[a-zA-Z0-9./]+)$',
  );

  /// Regex for arbitrary padding classes
  /// e.g., p-[10px], px-[3.5]
  static final _arbitraryPaddingRegex = RegExp(
    r'^(?<root>p|pt|pr|pb|pl|px|py)-\[(?<value>[0-9.]+(?:px)?)\]$',
  );

  /// Parses padding-related classes and returns updated WindStyle
  ///
  /// Example:
  /// ```dart
  /// final parser = PaddingParser();
  /// final styles = WindStyle();
  /// final classes = ['p-4', 'pt-8']; // 'pt-8' will win for top padding
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
    double? pTop;
    double? pBottom;
    double? pLeft;
    double? pRight;

    for (var i = classes.length - 1; i >= 0; i--) {
      final className = classes[i];
      double? value;
      String? root;

      // 1. Arbitrary Values (e.g., p-[10px])
      final arbitraryMatch = _arbitraryPaddingRegex.firstMatch(className);
      if (arbitraryMatch != null) {
        root = arbitraryMatch.namedGroup('root')!;
        final valueStr = arbitraryMatch.namedGroup('value')!;
        // Padding cannot be a percentage, so we ignore %
        value = double.tryParse(valueStr.replaceAll('px', ''));
      }

      // 2. Theme Values (e.g., p-4, px-1/2)
      final match = _themePaddingRegex.firstMatch(className);
      if (match != null) {
        root = match.namedGroup('root')!;
        final valueKey = match.namedGroup('value')!; // "4", "1/2"

        // Use `tryGetSpacing` so an unknown token (e.g. `p-primary`) is
        // dropped by the null-guard below rather than throwing at build.
        value = theme.tryGetSpacing(valueKey);
      }

      if (value == null || root == null) continue;

      // Apply "Last Class Wins" logic (only set if null)
      switch (root) {
        case 'p':
          pTop ??= value;
          pBottom ??= value;
          pLeft ??= value;
          pRight ??= value;
          break;
        case 'pt':
          pTop ??= value;
          break;
        case 'pb':
          pBottom ??= value;
          break;
        case 'pl':
          pLeft ??= value;
          break;
        case 'pr':
          pRight ??= value;
          break;
        case 'px':
          pLeft ??= value;
          pRight ??= value;
          break;
        case 'py':
          pTop ??= value;
          pBottom ??= value;
          break;
      }
    }

    final bool didChange =
        pTop != null || pBottom != null || pLeft != null || pRight != null;

    if (!didChange) {
      return styles;
    }

    // `copyWith` intelligently merges with existing padding
    return styles.copyWith(
      padding: EdgeInsets.only(
        top: pTop ?? 0.0,
        bottom: pBottom ?? 0.0,
        left: pLeft ?? 0.0,
        right: pRight ?? 0.0,
      ),
    );
  }

  /// Checks if the parser can parse the given class name
  @override
  bool canParse(String className) {
    return className.startsWith('p-') ||
        className.startsWith('pt-') ||
        className.startsWith('pb-') ||
        className.startsWith('pl-') ||
        className.startsWith('pr-') ||
        className.startsWith('px-') ||
        className.startsWith('py-');
  }
}
