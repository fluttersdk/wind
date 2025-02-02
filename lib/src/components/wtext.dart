import 'package:flutter/cupertino.dart';

import '../helpers.dart';
import '../painting/wtext_style.dart';
import '../parsers/padding_parser.dart';
import '../parsers/text_align_parser.dart';
import '../parsers/text_transform_parser.dart';

/// `WText` is a utility-first text widget in the Wind plugin.
/// It allows developers to style their text efficiently using predefined utility classes.
///
/// ## Example:
///
/// ```dart
/// WText(
///   'Styled Text',
///   className: 'text-red-500 font-bold text-lg underline',
/// );
/// ```
///
/// ## Supported Utility Classes:
/// - Responsive Design: `sm:`, `xs:`, `md:`, etc.
/// - Text Transform: `uppercase`, `lowercase`, `capitalize`, `none`
/// - Text Color: `text-red-500`, `text-blue-400`, `text-[#FF0000]`
/// - Font Weight: `font-bold`, `font-light`, `font-black`
/// - Font Size: `text-lg`, `text-[18]`, `text-2xl`
/// - Font Style: `italic`, `not-italic`
/// - Line Height: `leading-6`, `leading-[20]`
/// - Text Decoration: `underline`, `line-through`, `no-underline`
/// - Letter Spacing: `tracking-wide`, `tracking-[0.1]`
/// - Text Align: `text-left`, `text-center`, `text-right`, `text-justify`
/// - Padding: `p-4`, `px-[6]`, `py-2`
///
/// For more examples and details, visit the official documentation:
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

    final Widget childComponent = Text(
      TextTransformParser.applyTransform(context, data, parsedClassName),
      style: const WTextStyle().className(context, className).merge(style),
      strutStyle: strutStyle,
      textAlign:
          textAlign ?? TextAlignParser.applyAlignment(context, parsedClassName),
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );

    return PaddingParser.apply(context, parsedClassName, childComponent);
  }
}
