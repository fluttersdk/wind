import 'package:flutter/cupertino.dart';

import '../helpers.dart';
import '../parsers/display_parser.dart';
import '../parsers/flex_parser.dart';
import 'wcontainer.dart';
import 'wflex.dart';

/// `WFlexContainer` is a flexible and utility-driven container widget in the Wind plugin.
/// It is designed to simplify creating responsive layouts by utilizing utility classes.
///
/// ## HTML Equivalent:
/// ```html
/// <div class="flex flex-col justify-center items-center gap-4 bg-gray-200">
///   <div class="w-full h-10 bg-blue-500"></div>
///   <div class="w-full h-10 bg-green-500"></div>
/// </div>
/// ```
///
/// ## Example:
/// ```dart
/// WFlexContainer(
///   className: 'flex-col justify-center items-center gap-4 bg-gray-200',
///   children: [
///     WContainer(
///       className: 'w-full h-10 bg-blue-500',
///     ),
///     WContainer(
///       className: 'w-full h-10 bg-green-500',
///     ),
///   ],
/// );
/// ```
///
/// ## Supported Utility Classes:
/// - Responsive Design: `sm:`, `xs:`, `md:`, etc.
/// - Flex Direction: `flex-row`, `flex-col`
/// - Justify Content: `justify-center`, `justify-between`, `justify-end`
/// - Align Items: `items-start`, `items-center`, `items-stretch`
/// - Axis Sizes: `axis-max`, `axis-min`
/// - Gap (Spacing): `gap-2`, `gap-[4]`
/// - Alignment: `alignment-top-left`, `alignment-center-right`
/// - Padding: `p-4`, `px-[6]`, `py-2`
/// - Margin: `m-8`, `mx-[4]`, `my-2`
/// - Width: `w-10`, `w-[30]`
/// - Height: `h-10`, `h-[30]`
/// - Max-Width & Min-Width: `max-w-10`, `min-w-[50]`
/// - Max-Height & Min-Height: `max-h-10`, `min-h-[50]`
/// - Background Color: `bg-red-500`, `bg-[#1abc9c]`
/// - Border Width: `border-4`, `border-[6]`
/// - Border Color: `border-red-500`, `border-[#1abc9c]`
/// - Border Radius: `rounded-lg`, `rounded-full`
/// - Overflow: `overflow-scroll`
/// - Shadow: `shadow-md`, `shadow-lg`
///
/// For a complete list of classes and customization options, refer to the official documentation:
/// [WFlexContainer Documentation](https://wind.fluttersdk.com/widgets/wflexcontainer)
class WFlexContainer extends StatelessWidget {
  const WFlexContainer({
    super.key,
    required this.children,
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
    this.clipBehavior = Clip.none,
    this.direction,
    this.mainAxisAlignment,
    this.mainAxisSize,
    this.crossAxisAlignment,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline, // NO DEFAULT: we don't know what the text's baseline should be
  });

  final dynamic className;
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
  final Axis? direction;
  final MainAxisAlignment? mainAxisAlignment;
  final MainAxisSize? mainAxisSize;
  final CrossAxisAlignment? crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final parsedClassName = classNameParser(className);

    if (hasDebugClassName(className)) {
      print('WFlexContainer: $parsedClassName');
    }

    if (DisplayParser.hide(context, parsedClassName)) {
      return const SizedBox.shrink();
    }

    return WContainer(
      className: className,
      alignment: alignment ?? FlexParser.applyAlignment(context, parsedClassName),
      padding: padding,
      color: color,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
      child: WFlex(
        className: className,
        direction: direction,
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        textDirection: textDirection,
        verticalDirection: verticalDirection,
        textBaseline: textBaseline,
        clipBehavior: clipBehavior,
        children: children,
      ),
    );
  }
}