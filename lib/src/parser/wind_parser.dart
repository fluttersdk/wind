import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'parsers/background_parser.dart';
import 'parsers/border_parser.dart';
import 'parsers/margin_parser.dart';
import 'parsers/padding_parser.dart';
import 'parsers/sizing_parser.dart';
import 'parsers/position_parser.dart';
import 'parsers/flexbox_grid_parser.dart';
import 'parsers/order_parser.dart';
import 'parsers/wind_parser_interface.dart';
import 'parsers/text_parser.dart';
import 'parsers/debug_parser.dart';
import 'parsers/shadow_parser.dart';
import 'parsers/opacity_parser.dart';
import 'parsers/zindex_parser.dart';
import 'parsers/overflow_parser.dart';
import 'parsers/aspectratio_parser.dart';
import 'parsers/transition_parser.dart';
import 'parsers/ring_parser.dart';
import 'parsers/svg_parser.dart';
import 'parsers/animation_parser.dart';
import 'parsers/cursor_parser.dart';
import 'alias_expander.dart';
import 'wind_context.dart';
import 'wind_style.dart';

/// **The Core Parsing Engine**
///
/// `WindParser` is responsible for converting utility class strings into
/// structured [WindStyle] objects. It acts as the central orchestrator that:
///
/// 1. **Parses:** Splits className strings and delegates to specialized parsers.
/// 2. **Resolves:** Handles responsive (`md:`), state (`hover:`), dark (`dark:`), and platform (`ios:`) prefixes.
/// 3. **Groups:** Uses first-match-wins strategy to assign classes to appropriate parsers.
/// 4. **Caches:** Memoizes results using context-sensitive cache keys.
///
/// ### Cache Key Composition
///
/// Cache keys are generated from the [WindContext.cacheKey] method and include:
/// - `className` - The input utility string
/// - `activeBreakpoint` - Current responsive breakpoint ('base', 'sm', 'md', etc.)
/// - `brightness` - Theme brightness (light/dark mode)
/// - `platform` - Current platform ('ios', 'android', 'web', etc.)
/// - `activeStates` - Sorted list of active states ('hover', 'focus', custom states)
///
/// ### Prefix Resolution
///
/// The parser resolves prefixed classes through [resolveClasses]:
/// - **Responsive:** `md:bg-blue-500` applies only on medium+ screens
/// - **State:** `hover:text-white` applies only when hovering
/// - **Dark mode:** `dark:bg-gray-900` applies only in dark theme
/// - **Platform:** `ios:rounded-lg` applies only on iOS
/// - **Custom:** `loading:opacity-50` applies when 'loading' state is active
///
/// ### Parser Registration
///
/// Parsers are registered in [_parserMap] with unique keys:
/// ```dart
/// _parserMap = {
///   'background': BackgroundParser(),
///   'border': BorderParser(),
///   // ... other parsers
/// };
/// ```
///
/// Classes are grouped by the first parser that returns `true` from `canParse()`.
/// Multiple classes can be assigned to the same parser and are processed together.
///
/// ### Example Usage:
///
/// ```dart
/// final style = WindParser.parse(
///   "bg-red-500 md:bg-blue-500 hover:bg-green-500",
///   context,
///   states: {'loading'},
/// );
/// ```
class WindParser {
  /// Cache for parsed styles
  static final Map<String, WindStyle> _styleCache = {};

  /// Alias keys already warned about this session (debug-only).
  ///
  /// Both shadow warnings and cycle/cap warnings dedup through this set so a
  /// repeated render of the same offending className logs once, not per frame.
  static final Set<String> _warnedAliases = {};

  /// Map of property names to their respective parsers
  static final Map<String, WindParserInterface> _parserMap = {
    'background': const BackgroundParser(),
    'border': const BorderParser(),
    'sizing': const SizingParser(),
    'padding': const PaddingParser(),
    'margin': const MarginParser(),
    'position': const PositionParser(),
    'order': const OrderParser(),
    'flexbox_grid': const FlexboxGridParser(),
    'text': const TextParser(),
    'debug': const DebugParser(),
    'shadow': const ShadowParser(),
    'opacity': const OpacityParser(),
    'zindex': const ZIndexParser(),
    'overflow': const OverflowParser(),
    'aspectratio': const AspectRatioParser(),
    'transition': const TransitionParser(),
    'ring': const RingParser(),
    'svg': const SvgParser(),
    'animation': const AnimationParser(),
    'cursor': const CursorParser(),
  };

  /// Clears the entire style cache.
  ///
  /// Use this when theme data changes or during testing to force
  /// re-parsing of all cached styles. The cache is automatically
  /// invalidated per unique context, so manual clearing is rarely needed.
  static void clearCache() {
    _styleCache.clear();
    _warnedAliases.clear();
  }

