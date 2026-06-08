import 'package:flutter/material.dart';

import '../wind_context.dart';
import '../wind_style.dart';
import 'wind_parser_interface.dart';

/// **Layout Parser (Flex & Grid)**
///
/// Handles Flexbox and Grid layout properties. This parser is responsible for
/// translating utility classes into [WindStyle] properties that affect how
/// [WDiv] and other layout-aware widgets arrange their children.
///
/// ### Supported Utility Classes:
/// - **Display:** `flex`, `grid`, `wrap`, `block`, `hidden`
/// - **Direction:** `flex-row`, `flex-col`
/// - **Justify Content:** `justify-start`, `justify-end`, `justify-center`, `justify-between`, `justify-around`, `justify-evenly`
/// - **Align Items:** `items-start`, `items-end`, `items-center`, `items-baseline`, `items-stretch`
/// - **Align Content (Wrap only):** `align-content-start`, `align-content-end`, `align-content-center`, `align-content-between`, `align-content-around`, `align-content-evenly`, `align-content-stretch`
/// - **Gap & Spacing:** `gap-*`, `gap-x-*`, `gap-y-*`, `space-x-*`, `space-y-*` (Supports theme values and arbitrary `-[...]`)
/// - **Flex:** `flex-*` (numeric), `flex-1`, `flex-grow`, `grow`, `grow-0`, `flex-auto`, `flex-initial`, `flex-none`
/// - **Flex Basis:** `basis-1/2`, `basis-1/3`, `basis-1/4`, `basis-full`, `basis-[Npx]` (approximates CSS `flex-basis`: initial MAIN-axis size, ignores grow/shrink interplay)
/// - **Flex Sizing:** `shrink`, `shrink-0`, `flex-shrink`
/// - **Align Self:** `align-self-start`, `align-self-end`, `align-self-center`, `align-self-stretch`, `align-self-auto`
///   plus the Tailwind shorthand `self-start`, `self-end`, `self-center`, `self-stretch`, `self-auto`
/// - **Grid:** `grid-cols-*` (numeric values only)
/// - **Axis Size:** `axis-min`, `axis-max` (Custom Wind utilities)
///
/// ### Prefixes:
/// Prefixes such as `md:`, `hover:`, `dark:`, and `ios:` are resolved by the core parser
/// before classes reach this parser.
///
/// Returns a [WindStyle] affecting layout properties like `mainAxisAlignment`, `crossAxisAlignment`, etc.
class FlexboxGridParser implements WindParserInterface {
  const FlexboxGridParser();

  /// Matches theme-based gap classes (e.g., `gap-4`, `gap-x-2`, `gap-y-1/2`)
  /// Also matches space-x and space-y as aliases (Tailwind's margin-based spacing)
  static final RegExp _themeGapRegex = RegExp(
    r'^(?<root>gap|gap-x|gap-y|space-x|space-y)-(?<value>[a-zA-Z0-9./]+)$',
  );

  /// Matches arbitrary gap classes (e.g., `gap-[10px]`)
  static final RegExp _arbitraryGapRegex = RegExp(
    r'^(?<root>gap|gap-x|gap-y|space-x|space-y)-\[(?<value>[0-9.]+(?:px)?)\]$',
  );

  /// Matches theme-based flex classes (e.g., `flex-1`, `flex-2`)
  static final RegExp _flexValueRegex = RegExp(r'^flex-(?<value>[0-9]+)$');

  /// Matches theme-based grid-cols classes (e.g., `grid-cols-3`)
  static final RegExp _gridColsRegex = RegExp(r'^grid-cols-(?<value>[0-9]+)$');

  /// Matches fractional / full flex-basis classes (e.g., `basis-1/2`,
  /// `basis-1/3`, `basis-full`). The value is the MAIN-axis basis factor.
  static final RegExp _basisFactorRegex = RegExp(
    r'^basis-(?<value>[0-9]+/[0-9]+|full)$',
  );

  /// Matches arbitrary fixed flex-basis classes (e.g., `basis-[120px]`). The
  /// value is a fixed MAIN-axis size in logical pixels.
  static final RegExp _basisArbitraryRegex = RegExp(
    r'^basis-\[(?<value>[0-9.]+)(?:px)?\]$',
  );

