import 'package:flutter/material.dart';
import '../../theme/defaults/box_shadows.dart';
import '../wind_context.dart';
import '../wind_style.dart';
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
    r'^shadow-\[(?<value>#[0-9a-fA-F]{3,6})\]$',
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

      // Handle arbitrary shadow color e.g. shadow-[#ff0000]
      final arbitraryMatch = _arbitraryShadowColorRegExp.firstMatch(className);
      if (arbitraryMatch != null) {
        if (shadowColor == null) {
          final value = arbitraryMatch.namedGroup('value')!;
          shadowColor = _parseHexColor(value);
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
            if (shade != null) {
              final shadeValue = int.tryParse(shade);
              if (shadeValue != null &&
                  context.theme.colors[colorName]![shadeValue] != null) {
                shadowColor = context.theme.colors[colorName]![shadeValue];
              }
            } else {
              // Default color if no shade provided (unlikely for tailwind colors but possible)
              // For standard palette, usually need shade. If basic color like 'black', 'white'
              if (colorName == 'white') shadowColor = Colors.white;
              if (colorName == 'black') shadowColor = Colors.black;
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
              // Tailwind behavior: shadow-red-500 changes the shadow color.
              // But tailwind shadows often have varying opacities in the stack.
              // Usually shadow-{color} sets a CSS variable --tw-shadow-color.
              // The default shadows use rgba(0,0,0, opacity).
              // If we replace the color, we should probably keep the alpha channel of the original shadow definitions
              // effectively tinting them, OR just replace them.
              // Tailwind uses --tw-shadow-colored: 0 10px 15px -3px var(--tw-shadow-color), ...
              // It basically re-defines the shadow stack with the solid color.
              offset: s.offset,
              blurRadius: s.blurRadius,
              spreadRadius: s.spreadRadius,
            ),
          )
          .toList();
    }

    return style.copyWith(boxShadow: boxShadow, shadowColor: shadowColor);
  }

  Color _parseHexColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  Color _applyColorWithOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity); // This might be simplistic.
    // Tailwind's shadow colors usually are solid, but the shadow definition applies opacity.
    // If we simply take shadowColor (e.g. Red) and apply the original shadow's opacity (0.1),
    // We get a faint red shadow. This seems correct for maintaining the intensity hierarchy.
  }
}