  /// Number of entries currently held in the style cache.
  ///
  /// Useful for tests that verify cache-key behavior (e.g. that inline
  /// render-time props do not create extra cache entries).
  static int get cacheSize => _styleCache.length;

  /// Parses a className string into a [WindStyle] object.
  ///
  /// This is the main entry point for style parsing. It builds a [WindContext]
  /// from the current [BuildContext], generates a cache key, and either returns
  /// a cached result or delegates to [_parseAndCache].
  ///
  /// Parameters:
  /// - [className]: Space-separated utility classes (e.g., "bg-red-500 p-4 hover:bg-blue-500")
  /// - [context]: Flutter BuildContext for accessing theme and media queries
  /// - [baseStyle]: Optional starting style to merge with parsed styles
  /// - [states]: Optional custom states to activate (e.g., {'loading', 'selected'})
  ///
  /// The [states] parameter allows custom state prefixes beyond the built-in
  /// `hover`, `focus`, and `disabled`. For example, passing `{'loading'}` enables
  /// classes like `loading:opacity-50` to apply when that state is active.
  ///
  /// Example:
  /// ```dart
  /// final style = WindParser.parse(
  ///   "bg-white loading:bg-gray-100 loading:opacity-50",
  ///   context,
  ///   states: isLoading ? {'loading'} : null,
  /// );
  /// ```
  static WindStyle parse(
    String className,
    BuildContext context, {
    WindStyle? baseStyle,
    Set<String>? states,
  }) {
    final windContext = WindContext.build(context, states: states);

    // Expand user-defined aliases BEFORE the cache key is computed so the key
    // reflects the resolved tokens: two themes whose alias maps differ for the
    // same raw className produce distinct keys, and every W-widget plus
    // WDynamic shares this central expansion. The expander returns the input
    // unchanged when no aliases are configured, so the hot path is untouched.
    final aliases = windContext.theme.aliases;
    final expanded = expandAliases(
      className,
      aliases,
      // The pure expander stays Flutter-free; the kDebugMode gate and the
      // warn-once dedup live here, in the caller.
      onWarn: kDebugMode ? (message) => _warnAlias(className, message) : null,
    );

    if (kDebugMode) {
      _warnOnShadowedAliases(aliases);
    }

    final cacheKey = windContext.cacheKey(expanded);

    // Cache key is composed from windContext + className only; it does NOT
    // include baseStyle. Reading from or writing into the cache when a caller
    // supplies a non-null baseStyle would either return a stale entry computed
    // against a different baseStyle (or no baseStyle at all), or poison the
    // cache for subsequent default-flag callers. Bypass the cache entirely
    // when baseStyle is provided.
    if (baseStyle == null && _styleCache.containsKey(cacheKey)) {
      return _styleCache[cacheKey]!;
    }

    return _parseAndCache(expanded, windContext, cacheKey, baseStyle);
  }

  /// Emits a debug-only cycle/cap warning, deduped per session.
  ///
  /// Keyed by the offending [className] so a repeated render of the same input
  /// logs once. The diagnostic [message] comes from the alias expander.
  static void _warnAlias(String className, String message) {
    if (_warnedAliases.add('cycle:$className')) {
      debugPrint(message);
    }
  }

  /// Emits a debug-only warning for any alias key that shadows a built-in
  /// token, deduped per session.
  ///
  /// An alias whose key a real parser would `canParse` makes that built-in
  /// token unreachable, so the developer is told once. This walks the alias map
  /// against every parser and is gated behind `kDebugMode` at the call site, so
  /// release builds never run it.
  static void _warnOnShadowedAliases(Map<String, String> aliases) {
    for (final key in aliases.keys) {
      if (!_warnedAliases.add('shadow:$key')) continue;

      final shadowsBuiltIn =
          _parserMap.values.any((parser) => parser.canParse(key));
      if (shadowsBuiltIn) {
        debugPrint(
          "Wind alias '$key' shadows a built-in token; "
          'the built-in is now unreachable.',
        );
      }
    }
  }

  /// Internal method to parse and cache the style.
  /// Assumes the style is not already cached.
  /// Skips the cache write when [baseStyle] is provided (per-call style;
  /// cache slot is reserved for the default-flag path).
  static WindStyle _parseAndCache(
    String className,
    WindContext windContext,
    String cacheKey,
    WindStyle? baseStyle,
  ) {
    final classesByProperty = findAndGroupClasses(className, windContext);
    WindStyle parsedStyle = baseStyle ?? const WindStyle();

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

    // Only cache the default-flag result. When baseStyle is non-null, the
    // computed style is per-call and would pollute the cache for callers
    // using the default flow.
    if (baseStyle == null) {
      _styleCache[cacheKey] = parsedStyle;
    }
    return parsedStyle;
  }

