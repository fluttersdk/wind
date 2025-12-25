import 'package:flutter/material.dart';
import '../../utils/color_utils.dart';
import '../wind_context.dart';
import '../wind_style.dart';
import 'wind_parser_interface.dart';

/// Parser for ring utility classes (focus rings)
///
/// Ring is implemented as a BoxShadow with spreadRadius only (no blur),
/// similar to Tailwind CSS's ring utility.
///
/// Example classes:
/// - ring          (default 3px ring)
/// - ring-0, ring-1, ring-2, ring-4, ring-8 (ring widths)
/// - ring-{color}-{shade} (ring color)
/// - ring-offset-{n} (offset between ring and element)
/// - ring-inset (inner ring)
class RingParser implements WindParserInterface {
  const RingParser();

  /// Default ring width in pixels
  static const double _defaultRingWidth = 3.0;

  /// Regex for ring width: ring, ring-0, ring-custom
  static final RegExp _ringWidthRegex = RegExp(r'^ring(?:-(.+))?$');

  /// Regex for ring color: ring-red-500, ring-blue-300
  static final RegExp _ringColorRegex = RegExp(
    r'^ring-(?<color>[a-zA-Z]+)(?:-(?<shade>[0-9]+))?$',
  );

  /// Regex for arbitrary ring color: ring-[#ff0000]
  static final RegExp _ringArbitraryColorRegex = RegExp(
    r'^ring-\[(?<value>#[0-9a-fA-F]{3,8})\]$',
  );

  /// Regex for ring offset: ring-offset-0, ring-offset-2
  static final RegExp _ringOffsetRegex = RegExp(r'^ring-offset-(.+)$');

  /// Regex for ring-inset
  static final RegExp _ringInsetRegex = RegExp(r'^ring-inset$');

  @override
  bool canParse(String className) {
    return className.startsWith('ring');
  }

  @override
  WindStyle parse(
    WindStyle styles,
    List<String>? classes,
    WindContext context,
  ) {
    if (classes == null || classes.isEmpty) return styles;

    double? ringWidth;
    Color? ringColor;
    double? ringOffset;
    bool? ringInset;

    // Reverse iteration for "last class wins"
    for (var i = classes.length - 1; i >= 0; i--) {
      final className = classes[i];

      // Parse ring-inset
      if (ringInset == null && _ringInsetRegex.hasMatch(className)) {
        ringInset = true;
        continue;
      }

      // Parse ring offset: ring-offset-2
      if (ringOffset == null) {
        final offsetMatch = _ringOffsetRegex.firstMatch(className);
        if (offsetMatch != null) {
          final offsetValue = offsetMatch.group(1)!;
          if (context.theme.ringOffsets.containsKey(offsetValue)) {
            ringOffset = context.theme.ringOffsets[offsetValue];
            continue;
          }
        }
      }

      // Parse ring width: ring, ring-2
      if (ringWidth == null) {
        final widthMatch = _ringWidthRegex.firstMatch(className);
        if (widthMatch != null) {
          final widthValue = widthMatch.group(1) ?? 'DEFAULT';
          if (context.theme.ringWidths.containsKey(widthValue)) {
            ringWidth = context.theme.ringWidths[widthValue];
            continue;
          }
        }
      }

      // Check for opacity syntax first
      final opacityData = parseColorOpacity(className);
      final effectiveClassName = opacityData.colorPart;
      final opacity = opacityData.opacity;

      // Parse arbitrary ring color: ring-[#ff0000]
      if (ringColor == null) {
        final arbitraryMatch = _ringArbitraryColorRegex.firstMatch(
          effectiveClassName,
        );
        if (arbitraryMatch != null) {
          Color parsedColor = hexToColor(arbitraryMatch.namedGroup('value')!);

          if (opacity != null) {
            parsedColor = applyOpacity(parsedColor, opacity);
          }
          ringColor = parsedColor;
          continue;
        }
      }

      // Parse ring color: ring-blue-500
      if (ringColor == null) {
        final colorMatch = _ringColorRegex.firstMatch(effectiveClassName);
        if (colorMatch != null) {
          final colorName = colorMatch.namedGroup('color')!;
          final shade = colorMatch.namedGroup('shade');

          // Skip if it is a defined ring offset
          if (colorName == 'offset') continue;

          // Skip if it is a defined ring inset
          if (colorName == 'inset') continue;

          // Note: Width collision check is handled implicitly.
          // Because width regex is wider (ring-(.+)), widths were checked above.
          // If we are here, it means it wasn't a valid ring width known to theme.
          // But wait, what if "ring-red" is both a theme key and a color?
          // Theme keys usually are numbers. Colors are names.
          // If user names a ring width "red", it will be consumed by width parser above.
          // So "ring-red" would set width, not color. This is acceptable/expected conflict resolution.

          if (context.theme.colors.containsKey(colorName)) {
            Color? parsedColor;
            if (shade != null) {
              final shadeValue = int.tryParse(shade);
              if (shadeValue != null &&
                  context.theme.colors[colorName]![shadeValue] != null) {
                parsedColor = context.theme.colors[colorName]![shadeValue];
              }
            } else {
              // Handle basic colors
              if (colorName == 'white') {
                parsedColor = Colors.white;
              } else if (colorName == 'black') {
                parsedColor = Colors.black;
              }
            }

            if (parsedColor != null) {
              if (opacity != null) {
                parsedColor = applyOpacity(parsedColor, opacity);
              }
              ringColor = parsedColor;
            }
          }
        }
      }
    }

    // If no ring classes found, return unchanged
    if (ringWidth == null &&
        ringColor == null &&
        ringOffset == null &&
        ringInset == null) {
      return styles;
    }

    // Build ring shadow
    final width = ringWidth ?? _defaultRingWidth;
    final color = ringColor ?? context.theme.ringColor;
    final offset = ringOffset ?? 0.0;
    final inset = ringInset ?? false;

    // Ring is a box shadow with spread radius only
    // For offset, we add a transparent shadow first
    List<BoxShadow> ringShadows = [];

    if (offset > 0 && !inset) {
      // Offset ring: first add transparent (or bg color) shadow, then ring
      ringShadows.add(
        BoxShadow(color: Colors.transparent, spreadRadius: offset, blurRadius: 0),
      );
    }

    ringShadows.add(
      BoxShadow(
        color: color,
        spreadRadius: inset ? -width : (offset + width),
        blurRadius: 0,
      ),
    );

    return styles.copyWith(
      ringShadow: ringShadows,
      ringColor: color,
      ringWidth: width,
      ringOffset: offset,
      ringInset: inset,
    );
  }
}
