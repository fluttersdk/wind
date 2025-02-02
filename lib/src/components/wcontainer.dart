
import 'package:flutter/material.dart';

import '../helpers.dart';
import '../parsers/alignment_parser.dart';
import '../parsers/background_color_parser.dart';
import '../parsers/border_parser.dart';
import '../parsers/flex_parser.dart';
import '../parsers/margin_parser.dart';
import '../parsers/padding_parser.dart';
import '../parsers/size_parser.dart';

/// A utility-first container widget that provides customizable styling using
/// the Wind plugin's utility classes.
///
/// The `WContainer` widget is the Flutter equivalent of an HTML `<div>` element
/// styled with TailwindCSS. It simplifies the creation of styled containers by
/// allowing the application of utility classes directly.
///
/// ## Example Usage
///
/// ```dart
/// WContainer(
///   className: 'bg-blue-500 p-4 rounded-lg shadow-md',
///   child: WText(
///     'This is a container',
///     className: 'text-white text-lg',
///   ),
/// );
/// ```
///
/// ## Supported Utility Classes
/// - Responsive Design: Apply responsive styles using prefixes like `sm:`, `md:`, `lg:`, etc.
/// - Flex-x: Control flex properties with `flex-1`, `flex-3`, etc.
/// - Flex Fit Classes: Use `flex-grow`, `flex-auto`, etc., to define flex behavior.
/// - Alignment: Align content with `alignment-top-left`, `alignment-center-right`, etc.
/// - Padding: Apply padding using classes like `p-4`, `px-[20]`, `py-2`.
/// - Margin: Define margins with `m-8`, `m-[16]`, etc.
/// - Width: Set container width using `w-10`, `w-[40]`, etc.
/// - Height: Define height using `h-10`, `h-[50]`, etc.
/// - Max-Width & Min-Width: Set constraints with `max-w-10`, `min-w-10`, etc.
/// - Max-Height & Min-Height: Apply height constraints like `max-h-10`, `min-h-[30]`.
/// - Background Color: Style backgrounds with `bg-red-500`, `bg-green`, etc.
/// - Border Width: Define border width using `border-4`, `border-[6]`.
/// - Border Color: Set border colors with `border-red-500`, `border-[#1abc9c]`.
/// - Border Radius: Apply rounding using `rounded-lg`, `rounded-full`.
/// - Shadow: Add shadows with `shadow-sm`, `shadow-lg`.
///
/// For additional examples and detailed usage, visit the official documentation:
/// [WContainer Documentation](https://wind.fluttersdk.com/widgets/wcontainer)
class WContainer extends StatelessWidget {
  const WContainer({
    super.key,
    this.className = '',
    this.alignment,
    this.padding,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    this.width,
    this.height,
    this.constraints,
    this.margin,
    this.transform,
    this.transformAlignment,
    this.child,
    this.clipBehavior = Clip.none,
  });

  final dynamic className;
  final Widget? child;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip clipBehavior;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final String parsedClassName = classNameParser(className);

    return FlexParser.applyFlexible(context, parsedClassName, Container(
      alignment: alignment ?? AlignmentParser.applyAlignment(context, parsedClassName),
      padding: padding ?? PaddingParser.applyGeometry(context, parsedClassName),
      decoration: decoration ?? BoxDecoration(
        color: color ?? BackgroundColorParser.applyColor(context, parsedClassName),
        borderRadius: BorderParser.applyBorderRadiusGeometry(context, parsedClassName),
        border: BorderParser.applyBoxBorder(context, parsedClassName),
      ),
      foregroundDecoration: foregroundDecoration,
      width: width ?? SizeParser.applyWidth(context, parsedClassName),
      height: height ?? SizeParser.applyHeight(context, parsedClassName),
      constraints: constraints ?? SizeParser.applyBoxConstraints(context, parsedClassName),
      margin: margin ?? MarginParser.applyGeometry(context, parsedClassName),
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
      child: child,
    ));
  }
}