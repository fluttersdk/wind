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

  /// Ring width map
  static const Map<String, double> _ringWidthMap = {
    '0': 0,
    '1': 1,
    '2': 2,
    '': 3, // 'ring' without number = 3px
    '4': 4,
    '8': 8,
  };

  /// Ring offset map
  static const Map<String, double> _ringOffsetMap = {
    '0': 0,
    '1': 1,
    '2': 2,
    '4': 4,
    '8': 8,
  };

  /// Regex for ring width: ring, ring-0, ring-1, ring-2, ring-4, ring-8
  static final RegExp _ringWidthRegex = RegExp(r'^ring(?:-([0-8]))?$');

  /// Regex for ring color: ring-red-500, ring-blue-300, ring-red-500/50
  static final RegExp _ringColorRegex = RegExp(
    r'^ring-(?<color>[a-zA-Z]+)(?:-(?<shade>[0-9]+))?(?:/(?:(?<opacity>[0-9]+)|\[(?<arbitraryOpacity>[0-9.]+)\]))?$',
  );

  /// Regex for arbitrary ring color: ring-[#ff0000], ring-[#ff0000]/50
  static final RegExp _ringArbitraryColorRegex = RegExp(
    r'^ring-\[(?<value>#[0-9a-fA-F]{3,8})\](?:/(?:(?<opacity>[0-9]+)|\[(?<arbitraryOpacity>[0-9.]+)\]))?$',
  );

  /// Regex for ring offset: ring-offset-0, ring-offset-2
  static final RegExp _ringOffsetRegex = RegExp(r'^ring-offset-([0-8])$');

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
          ringOffset = _ringOffsetMap[offsetMatch.group(1)] ?? 0;
          continue;
        }
      }

      // Parse ring width: ring, ring-2
      if (ringWidth == null) {
        final widthMatch = _ringWidthRegex.firstMatch(className);
        if (widthMatch != null) {
          final widthValue = widthMatch.group(1) ?? '';
          ringWidth = _ringWidthMap[widthValue] ?? _defaultRingWidth;
          continue;
        }
      }

      // Parse arbitrary ring color: ring-[#ff0000], ring-[#ff0000]/50
      if (ringColor == null) {
        final arbitraryMatch = _ringArbitraryColorRegex.firstMatch(className);
        if (arbitraryMatch != null) {
          Color parsedColor = hexToColor(arbitraryMatch.namedGroup('value')!);
          // Apply opacity if specified
          double opacity = 1.0;
          if (arbitraryMatch.namedGroup('opacity') != null) {
            final opacityInt = int.parse(arbitraryMatch.namedGroup('opacity')!);
            opacity = opacityInt / 100.0;
          } else if (arbitraryMatch.namedGroup('arbitraryOpacity') != null) {
            opacity =
                double.tryParse(
                  arbitraryMatch.namedGroup('arbitraryOpacity')!,
                ) ??
                1.0;
          }
          if (opacity < 1.0) {
            parsedColor = parsedColor.withValues(
              alpha: opacity.clamp(0.0, 1.0),
            );
          }
          ringColor = parsedColor;
          continue;
        }
      }

      // Parse ring color: ring-blue-500
      if (ringColor == null) {
        final colorMatch = _ringColorRegex.firstMatch(className);
        if (colorMatch != null) {
          final colorName = colorMatch.namedGroup('color')!;
          final shade = colorMatch.namedGroup('shade');

          // Skip if it's actually a width class (ring-0, ring-2, etc.)
          if (_ringWidthMap.containsKey(colorName)) continue;
          // Skip if it's offset or inset
          if (colorName == 'offset' || colorName == 'inset') continue;

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
              // Apply opacity if specified
              double opacity = 1.0;
              if (colorMatch.namedGroup('opacity') != null) {
                final opacityInt = int.parse(colorMatch.namedGroup('opacity')!);
                opacity = opacityInt / 100.0;
              } else if (colorMatch.namedGroup('arbitraryOpacity') != null) {
                opacity =
                    double.tryParse(
                      colorMatch.namedGroup('arbitraryOpacity')!,
                    ) ??
                    1.0;
              }
              if (opacity < 1.0) {
                parsedColor = parsedColor.withValues(
                  alpha: opacity.clamp(0.0, 1.0),
                );
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