  // --- Static Lookup Maps (for performance) ---

  /// Maps display classes to `WindDisplayType`
  static const _displayMap = <String, WindDisplayType>{
    'flex': WindDisplayType.flex,
    'grid': WindDisplayType.grid,
    'wrap': WindDisplayType.wrap,
    'block': WindDisplayType.block,
  };

  /// Maps flex-direction classes to `Axis`. The `-reverse` variants set the
  /// same axis but also flip the main-axis order via `flexReverse`.
  static const _directionMap = <String, Axis>{
    'flex-row': Axis.horizontal,
    'flex-col': Axis.vertical,
    'flex-row-reverse': Axis.horizontal,
    'flex-col-reverse': Axis.vertical,
  };

  /// Classes that flip the flex main-axis direction.
  static const _reverseDirections = <String>{
    'flex-row-reverse',
    'flex-col-reverse',
  };

  /// Maps justify-content classes to `MainAxisAlignment`
  static const _justifyMap = <String, MainAxisAlignment>{
    'justify-start': MainAxisAlignment.start,
    'justify-end': MainAxisAlignment.end,
    'justify-center': MainAxisAlignment.center,
    'justify-between': MainAxisAlignment.spaceBetween,
    'justify-around': MainAxisAlignment.spaceAround,
    'justify-evenly': MainAxisAlignment.spaceEvenly,
  };

  /// Maps align-items classes to `CrossAxisAlignment`
  static const _itemsMap = <String, CrossAxisAlignment>{
    'items-start': CrossAxisAlignment.start,
    'items-end': CrossAxisAlignment.end,
    'items-center': CrossAxisAlignment.center,
    'items-baseline': CrossAxisAlignment.baseline,
    'items-stretch': CrossAxisAlignment.stretch,
  };

  /// Maps align-content classes (for `Wrap` only) to `WrapAlignment`
  static const _contentMap = <String, WrapAlignment>{
    'align-content-start': WrapAlignment.start,
    'align-content-end': WrapAlignment.end,
    'align-content-center': WrapAlignment.center,
    'align-content-between': WrapAlignment.spaceBetween,
    'align-content-around': WrapAlignment.spaceAround,
    'align-content-evenly': WrapAlignment.spaceEvenly,
    'align-content-stretch': WrapAlignment.start, // (Flutter's best equivalent)
  };

  /// Maps custom axis-size classes to `MainAxisSize`
  static const _mainAxisSizeMap = <String, MainAxisSize>{
    'axis-min': MainAxisSize.min,
    'axis-max': MainAxisSize.max,
  };

  /// Maps flex child properties to `int`
  static const _flexMap = <String, int>{
    'flex-1': 1,
    'flex-grow': 1, // 'flex-grow' is treated as flex: 1
    'grow': 1, // Tailwind `grow` is the shorthand for `flex-grow` (flex: 1)
  };

  /// Maps flex child properties to `FlexFit`
  static const _flexFitMap = <String, FlexFit>{
    'shrink': FlexFit.loose, // flex-shrink: 1 (can shrink)
    // `shrink-0` and `flex-none` are intentionally absent: they must NOT set a
    // flexFit. A non-null flexFit makes the widget self-wrap in
    // `Flexible(fit: ...)`, which would force a fill (the opposite of a
    // no-shrink token) and assert outside a Flex. CSS `flex-none` is
    // `flex: 0 0 auto` (no grow AND no shrink), so it shares the no-shrink
    // path with `shrink-0`: the "keep intrinsic size, do not shrink" behavior
    // is delivered by `WDiv._hasShrinkZero`, which reads the className and
    // skips the wrap.
    'flex-auto': FlexFit.loose,
    'flex-initial': FlexFit.loose,
    'flex-shrink': FlexFit.loose,
  };

  /// Maps align-self child properties to `Alignment`
  static const _alignSelfMap = <String, Alignment>{
    'align-self-start': Alignment.topCenter,
    'align-self-end': Alignment.bottomCenter,
    'align-self-center': Alignment.center,
    'align-self-stretch': Alignment.center,
    'align-self-auto': Alignment.center,
  };

