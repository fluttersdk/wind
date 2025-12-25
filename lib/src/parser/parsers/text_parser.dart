import 'package:flutter/material.dart';

import '../../utils/color_utils.dart';
import '../wind_context.dart';
import '../wind_style.dart';
import 'wind_parser_interface.dart';

/// Parser for typography related classes.
///
/// This parser handles classes related to text styling, including color,
/// alignment, decoration, transformation, overflow, and more.
///
/// Example classes:
/// - Color: `text-red-500`, `text-[#123456]`
/// - Alignment: `text-center`
/// - Font Size: `text-xl`, `text-[20px]`
/// - Font Weight: `font-bold`, `font-[700]`
/// - Font Style: `italic`, `not-italic`
/// - Text Decoration: `underline`, `line-through`
/// - Decoration Color: `decoration-red-500`
/// - Decoration Style: `decoration-solid`
/// - Decoration Thickness: `decoration-2`, `decoration-[3px]`
/// - Text Transform: `uppercase`
/// - Letter Spacing: `tracking-wide`, `tracking-[0.1em]`
/// - Line Height: `leading-loose`, `leading-[24px]`
/// - Text Overflow: `truncate`, `text-ellipsis`
/// - Line Clamp: `line-clamp-2`
/// - Whitespace/Wrap: `whitespace-nowrap`, `text-wrap`
class TextParser implements WindParserInterface {
  const TextParser();

  /// Regex for text color: `text-red-500`, `text-[#123456]`
  static final RegExp _textColorRegex = RegExp(
    r'^text-(?:(?<color>[a-zA-Z]+)(?:-(?<shade>[0-9]{2,3}))?|\[(?<arbitrary>#(?:[0-9a-fA-F]{3}|[0-9a-fA-F]{6}))\])$',
  );

  /// Regex for text alignment: `text-center`
  static final RegExp _textAlignRegex = RegExp(
    r'^text-(?<align>left|right|center|justify|start|end)$',
  );

  /// Regex for font size: `text-xl`, `text-[20px]`
  static final RegExp _fontSizeRegex = RegExp(
    r'^text-(?:(?<size>[a-zA-Z0-9-]+)|\[(?<arbitrary>[0-9.]+(?:px|rem)?)\])(?:/(?:(?<lineHeight>[a-zA-Z0-9.]+)|\[(?<arbitraryLineHeight>[0-9.]+(?:px|rem)?)\]))?$',
  );

  /// Regex for font weight: `font-bold`, `font-[700]`
  static final RegExp _fontWeightRegex = RegExp(
    r'^font-(?:(?<weight>[a-zA-Z0-9-]+)|\[(?<arbitrary>[0-9]+)\])$',
  );

  /// Regex for font style: `italic`, `not-italic`
  static final RegExp _fontStyleRegex = RegExp(
    r'^(?<style>italic|not-italic)$',
  );

  /// Regex for font family: `font-sans`, `font-serif`, `font-mono`, `font-[CustomFont]`
  static final RegExp _fontFamilyRegex = RegExp(
    r'^font-(?:(?<family>sans|serif|mono|[a-zA-Z]+)|\[(?<arbitrary>[^\]]+)\])$',
  );

  /// Regex for text decoration: `underline`, `line-through`
  static final RegExp _textDecorationRegex = RegExp(
    r'^(?<decoration>underline|overline|line-through|no-underline)$',
  );

  /// Regex for decoration color: `decoration-red-500`
  static final RegExp _textDecorationColorRegex = RegExp(
    r'^decoration-(?:(?<color>[a-zA-Z]+)(?:-(?<shade>[0-9]{2,3}))?|\[(?<arbitrary>#(?:[0-9a-fA-F]{3}|[0-9a-fA-F]{6}))\])$',
  );

  /// Regex for decoration style: `decoration-solid`
  static final RegExp _textDecorationStyleRegex = RegExp(
    r'^decoration-(?<style>solid|double|dotted|dashed|wavy)$',
  );

  /// Regex for decoration thickness: `decoration-2`, `decoration-[3px]`
  static final RegExp _textDecorationThicknessRegex = RegExp(
    r'^decoration-(?:(?<value>[0-9]+)|\[(?<arbitrary>[0-9.]+(?:px)?)\])$',
  );

  /// Regex for text transform: `uppercase`
  static final RegExp _textTransformRegex = RegExp(
    r'^(?<transform>uppercase|lowercase|capitalize|normal-case)$',
  );

