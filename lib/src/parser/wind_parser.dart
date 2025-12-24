import 'package:flutter/material.dart';

import 'parsers/background_parser.dart';
import 'parsers/display_parser.dart';
import 'parsers/margin_parser.dart';
import 'parsers/padding_parser.dart';
import 'parsers/sizing_parser.dart';
import 'parsers/flexbox_grid_parser.dart';
import 'parsers/wind_parser_interface.dart';
import 'parsers/text_parser.dart';
import 'wind_context.dart';
import 'wind_style.dart';

/// Main parser class for Wind styles
/// Handles parsing of class names into WindStyle objects
/// with caching and state resolution.
///
/// Example:
/// ```dart
/// final style = WindParser.parse("bg-red-500 text-lg md:bg-blue-500", context);
/// ```
class WindParser {
  /// Cache for parsed styles
  static final Map<String, WindStyle> _styleCache = {};

  /// Map of property names to their respective parsers
  static final Map<String, WindParserInterface> _parserMap = {
    'display': const DisplayParser(),
    'background': const BackgroundParser(),
    'sizing': const SizingParser(),
    'padding': const PaddingParser(),
    'margin': const MarginParser(),
    'flexbox_grid': const FlexboxGridParser(),
    'text': const TextParser(),
  };

  /// Clears the style cache
  static void clearCache() {
    _styleCache.clear();
  }

  /// Parses the given class name into a WindStyle
  /// If a baseStyle is provided, it will be used as the starting point
  /// for the parsed style.
  static WindStyle parse(
    String className,
    BuildContext context, {
    WindStyle? baseStyle = null,
  }) {
    final windContext = WindContext.build(context);
    final cacheKey = windContext.cacheKey(className);

    if (_styleCache.containsKey(cacheKey)) {
      return _styleCache[cacheKey]!;
    }

    return _parseAndCache(className, windContext, cacheKey, baseStyle);
  }

  /// Internal method to parse and cache the style
  /// This method assumes the style is not already cached.
  static WindStyle _parseAndCache(
    String className,
    WindContext windContext,
    String cacheKey,
    WindStyle? baseStyle,
  ) {
    final classesByProperty = findAndGroupClasses(className, windContext);
    WindStyle parsedStyle = baseStyle ?? WindStyle();

    for (final entry in classesByProperty.entries) {
      final property = entry.key;
      final classes = entry.value;

      if (classes.isNotEmpty) {
        final parser = _parserMap[property];
        if (parser != null) {
          parsedStyle = parser.parse(parsedStyle, classes, windContext);

          // The parsed style is hidden, we can stop further parsing
          if (parsedStyle.isHidden) {
            break;
          }
        }
      }
    }

    _styleCache[cacheKey] = parsedStyle;
    return parsedStyle;
  }

  /// Finds and groups classes by the parser that can handle them
  ///
  /// Example:
  /// Input: "bg-red-500 text-lg md:bg-blue-500"
  /// Output: {
  ///   "background": ["bg-red-500", "md:bg-blue-500"],
  ///   "text": ["text-lg"]
  /// }
  static Map<String, List<String>> findAndGroupClasses(
    String? className,
    WindContext windContext,
  ) {
    final Map<String, List<String>> map = {};
    final classes =
        className?.split(' ').where((s) => s.isNotEmpty).toSet() ?? <String>{};
    final resolvedClasses = resolveClasses(classes.toList(), windContext);

    for (final cls in resolvedClasses) {
      for (final entry in _parserMap.entries) {
        final checkClass = cls.contains(':') ? cls.split(':').last : cls;
        if (entry.value.canParse(checkClass)) {
          map.putIfAbsent(entry.key, () => []).add(cls);
          break;
        }
      }
    }

    return map;
  }

  /// Resolves the state based classes and returns the winning class
  /// Removes classes that do not apply based on the current context
  /// and returns the remaining classes without prefixes.
  ///
  /// Example:
  /// Input: ["bg-red-500", "md:bg-blue-500", "hover:bg-green-500"] (if the current breakpoint is "md" and not hovering)
  /// Output: ["bg-red-500", "bg-blue-500"]
  ///
  /// Input: ["bg-red-500", "md:bg-blue-500", "hover:bg-green-500"] (if the current breakpoint is "md" and hovering)
  /// Output: ["bg-red-500", "bg-blue-500", "bg-green-500"]
  static List<String> resolveClasses(
    List<String>? classes,
    WindContext context,
  ) {
    if (classes == null || classes.isEmpty) {
      return [];
    }

    final List<String> applicableClasses = [];

    final activeBreakpoints = ['base'];
    bool breakpointReached = false;
    final sortedScreens = context.theme.screens.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    for (final entry in sortedScreens) {
      if (breakpointReached) break;
      activeBreakpoints.add(entry.key);
      if (entry.key == context.activeBreakpoint) breakpointReached = true;
    }

    for (final cls in classes) {
      final parts = cls.split(':');
      final prefixes = parts.length > 1
          ? parts.sublist(0, parts.length - 1)
          : <String>[];

      bool isActive = true;

      for (final prefix in prefixes) {
        if (prefix == 'hover') {
          if (!context.isHovering) isActive = false;
        } else if (prefix == 'focus') {
          if (!context.isFocused) isActive = false;
        } else if (prefix == 'disabled') {
          if (!context.isDisabled) isActive = false;
        } else if (prefix == context.platform) {
          // platform matches, do nothing
        } else if (prefix == 'mobile' && context.isMobile) {
          // mobile matches, do nothing
        } else if (prefix == 'dark') {
          if (context.theme.brightness != Brightness.dark) isActive = false;
        } else if (context.theme.screens.containsKey(prefix)) {
          if (!activeBreakpoints.contains(prefix)) {
            isActive = false;
          }
        } else {
          isActive = false;
        }
      }

      if (isActive) {
        applicableClasses.add(parts.last);
      }
    }

    return applicableClasses;
  }
}