  /// Parses flexbox and grid related classes and returns updated WindStyle
  ///
  /// This method iterates the list of *active, prefix-less* classes in reverse
  /// to apply the "Last Class Wins" rule for each distinct property.
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
    WindDisplayType? displayType;
    Axis? flexDirection;
    bool? flexReverse;
    MainAxisAlignment? mainAxisAlignment;
    CrossAxisAlignment? crossAxisAlignment;
    WrapAlignment? runAlignment;
    double? gapX;
    double? gapY;
    MainAxisSize? mainAxisSize;
    int? flex;
    FlexFit? flexFit;
    // The flex/flexFit slots can win last-class-wins with a NULL (intrinsic)
    // value via no-grow/no-shrink tokens (`grow-0`, `shrink-0`, `flex-none`),
    // so a plain `flex == null` guard cannot tell "unset" from "explicitly
    // reset". Track resolution separately.
    bool flexResolved = false;
    bool flexFitResolved = false;
    double? basisFactor;
    double? basisSize;
    Alignment? alignment;
    TextBaseline? textBaseline;
    int? gridCols;
    bool? isHidden;
    // Track if visibility has been determined by a later class
    bool visibilitySet = false;

    for (var i = classes.length - 1; i >= 0; i--) {
      final className = classes[i];

      // 0. Hidden check
      if (className == 'hidden') {
        if (!visibilitySet) {
          isHidden = true;
          visibilitySet = true;
        }
        continue;
      }

      // 1. Static Map Lookups (Fastest)
      if (displayType == null && _displayMap.containsKey(className)) {
        displayType = _displayMap[className];
        if (!visibilitySet) {
          isHidden = false;
          visibilitySet = true;
        }
      } else if (flexDirection == null &&
          _directionMap.containsKey(className)) {
        flexDirection = _directionMap[className];
        flexReverse ??= _reverseDirections.contains(className);
      } else if (mainAxisAlignment == null &&
          _justifyMap.containsKey(className)) {
        mainAxisAlignment = _justifyMap[className];
      } else if (crossAxisAlignment == null &&
          _itemsMap.containsKey(className)) {
        crossAxisAlignment = _itemsMap[className];
        // Flutter requires textBaseline when using CrossAxisAlignment.baseline
        if (crossAxisAlignment == CrossAxisAlignment.baseline) {
          textBaseline = TextBaseline.alphabetic;
        }
      } else if (runAlignment == null && _contentMap.containsKey(className)) {
        runAlignment = _contentMap[className];
      } else if (mainAxisSize == null &&
          _mainAxisSizeMap.containsKey(className)) {
        mainAxisSize = _mainAxisSizeMap[className];
      } else if ((!flexResolved || !flexFitResolved) &&
          (className == 'grow-0' ||
              className == 'shrink-0' ||
              className == 'flex-none')) {
        // No-grow / no-shrink tokens take part in last-class-wins by CLAIMING
        // the relevant flex slot with a null (intrinsic) value, so an earlier
        // `grow`/`flex-grow`/`flex-N` or `shrink`/`flex-auto` cannot re-enable
        // an Expanded/Flexible wrap. CSS mapping: `grow-0` = flex-grow:0,
        // `shrink-0` = flex-shrink:0, `flex-none` = flex:0 0 auto (both).
        if (className == 'grow-0' || className == 'flex-none') {
          flexResolved = true;
        }
        if (className == 'shrink-0' || className == 'flex-none') {
          flexFitResolved = true;
        }
      } else if (!flexResolved && _flexMap.containsKey(className)) {
        flex = _flexMap[className];
        flexResolved = true;
      } else if (!flexFitResolved && _flexFitMap.containsKey(className)) {
        flexFit = _flexFitMap[className];
        flexFitResolved = true;
      } else if (alignment == null && _alignSelfMap.containsKey(className)) {
        alignment = _alignSelfMap[className];
      } else if (alignment == null && className.startsWith('self-')) {
        // Tailwind's canonical shorthand `self-*` aliases `align-self-*`.
        // Normalize to the long form so both routes share one mapping
        // (an unmapped token like `self-baseline` resolves to null, exactly
        // as `align-self-baseline` would).
        alignment = _alignSelfMap['align-$className'];
      } else {
        // No match or skipped.
      }
      // 2. RegEx Lookups (Slower)
      // `gap-` (Theme or Arbitrary)
      if (gapX == null || gapY == null) {
        double? value;
        String? root;

        final arbitraryMatch = _arbitraryGapRegex.firstMatch(className);
        if (arbitraryMatch != null) {
          root = arbitraryMatch.namedGroup('root')!;
          value = double.tryParse(
            arbitraryMatch.namedGroup('value')!.replaceAll('px', ''),
          );
        } else {
          final match = _themeGapRegex.firstMatch(className);
          if (match != null) {
            root = match.namedGroup('root')!;
            value = theme.getSpacing(match.namedGroup('value')!);
          }
        }

        if (value != null && root != null) {
          if (root == 'gap') {
            gapX ??= value;
            gapY ??= value;
          } else if (root == 'gap-x' || root == 'space-x') {
            gapX ??= value;
          } else if (root == 'gap-y' || root == 'space-y') {
            gapY ??= value;
          }
        }
      }
      // `flex-2`, `flex-3` etc.
      if (!flexResolved) {
        final match = _flexValueRegex.firstMatch(className);
        if (match != null) {
          flex = int.tryParse(match.namedGroup('value')!);
          flexResolved = true;
        }
      }
      // `grid-cols-3`, `grid-cols-6` etc.
      if (gridCols == null) {
        final match = _gridColsRegex.firstMatch(className);
        if (match != null) {
          gridCols = int.tryParse(match.namedGroup('value')!);
        } else {}
      }
      // `basis-1/2`, `basis-full` (fractional) and `basis-[120px]` (fixed).
      // Arbitrary precedes the theme/fraction form per the parser convention.
      if (basisFactor == null && basisSize == null) {
        final arbitraryMatch = _basisArbitraryRegex.firstMatch(className);
        if (arbitraryMatch != null) {
          basisSize = double.tryParse(arbitraryMatch.namedGroup('value')!);
        } else {
          final match = _basisFactorRegex.firstMatch(className);
          if (match != null) {
            final value = match.namedGroup('value')!;
            if (value == 'full') {
              basisFactor = 1.0;
            } else {
              final parts = value.split('/');
              final numerator = double.tryParse(parts[0]);
              final denominator = double.tryParse(parts[1]);
              if (numerator != null &&
                  denominator != null &&
                  denominator != 0) {
                basisFactor = numerator / denominator;
              }
            }
          }
        }
      }
    }

