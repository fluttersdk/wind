import 'package:flutter/material.dart';

import '../helpers.dart';
import '../painting/wtext_style.dart';
import '../parsers/alignment_parser.dart';
import '../parsers/display_parser.dart';
import '../parsers/padding_parser.dart';
import '../parsers/text_align_parser.dart';
import '../parsers/text_overflow_parser.dart';
import '../parsers/text_transform_parser.dart';

/// `WText` is a utility-first text widget for the Wind plugin.
/// It enables developers to style text efficiently using predefined utility classes.
///
/// ## Example Usage:
///
/// ```dart
/// WText(
///   'Styled Text',
///   className: 'text-red-500 font-bold text-lg underline truncate max-lines-2',
/// );
/// ```
///
/// ## Supported Utility Classes:
/// - **Responsive Design:** `sm:`, `xs:`, `md:`, etc.
/// - **Flex-x:** `flex-1`, `flex-2`, `flex-3`, etc.
/// - **Flex Fit Classes:** `flex-grow`, `flex-auto`, `flex-none`
/// - **Text Overflow:** `truncate`, `text-clip`, `text-fade`, `max-lines-{n}`, `max-chars-{n}`
/// - **Text Transform:** `uppercase`, `lowercase`, `capitalize`, `none`
/// - **Text Color:** `text-red-500`, `text-blue-400`, `text-[#FF0000]`
/// - **Font Weight:** `font-bold`, `font-light`, `font-black`
/// - **Font Size & Line Height:** `text-lg`, `text-[18]`, `text-2xl`, `leading-6`, `leading-[20]`
/// - **Font Style & Decoration:** `italic`, `not-italic`, `underline`, `line-through`, `no-underline`
/// - **Letter Spacing & Alignment:** `tracking-wide`, `tracking-[0.1]`, `text-left`, `text-center`, `text-right`, `text-justify`
/// - **Padding:** `p-4`, `px-[6]`, `py-2`
/// - **Selectable Text:** `selectable`
/// - **Debugging Support:** `log-widget` → Enables debug logs using `print(widget.toStringDeep())`.
///
/// For more details, refer to the official documentation:
/// [WText Documentation](https://wind.fluttersdk.com/widgets/wtext)
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

    if (hasDebugClassName(className)) {
      print('WText: $parsedClassName');
    }

    if (DisplayParser.hide(context, parsedClassName)) {
      return const SizedBox.shrink();
    }

    final TextOverflow? parsedOverflow =
        overflow ?? TextOverflowParser.parseOverflow(parsedClassName);
    final int? parsedMaxLines =
        maxLines ?? TextOverflowParser.parseMaxLines(parsedClassName);
    final bool? parsedSoftWrap =
        softWrap ?? TextOverflowParser.parseSoftWrap(parsedClassName);
    final String truncatedText =
        TextOverflowParser.applyMaxChars(data, parsedClassName);

    Widget textWidget;
    if (hasClassName(className, 'selectable')) {
      textWidget = SelectableText(
        TextTransformParser.applyTransform(
            context, truncatedText, parsedClassName),
        style: const WTextStyle().className(context, className).merge(style),
        strutStyle: strutStyle,
        textAlign: textAlign ??
            TextAlignParser.applyAlignment(context, parsedClassName),
        textDirection: textDirection,
        maxLines: parsedMaxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
      );
    } else {
      textWidget = Text(
        TextTransformParser.applyTransform(
            context, truncatedText, parsedClassName),
        style: const WTextStyle().className(context, className).merge(style),
        strutStyle: strutStyle,
        textAlign: textAlign ??
            TextAlignParser.applyAlignment(context, parsedClassName),
        textDirection: textDirection,
        locale: locale,
        softWrap: parsedSoftWrap,
        overflow: parsedOverflow,
        maxLines: parsedMaxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
        selectionColor: selectionColor,
      );
    }

    final widget = PaddingParser.apply(
        context,
        parsedClassName,
        AlignmentParser.apply(context, parsedClassName, textWidget,
            isText: true));

    if (hasDebugWidgetClassName(className)) {
      print(widget.toStringDeep());
    }

    return widget;
  }
}