  /// Groups classes by their designated parser using first-match-wins strategy.
  ///
  /// This method splits the className string, resolves prefixed classes through
  /// [resolveClasses], then assigns each class to the first parser that returns
  /// `true` from its `canParse()` method.
  ///
  /// The grouping process:
  /// 1. Split className by whitespace and remove empty strings
  /// 2. Resolve prefixes (responsive, state, dark, platform) via [resolveClasses]
  /// 3. For each resolved class, find the first parser that can handle it
  /// 4. Group classes by parser key for batch processing
  ///
  /// Example:
  /// ```dart
  /// // Input
  /// className: "bg-red-500 text-lg md:bg-blue-500 hover:text-white"
  ///
  /// // After prefix resolution (assuming md breakpoint and not hovering)
  /// resolvedClasses: ["bg-red-500", "text-lg", "bg-blue-500"]
  ///
  /// // Output grouping
  /// {
  ///   "background": ["bg-red-500", "bg-blue-500"],
  ///   "text": ["text-lg"]
  /// }
  /// ```
  static Map<String, List<String>> findAndGroupClasses(
    String? className,
    WindContext windContext,
  ) {
    final Map<String, List<String>> map = {};
    // Preserve duplicates (no .toSet()) so the parser's last-class-wins
    // contract holds for inputs like `top-8 top-4 top-8`, where the final
    // `top-8` must override the intermediate `top-4`. Deduping with a Set
    // would drop the trailing occurrence and pick `top-4` instead.
    final classes =
        className?.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList() ??
            <String>[];
    final resolvedClasses = resolveClasses(classes, windContext);

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

  /// Resolves prefixed classes based on the current [WindContext].
  ///
  /// This method filters classes by evaluating their prefixes against the active
  /// context (breakpoint, states, theme brightness, platform). Only classes whose
  /// prefixes match the current context are returned, with prefixes stripped.
  ///
  /// ### Prefix Types and Resolution:
  ///
  /// **Responsive prefixes** (`sm:`, `md:`, `lg:`, `xl:`, `2xl:`):
  /// - Applied when current breakpoint matches or exceeds the prefix breakpoint
  /// - Example: `md:bg-blue-500` applies on 'md', 'lg', 'xl', '2xl' breakpoints
  ///
  /// **State prefixes** (`hover:`, `focus:`, `disabled:`, custom):
  /// - Applied when the state exists in [WindContext.activeStates]
  /// - Built-in: `hover`, `focus`, `disabled`
  /// - Custom: Any state passed via `states` parameter (e.g., `loading:`, `selected:`)
  ///
  /// **Dark mode prefix** (`dark:`):
  /// - Applied when [WindContext.theme.brightness] is `Brightness.dark`
  ///
  /// **Platform prefixes** (`ios:`, `android:`, `web:`, `mobile:`):
  /// - Applied when [WindContext.platform] or [WindContext.isMobile] matches
  ///
  /// ### Examples:
  ///
  /// ```dart
  /// // Input classes
  /// ["bg-red-500", "md:bg-blue-500", "hover:bg-green-500", "dark:bg-gray-900"]
  ///
  /// // Context: breakpoint='md', not hovering, light mode
  /// // Output: ["bg-red-500", "bg-blue-500"]
  ///
  /// // Context: breakpoint='md', hovering, dark mode
  /// // Output: ["bg-red-500", "bg-blue-500", "bg-green-500", "bg-gray-900"]
  /// ```
  ///
  /// Returns a list of unprefixed class names that apply to the current context.
  static List<String> resolveClasses(
    List<String>? classes,
    WindContext context,
  ) {
    if (classes == null || classes.isEmpty) {
      return [];
    }

    final List<String> applicableClasses = [];

    final activeBreakpoints = ['base'];
    if (context.activeBreakpoint != 'base') {
      bool breakpointReached = false;
      final sortedScreens = context.theme.screens.entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value));

      for (final entry in sortedScreens) {
        if (breakpointReached) break;
        activeBreakpoints.add(entry.key);
        if (entry.key == context.activeBreakpoint) breakpointReached = true;
      }
    }

    for (final cls in classes) {
      final parts = cls.split(':');
      final prefixes =
          parts.length > 1 ? parts.sublist(0, parts.length - 1) : <String>[];

      bool isActive = true;

      for (final prefix in prefixes) {
        // State prefixes (hover, focus, disabled, + custom)
        // All states are now in activeStates set
        if (prefix == 'hover' || prefix == 'focus' || prefix == 'disabled') {
          if (!context.activeStates.contains(prefix)) isActive = false;
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
        } else if (context.activeStates.contains(prefix)) {
          // Custom state is active, do nothing
        } else {
          // Unknown prefix -> not active
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
