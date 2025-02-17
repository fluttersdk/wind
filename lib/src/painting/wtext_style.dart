import 'package:flutter/material.dart';

import '../helpers.dart';
import '../parsers/font_size_parser.dart';
import '../parsers/font_style.dart';
import '../parsers/font_weight_parser.dart';
import '../parsers/letter_spacing_parser.dart';
import '../parsers/line_height_parser.dart';
import '../parsers/text_color_parser.dart';
import '../parsers/text_decoration_parser.dart';

class WTextStyle extends TextStyle {
  const WTextStyle({
    super.color,
    super.decoration,
    super.decorationColor,
    super.decorationStyle,
    super.decorationThickness,
    super.fontWeight,
    super.fontStyle,
    super.textBaseline,
    super.fontFamily,
    super.fontFamilyFallback,
    super.fontSize,
    super.letterSpacing,
    super.wordSpacing,
    super.height,
    super.leadingDistribution,
    super.locale,
    super.background,
    super.foreground,
    super.shadows,
    super.fontFeatures,
    super.fontVariations,
  });

  TextStyle className(BuildContext context, dynamic className) {
    final parsedClassName = classNameParser(className);

    return super.merge(TextStyle(
      color: TextColorParser.applyColor(context, parsedClassName),
      fontWeight: FontWeightParser.applyFontWeight(context, parsedClassName),
      fontStyle: FontStyleParser.applyFontStyle(context, parsedClassName),
      fontSize: FontSizeParser.applyFontSize(context, parsedClassName),
      height: LineHeightParser.toLineHeight(parsedClassName) ??
          FontSizeParser.applyLineHeight(context, parsedClassName),
      decoration:
          TextDecorationParser.applyDecoration(context, parsedClassName),
      letterSpacing:
          LetterSpacingParser.applyLetterSpacing(context, parsedClassName),
    ));
  }
}