  /// Regex for letter spacing: `tracking-wide`, `tracking-[0.1em]`
  static final RegExp _letterSpacingRegex = RegExp(
    r'^tracking-(?:(?<value>tighter|tight|normal|wide|wider|widest)|\[(?<arbitrary>[0-9.]+(?:px|em)?)\])$',
  );

  /// Regex for line height: `leading-loose`, `leading-[24px]`
  static final RegExp _lineHeightRegex = RegExp(
    r'^leading-(?:(?<value>none|tight|snug|normal|relaxed|loose|[0-9]+)|\[(?<arbitrary>[0-9.]+(?:px|rem)?)\])$',
  );

  /// Regex for text overflow: `truncate`, `text-ellipsis`
  static final RegExp _textOverflowRegex = RegExp(
    r'^(?:(?<truncate>truncate)|text-(?<overflow>ellipsis|clip))$',
  );

  /// Regex for line clamp: `line-clamp-2`
  static final RegExp _lineClampRegex = RegExp(
    r'^line-clamp-(?<lines>[0-9]+|none)$',
  );

  /// Regex for whitespace/wrap: `whitespace-nowrap`, `text-wrap`
  static final RegExp _textWrapRegex = RegExp(
    r'^(?:whitespace-(?<ws>normal|nowrap)|text-(?<tw>wrap|nowrap|balance))$',
  );

  // --- Static Lookup Maps ---

  static const _textAlignMap = {
    'left': TextAlign.left,
    'right': TextAlign.right,
    'center': TextAlign.center,
    'justify': TextAlign.justify,
    'start': TextAlign.start,
    'end': TextAlign.end,
  };

  static const _textDecorationMap = {
    'underline': TextDecoration.underline,
    'overline': TextDecoration.overline,
    'line-through': TextDecoration.lineThrough,
    'no-underline': TextDecoration.none,
  };

  static const _decorationStyleMap = {
    'solid': TextDecorationStyle.solid,
    'double': TextDecorationStyle.double,
    'dotted': TextDecorationStyle.dotted,
    'dashed': TextDecorationStyle.dashed,
    'wavy': TextDecorationStyle.wavy,
  };

  // Note: WindTextTransform is likely defined in your wind_style.dart
  static const _textTransformMap = {
    'uppercase': WindTextTransform.uppercase,
    'lowercase': WindTextTransform.lowercase,
    'capitalize': WindTextTransform.capitalize,
    'normal-case': WindTextTransform.none,
  };

