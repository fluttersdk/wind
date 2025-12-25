import 'package:flutter/material.dart';

import '../wind_context.dart';
import '../wind_style.dart';
import 'wind_parser_interface.dart';

/// Flexbox and Grid parser for Wind styles
///
/// Example classes:
/// - flex, grid
/// - flex-row, flex-col
/// - justify-center, items-start
/// - gap-4, gap-x-2, gap-y-3
/// - flex-1, flex-grow
/// - grid-cols-3
class FlexboxGridParser implements WindParserInterface {
  const FlexboxGridParser();

  /// Matches theme-based gap classes (e.g., `gap-4`, `gap-x-2`, `gap-y-1/2`)
  static final RegExp _themeGapRegex = RegExp(
    r'^(?<root>gap|gap-x|gap-y)-(?<value>[a-zA-Z0-9./]+)$',
  );

  /// Matches arbitrary gap classes (e.g., `gap-[10px]`)
  static final RegExp _arbitraryGapRegex = RegExp(
    r'^(?<root>gap|gap-x|gap-y)-\[(?<value>[0-9.]+(?:px)?)\]$',
  );

  /// Matches theme-based flex classes (e.g., `flex-1`, `flex-2`)
  static final RegExp _flexValueRegex = RegExp(r'^flex-(?<value>[0-9]+)$');

  /// Matches theme-based grid-cols classes (e.g., `grid-cols-3`)
  static final RegExp _gridColsRegex = RegExp(r'^grid-cols-(?<value>[0-9]+)$');

  // --- Static Lookup Maps (for performance) ---

  /// Maps display classes to `WindDisplayType`
  static const _displayMap = <String, WindDisplayType>{
    'flex': WindDisplayType.flex,
    'grid': WindDisplayType.grid,
    'wrap': WindDisplayType.wrap,
    'block': WindDisplayType.block,
  };

  /// Maps flex-direction classes to `Axis`
  static const _directionMap = <String, Axis>{
    'flex-row': Axis.horizontal,
    'flex-col': Axis.vertical,
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
  };

  /// Maps flex child properties to `FlexFit`
  static const _flexFitMap = <String, FlexFit>{
    'flex-auto': FlexFit.loose,
    'flex-initial': FlexFit.loose,
    'flex-shrink': FlexFit.loose,
    'flex-none': FlexFit.loose,
  };

  /// Maps align-self child properties to `Alignment`
  static const _alignSelfMap = <String, Alignment>{
    'align-self-start': Alignment.topCenter,
    // (Start of cross-axis)
    'align-self-end': Alignment.bottomCenter,
    // (End of cross-axis)
    'align-self-center': Alignment.center,
    'align-self-stretch': Alignment.center,
    // (No direct equivalent, center is safe)
    'align-self-auto': Alignment.center,
    // (Default)
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
    MainAxisAlignment? mainAxisAlignment;
    CrossAxisAlignment? crossAxisAlignment;
    WrapAlignment? runAlignment;
    double? gapX;
    double? gapY;
    MainAxisSize? mainAxisSize;
    int? flex;
    FlexFit? flexFit;
    Alignment? alignment;
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
      } else if (mainAxisAlignment == null &&
          _justifyMap.containsKey(className)) {
        mainAxisAlignment = _justifyMap[className];
      } else if (crossAxisAlignment == null &&
          _itemsMap.containsKey(className)) {
        crossAxisAlignment = _itemsMap[className];
      } else if (runAlignment == null && _contentMap.containsKey(className)) {
        runAlignment = _contentMap[className];
      } else if (mainAxisSize == null &&
          _mainAxisSizeMap.containsKey(className)) {
        mainAxisSize = _mainAxisSizeMap[className];
      } else if (flex == null && _flexMap.containsKey(className)) {
        flex = _flexMap[className];
      } else if (flexFit == null && _flexFitMap.containsKey(className)) {
        flexFit = _flexFitMap[className];
      } else if (alignment == null && _alignSelfMap.containsKey(className)) {
        alignment = _alignSelfMap[className];
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
          } else if (root == 'gap-x') {
            gapX ??= value;
          } else if (root == 'gap-y') {
            gapY ??= value;
          }
        }
      }
      // `flex-2`, `flex-3` etc.
      if (flex == null) {
        final match = _flexValueRegex.firstMatch(className);
        if (match != null) {
          flex = int.tryParse(match.namedGroup('value')!);
        }
      }
      // `grid-cols-3`, `grid-cols-6` etc.
      if (gridCols == null) {
        final match = _gridColsRegex.firstMatch(className);
        if (match != null) {
          gridCols = int.tryParse(match.namedGroup('value')!);
        } else {}
      }
    }

    final bool didChange =
        displayType != null ||
        flexDirection != null ||
        mainAxisAlignment != null ||
        crossAxisAlignment != null ||
        runAlignment != null ||
        gapX != null ||
        gapY != null ||
        mainAxisSize != null ||
        flex != null ||
        flexFit != null ||
        alignment != null ||
        gridCols != null ||
        isHidden != null;

    if (!didChange) {
      return styles;
    }

    // 3. Apply changes to WindStyle
    return styles.copyWith(
      displayType: displayType,
      flexDirection: flexDirection,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      runAlignment: runAlignment,
      gapX: gapX,
      gapY: gapY,
      mainAxisSize: mainAxisSize,
      flex: flex,
      flexFit: flexFit,
      alignment: alignment,
      gridCols: gridCols,
      isHidden: isHidden,
    );
  }

  /// Checks if the parser can parse the given class name
  /// This is used by `WindParser` to group classes.
  @override
  bool canParse(String className) {
    // This 'Specialist' casts a wide net to catch all
    // classes related to flexbox and grid.
    return className == 'flex' ||
        className == 'grid' ||
        className == 'wrap' ||
        className == 'block' ||
        className == 'hidden' ||
        className.startsWith('flex-') ||
        className.startsWith('grid-') ||
        className.startsWith('justify-') ||
        className.startsWith('items-') ||
        className.startsWith('align-') ||
        className.startsWith('gap-') ||
        className.startsWith('axis-') ||
        className.startsWith('place-');
  }
}
