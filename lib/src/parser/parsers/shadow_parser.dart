import 'package:flutter/material.dart';

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
    r'^shadow-(?<color>[a-zA-Z]+)(?:-(?<shade>[0-9]+))?$',
  );

  static final RegExp _arbitraryShadowColorRegExp = RegExp(
    r'^shadow-\[(?<value>#[0-9a-fA-F]{3,8})\]$',
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
        boxShadow ??= context.theme.shadows['DEFAULT'];
        continue;
      }

      // Handle specific sizes e.g. shadow-lg
      final sizeName = className.replaceFirst('shadow-', '');
      if (context.theme.shadows.containsKey(sizeName)) {
        boxShadow ??= context.theme.shadows[sizeName];
        continue;
      }

      final opacityData = parseColorOpacity(className);
      final effectiveClassName = opacityData.colorPart;
      final opacity = opacityData.opacity;

      // Handle arbitrary shadow color e.g. shadow-[#ff0000]
      final arbitraryMatch = _arbitraryShadowColorRegExp.firstMatch(
        effectiveClassName,
      );
      if (arbitraryMatch != null) {
        if (shadowColor == null) {
          final value = arbitraryMatch.namedGroup('value')!;
          Color parsedColor = hexToColor(value);

          if (opacity != null) {
            parsedColor = applyOpacity(parsedColor, opacity);
          }
          shadowColor = parsedColor;
        }
        continue;
      }

      // Handle standard shadow color e.g. shadow-red-500
      final colorMatch = _shadowColorRegExp.firstMatch(effectiveClassName);
      if (colorMatch != null &&
          !context.theme.shadows.containsKey(
            effectiveClassName.replaceFirst('shadow-', ''),
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
              if (opacity != null) {
                parsedColor = applyOpacity(parsedColor, opacity);
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