    final bool didChange = displayType != null ||
        flexDirection != null ||
        flexReverse != null ||
        mainAxisAlignment != null ||
        crossAxisAlignment != null ||
        runAlignment != null ||
        gapX != null ||
        gapY != null ||
        mainAxisSize != null ||
        flex != null ||
        flexFit != null ||
        basisFactor != null ||
        basisSize != null ||
        alignment != null ||
        textBaseline != null ||
        gridCols != null ||
        isHidden != null;

    if (!didChange) {
      return styles;
    }

    // 3. Apply changes to WindStyle
    return styles.copyWith(
      displayType: displayType,
      flexDirection: flexDirection,
      flexReverse: flexReverse,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      runAlignment: runAlignment,
      gapX: gapX,
      gapY: gapY,
      mainAxisSize: mainAxisSize,
      flex: flex,
      flexFit: flexFit,
      basisFactor: basisFactor,
      basisSize: basisSize,
      alignment: alignment,
      textBaseline: textBaseline,
      gridCols: gridCols,
      isHidden: isHidden,
    );
  }

  @override
  bool canParse(String className) {
    // This 'Specialist' casts a wide net to catch all
    // classes related to flexbox and grid.
    return className == 'flex' ||
        className == 'grid' ||
        className == 'wrap' ||
        className == 'block' ||
        className == 'hidden' ||
        className == 'shrink' ||
        className == 'shrink-0' ||
        className == 'grow' ||
        className == 'grow-0' ||
        className.startsWith('basis-') ||
        className.startsWith('flex-') ||
        className.startsWith('grid-') ||
        className.startsWith('justify-') ||
        className.startsWith('items-') ||
        className.startsWith('align-') ||
        className.startsWith('self-') ||
        className.startsWith('gap-') ||
        className.startsWith('space-x-') ||
        className.startsWith('space-y-') ||
        className.startsWith('axis-') ||
        className.startsWith('place-');
  }
}