  @override
  WindStyle parse(
    WindStyle styles,
    List<String>? classes,
    WindContext context,
  ) {
    if (classes == null || classes.isEmpty) return styles;

    final theme = context.theme;

    // Temporary variables to hold parsed values.
    // We iterate in reverse to respect the "Last Class Wins" rule.
    Color? color;
    double? fontSize;
    FontWeight? fontWeight;
    FontStyle? fontStyle;
    double? letterSpacing;
    double? heightLine;
    double? heightLineFactor;
    TextDecoration? textDecoration;
    Color? textDecorationColor;
    TextDecorationStyle? textDecorationStyle;
    double? textDecorationThickness;
    TextAlign? textAlign;
    TextOverflow? textOverflow;
    int? maxLines;
    bool? softWrap;
    WindTextTransform? textTransform;
    String? fontFamily;

    for (var i = classes.length - 1; i >= 0; i--) {
      final className = classes[i];

      // 1. Text Color
      if (color == null) {
        final match = _textColorRegex.firstMatch(className);
        if (match != null) {
          Color? parsedColor;

          if (match.namedGroup('arbitrary') != null) {
            parsedColor = hexToColor(match.namedGroup('arbitrary')!);
          } else {
            final colorName = match.namedGroup('color')!;
            final shade =
                int.tryParse(match.namedGroup('shade') ?? '500') ?? 500;
            parsedColor = theme.getColor(colorName, shade);
          }

          if (parsedColor != null) {
            color = parsedColor;
            continue;
          }
        }
      }

      // 2. Text Align
      if (textAlign == null) {
        final match = _textAlignRegex.firstMatch(className);
        if (match != null) {
          textAlign = _textAlignMap[match.namedGroup('align')];
          continue;
        }
      }

      // 3. Font Size
      if (fontSize == null || heightLine == null) {
        final match = _fontSizeRegex.firstMatch(className);
        if (match != null) {
          if (fontSize == null) {
            if (match.namedGroup('arbitrary') != null) {
              final val = match.namedGroup('arbitrary')!;
              fontSize = double.tryParse(val.replaceAll(RegExp(r'px|rem'), ''));
            } else {
              final sizeKey = match.namedGroup('size')!;
              fontSize = theme.fontSizes[sizeKey];
            }

            if (heightLine == null) {
              double? lhValue;

              if (match.namedGroup('arbitraryLineHeight') != null) {
                final val = match.namedGroup('arbitraryLineHeight')!;
                lhValue = double.tryParse(
                  val.replaceAll(RegExp(r'px|rem'), ''),
                );
              } else if (match.namedGroup('lineHeight') != null) {
                final lhKey = match.namedGroup('lineHeight')!;
                if (double.tryParse(lhKey) != null) {
                  lhValue = theme.getSpacing(lhKey);
                } else {
                  lhValue = theme.leading[lhKey];
                }
              }

              if (lhValue != null && fontSize != null && fontSize > 0) {
                heightLine = lhValue;
                heightLineFactor = null;
              }
            }

            if (fontSize != null) {
              continue;
            }
          }
        }
      }

      // 4. Font Weight
      if (fontWeight == null) {
        final match = _fontWeightRegex.firstMatch(className);
        if (match != null) {
          if (match.namedGroup('arbitrary') != null) {
            final val = match.namedGroup('arbitrary')!;
            int? weightValue = int.tryParse(val);
            if (weightValue != null) {
              final index = (weightValue ~/ 100) - 1;
              if (index >= 0 && index <= 8) {
                fontWeight = FontWeight.values[index];
                continue;
              }
            }
          } else {
            final parsedWeight = theme.fontWeights[match.namedGroup('weight')];
            if (parsedWeight != null) {
              fontWeight = parsedWeight;
              continue;
            }
          }
        }
      }

      // 5. Font Style
      if (fontStyle == null) {
        final match = _fontStyleRegex.firstMatch(className);
        if (match != null) {
          fontStyle = match.namedGroup('style') == 'italic'
              ? FontStyle.italic
              : FontStyle.normal;
          continue;
        }
      }

      // 6. Text Decoration
      if (textDecoration == null) {
        final match = _textDecorationRegex.firstMatch(className);
        if (match != null) {
          textDecoration = _textDecorationMap[match.namedGroup('decoration')];
          continue;
        }
      }

      // 7. Decoration Color
      if (textDecorationColor == null) {
        final match = _textDecorationColorRegex.firstMatch(className);
        if (match != null) {
          Color? parsedColor;

          if (match.namedGroup('arbitrary') != null) {
            parsedColor = hexToColor(match.namedGroup('arbitrary')!);
          } else {
            final colorName = match.namedGroup('color')!;
            final shade =
                int.tryParse(match.namedGroup('shade') ?? '500') ?? 500;
            parsedColor = theme.getColor(colorName, shade);
          }

          if (parsedColor != null) {
            textDecorationColor = parsedColor;
            continue;
          }
        }
      }

      // 8. Decoration Style
      if (textDecorationStyle == null) {
        final match = _textDecorationStyleRegex.firstMatch(className);
        if (match != null) {
          textDecorationStyle = _decorationStyleMap[match.namedGroup('style')];
          continue;
        }
      }

      // 9. Decoration Thickness
      if (textDecorationThickness == null) {
        final match = _textDecorationThicknessRegex.firstMatch(className);
        if (match != null) {
          if (match.namedGroup('arbitrary') != null) {
            final val = match.namedGroup('arbitrary')!;
            textDecorationThickness = double.tryParse(val.replaceAll('px', ''));
          } else {
            final val = match.namedGroup('value');
            if (val != null) {
              textDecorationThickness = double.tryParse(val);
            }
          }

          continue;
        }
      }

      // 10. Text Transform
      if (textTransform == null) {
        final match = _textTransformRegex.firstMatch(className);
        if (match != null) {
          textTransform = _textTransformMap[match.namedGroup('transform')];
          continue;
        }
      }

      // 11. Letter Spacing (Tracking)
      if (letterSpacing == null) {
        final match = _letterSpacingRegex.firstMatch(className);
        if (match != null) {
          double? parsedValue;

          if (match.namedGroup('arbitrary') != null) {
            final val = match.namedGroup('arbitrary')!;
            parsedValue = double.tryParse(val.replaceAll(RegExp(r'px|em'), ''));
          } else {
            final key = match.namedGroup('value')!;
            parsedValue = theme.tracking[key]?.toDouble();
          }

          if (parsedValue != null) {
            letterSpacing = parsedValue;
            continue;
          }
        }
      }

      // 12. Line Height (Leading)
      if (heightLine == null && heightLineFactor == null) {
        final match = _lineHeightRegex.firstMatch(className);
        if (match != null) {
          double? parsedValue;
          double? parsedFactorValue;

          // If it's px arbitrary, you can use `parsedValue`
          // If it's a number or predefined, use `parsedFactorValue`
          if (match.namedGroup('arbitrary') != null) {
            final val = match.namedGroup('arbitrary')!;
            parsedValue = double.tryParse(
              val.replaceAll(RegExp(r'px|rem'), ''),
            );
          } else {
            final val = match.namedGroup('value')!;

            // If it's a number, parse as value by using getSpacing
            final factor = double.tryParse(val);
            if (factor != null) {
              parsedValue = theme.getSpacing(val);
            } else {
              parsedFactorValue = theme.leading[val];
            }
          }

          if (parsedValue != null) {
            heightLine = parsedValue;
            heightLineFactor = null;
            continue;
          } else if (parsedFactorValue != null) {
            heightLineFactor = parsedFactorValue;
            heightLine = null;
            continue;
          }
        }
      }

      // 13. Text Overflow / Truncate
      if (textOverflow == null) {
        final match = _textOverflowRegex.firstMatch(className);
        if (match != null) {
          if (match.namedGroup('truncate') != null) {
            textOverflow = TextOverflow.ellipsis;
            maxLines ??= 1;
            softWrap ??= false;
          } else {
            final overflow = match.namedGroup('overflow');
            textOverflow = overflow == 'ellipsis'
                ? TextOverflow.ellipsis
                : TextOverflow.clip; // 'clip' is default usually
          }
          continue;
        }
      }

      // 14. Whitespace / Wrap
      if (softWrap == null) {
        final match = _textWrapRegex.firstMatch(className);
        if (match != null) {
          final val = match.namedGroup('ws') ?? match.namedGroup('tw');
          if (val == 'nowrap') {
            softWrap = false;
          } else {
            softWrap = true; // normal, wrap, balance
          }
          continue;
        }
      }

      // 15. Line Clamp
      if (maxLines == null) {
        final match = _lineClampRegex.firstMatch(className);
        if (match != null) {
          final val = match.namedGroup('lines')!;
          if (val == 'none') {
            maxLines = null;
          } else {
            maxLines = int.tryParse(val);
            if (maxLines != null) {
              textOverflow ??= TextOverflow.ellipsis;
            }
          }
          continue;
        }
      }

      // 16. Font Family
      if (fontFamily == null) {
        final match = _fontFamilyRegex.firstMatch(className);
        if (match != null) {
          if (match.namedGroup('arbitrary') != null) {
            fontFamily = match.namedGroup('arbitrary')!;
          } else {
            final familyName = match.namedGroup('family')!;
            fontFamily = theme.fontFamilies[familyName] ?? familyName;
          }
          continue;
        }
      }
    }

    return styles.copyWith(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      heightLine: heightLine,
      heightLineFactor: heightLineFactor,
      textDecoration: textDecoration,
      textDecorationColor: textDecorationColor,
      textDecorationStyle: textDecorationStyle,
      textDecorationThickness: textDecorationThickness,
      textAlign: textAlign,
      textOverflow: textOverflow,
      maxLines: maxLines,
      softWrap: softWrap,
      textTransform: textTransform,
      fontFamily: fontFamily,
    );
  }

  @override
  bool canParse(String className) {
    return className.startsWith('text-') ||
        className.startsWith('font-') ||
        className == 'italic' ||
        className == 'not-italic' ||
        className == 'underline' ||
        className == 'overline' ||
        className == 'line-through' ||
        className == 'no-underline' ||
        className.startsWith('decoration-') ||
        className.startsWith('tracking-') ||
        className.startsWith('leading-') ||
        className == 'uppercase' ||
        className == 'lowercase' ||
        className == 'capitalize' ||
        className == 'normal-case' ||
        className == 'truncate' ||
        className.startsWith('line-clamp-') ||
        className.startsWith('whitespace-');
  }
}
