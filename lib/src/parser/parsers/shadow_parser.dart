import 'package:flutter/material.dart';
import '../../theme/defaults/box_shadows.dart';
import '../wind_context.dart';
import '../wind_style.dart';
import '../../utils/color_utils.dart';
import 'wind_parser_interface.dart';

/// Parser for shadow related classes
///
/// Example classes:
/// - shadow-sm
/// - shadow
/// - shadow-md
/// - shadow-lg
/// - shadow-xl
/// - shadow-2xl
/// - shadow-none
/// - shadow-red-500
class ShadowParser implements WindParserInterface {
  const ShadowParser();

  static final RegExp _shadowColorRegExp = RegExp(
    r'^shadow-(?<color>[a-zA-Z]+)(?:-(?<shade>[0-9]+))?(?:/(?:(?<opacity>[0-9]+)|\[(?<arbitraryOpacity>[0-9.]+)\]))?$',
  );

  static final RegExp _arbitraryShadowColorRegExp = RegExp(
    r'^shadow-\[(?<value>#[0-9a-fA-F]{3,8})\](?:/(?:(?<opacity>[0-9]+)|\[(?<arbitraryOpacity>[0-9.]+)\]))?$',
  );

  @override
  bool canParse(String className) {
    if (className.startsWith('shadow-')) return true;
    return className == 'shadow';
  }

  @override
  WindStyle parse(WindStyle style, List<String>? classes, WindContext context) {
    if (classes == null) return style;

    List<BoxShadow>? boxShadow;
    Color? shadowColor;

    for (var i = classes.length - 1; i >= 0; i--) {
      final className = classes[i];

      // Handle simple shadow sizes
      if (className == 'shadow') {
        boxShadow ??= WindBoxShadows.shadows['DEFAULT'];
        continue;
      }

      // Handle specific sizes e.g. shadow-lg
      if (WindBoxShadows.shadows.containsKey(
        className.replaceFirst('shadow-', ''),
      )) {
        boxShadow ??=
            WindBoxShadows.shadows[className.replaceFirst('shadow-', '')];
        continue;
      }

      // Handle arbitrary shadow color e.g. shadow-[#ff0000], shadow-[#ff0000]/50
      final arbitraryMatch = _arbitraryShadowColorRegExp.firstMatch(className);
      if (arbitraryMatch != null) {
        if (shadowColor == null) {
          final value = arbitraryMatch.namedGroup('value')!;
          Color parsedColor = hexToColor(value);
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
          shadowColor = parsedColor;
        }
        continue;
      }

      // Handle standard shadow color e.g. shadow-red-500
      final colorMatch = _shadowColorRegExp.firstMatch(className);
      if (colorMatch != null &&
          !WindBoxShadows.shadows.containsKey(
            className.replaceFirst('shadow-', ''),
          )) {
        if (shadowColor == null) {
          final colorName = colorMatch.namedGroup('color')!;
          final shade = colorMatch.namedGroup('shade');

          if (context.theme.colors.containsKey(colorName)) {
            Color? parsedColor;
            if (shade != null) {
              final shadeValue = int.tryParse(shade);
              if (shadeValue != null &&
                  context.theme.colors[colorName]![shadeValue] != null) {
                parsedColor = context.theme.colors[colorName]![shadeValue];
              }
            } else {
              // Default color if no shade provided
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
              shadowColor = parsedColor;
            }
          }
        }
      }
    }

    // Apply color modification to shadows if needed
    if (boxShadow != null && shadowColor != null) {
      boxShadow = boxShadow
          .map(
            (s) => BoxShadow(
              color: _applyColorWithOpacity(
                shadowColor!,
                s.color.a,
              ), // Preserve original opacity relative to color? Or override?
              // Tailwind behavior: shadow-{color} sets the shadow color.
              // We maintain the original shadow opacity hierarchy by applying
              // the original alpha to the new color.
              offset: s.offset,
              blurRadius: s.blurRadius,
              spreadRadius: s.spreadRadius,
            ),
          )
          .toList();
    }

    return style.copyWith(boxShadow: boxShadow, shadowColor: shadowColor);
  }

  /// Applies the given [opacity] to the alpha channel of [color] while
  /// preserving its RGB components. This is used to tint the existing
  /// shadow with the configured shadow color, maintaining the original
  /// shadow intensity hierarchy.
  Color _applyColorWithOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }
}
