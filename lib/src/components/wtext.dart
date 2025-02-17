import 'package:flutter/cupertino.dart';

import '../helpers.dart';
import '../painting/wtext_style.dart';
import '../parsers/padding_parser.dart';
import '../parsers/text_align_parser.dart';
import '../parsers/text_transform_parser.dart';
import '../parsers/text_overflow_parser.dart';

class WText extends StatelessWidget {
  const WText(
      this.data, {
        this.className,
        super.key,
        this.style,
        this.strutStyle,
        this.textAlign,
        this.textDirection,
        this.locale,
        this.softWrap,
        this.overflow,
        this.maxLines,
        this.semanticsLabel,
        this.textWidthBasis,
        this.textHeightBehavior,
        this.selectionColor,
      });

  final String data;
  final dynamic className;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;

  @override
  Widget build(BuildContext context) {
    final String parsedClassName = classNameParser(className);

    final TextOverflow? parsedOverflow = overflow ?? TextOverflowParser.parseOverflow(parsedClassName);
    final int? parsedMaxLines = maxLines ?? TextOverflowParser.parseMaxLines(parsedClassName);
    final bool? parsedSoftWrap = softWrap ?? TextOverflowParser.parseSoftWrap(parsedClassName);
    final String truncatedText = TextOverflowParser.applyMaxChars(data, parsedClassName);

    final widget= PaddingParser.apply(context, parsedClassName, Text(
      TextTransformParser.applyTransform(context, truncatedText, parsedClassName),
      style: const WTextStyle().className(context, className).merge(style),
      strutStyle: strutStyle,
      textAlign: textAlign ?? TextAlignParser.applyAlignment(context, parsedClassName),
      textDirection: textDirection,
      locale: locale,
      softWrap: parsedSoftWrap,
      overflow: parsedOverflow,
      maxLines: parsedMaxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    ));

    if (hasDebugWidgetClassName(className)) {
      print(widget.toStringDeep());
    }

    return widget;
  }
}