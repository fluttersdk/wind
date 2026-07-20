import '../wind_context.dart';
import '../wind_style.dart';
import 'wind_parser_interface.dart';

/// **The Position Parser**
///
/// Handles CSS positioning utility classes. Prefixes (like `hover:`, `md:`, `dark:`)
/// are resolved by the core parser before being passed to this parser.
///
/// ### Supported Utility Classes:
/// - **Position Type:** `relative`, `absolute` (applied), `fixed`, `sticky` (claimed but ignored)
/// - **Top:** `top-{value}`, `-top-{value}`
/// - **Right:** `right-{value}`, `-right-{value}`
/// - **Bottom:** `bottom-{value}`, `-bottom-{value}`
/// - **Left:** `left-{value}`, `-left-{value}`
/// - **Inset (All Sides):** `inset-{value}`, `-inset-{value}`
/// - **Inset Horizontal:** `inset-x-{value}`, `-inset-x-{value}`
/// - **Inset Vertical:** `inset-y-{value}`, `-inset-y-{value}`
///
/// ### Values:
/// - **Theme Scale:** `top-4`, `inset-x-2` (resolves via `WindThemeData.getSpacing`)
/// - **Arbitrary Values:** `top-[24px]`, `left-[12px]` (supports px suffix only; `%` is unsupported)
///
/// Returns a [WindStyle] with resolved position properties using "Last Class Wins" logic.
class PositionParser implements WindParserInterface {
  const PositionParser();

  /// Position type keywords
  static const _positionTypes = {'relative', 'absolute', 'fixed', 'sticky'};

  /// Regex for theme-based offset classes
  /// e.g., top-4, inset-x-2, -bottom-8
  static final _themeOffsetRegex = RegExp(
    r'^-?(?<root>top|bottom|left|right|inset-x|inset-y|inset)-(?<value>[a-zA-Z0-9./]+)$',
  );

  /// Regex for arbitrary offset classes
  /// e.g., top-[24px], left-[12px], -inset-[10px]
  /// Note: percentage values (e.g., left-[50%]) are intentionally unsupported:
  /// Flutter's Positioned uses logical pixels, not percentages.
  static final _arbitraryOffsetRegex = RegExp(
    r'^-?(?<root>top|bottom|left|right|inset-x|inset-y|inset)-\[(?<value>[0-9.]+(?:px)?)\]$',
  );

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
    WindPositionType? positionType;
    double? pTop;
    double? pRight;
    double? pBottom;
    double? pLeft;

    for (var i = classes.length - 1; i >= 0; i--) {
      final className = classes[i];

      // 1. Position type keywords
      if (_positionTypes.contains(className)) {
        if (positionType == null) {
          // Only relative and absolute produce a style change
          if (className == 'relative') {
            positionType = WindPositionType.relative;
          } else if (className == 'absolute') {
            positionType = WindPositionType.absolute;
          }
          // fixed/sticky are claimed but ignored, no style change
        }
        continue;
      }

      // Detect negative prefix
      final isNegative = className.startsWith('-');

      double? value;
      String? root;

      // 2. Arbitrary Values (e.g., top-[24px], left-[12px])
      final arbitraryMatch = _arbitraryOffsetRegex.firstMatch(className);
      if (arbitraryMatch != null) {
        root = arbitraryMatch.namedGroup('root')!;
        final valueStr = arbitraryMatch.namedGroup('value')!;
        value = double.tryParse(valueStr.replaceAll('px', ''));
      }

      // 3. Theme Values (e.g., top-4, inset-x-2)
      if (value == null) {
        final themeMatch = _themeOffsetRegex.firstMatch(className);
        if (themeMatch != null) {
          root = themeMatch.namedGroup('root')!;
          final valueKey = themeMatch.namedGroup('value')!;
          // Use `tryGetSpacing` so an unknown token (e.g. `top-abc`) is
          // dropped by the null-guard below rather than throwing at build.
          value = theme.tryGetSpacing(valueKey);
        }
      }

      if (value == null || root == null) continue;

      // Apply negative sign
      if (isNegative) {
        value = -value;
      }

      // Apply "Last Class Wins" logic (only set if null)
      switch (root) {
        case 'top':
          pTop ??= value;
          break;
        case 'bottom':
          pBottom ??= value;
          break;
        case 'left':
          pLeft ??= value;
          break;
        case 'right':
          pRight ??= value;
          break;
        case 'inset':
          pTop ??= value;
          pRight ??= value;
          pBottom ??= value;
          pLeft ??= value;
          break;
        case 'inset-x':
          pLeft ??= value;
          pRight ??= value;
          break;
        case 'inset-y':
          pTop ??= value;
          pBottom ??= value;
          break;
      }
    }

    final bool didChange = positionType != null ||
        pTop != null ||
        pRight != null ||
        pBottom != null ||
        pLeft != null;

    if (!didChange) {
      return styles;
    }

    return styles.copyWith(
      positionType: positionType,
      positionTop: pTop,
      positionRight: pRight,
      positionBottom: pBottom,
      positionLeft: pLeft,
    );
  }

  @override
  bool canParse(String className) {
    if (_positionTypes.contains(className)) return true;

    return className.startsWith('top-') ||
        className.startsWith('bottom-') ||
        className.startsWith('left-') ||
        className.startsWith('right-') ||
        className.startsWith('inset-') ||
        className.startsWith('-top-') ||
        className.startsWith('-bottom-') ||
        className.startsWith('-left-') ||
        className.startsWith('-right-') ||
        className.startsWith('-inset-');
  }
}
