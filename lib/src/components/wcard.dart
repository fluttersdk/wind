import 'package:flutter/material.dart';

import '../helpers.dart';
import '../parsers/background_color_parser.dart';
import '../parsers/border_parser.dart';
import '../parsers/flex_parser.dart';
import '../parsers/margin_parser.dart';
import '../parsers/padding_parser.dart';
import '../parsers/shadow_parser.dart';
import '../parsers/size_parser.dart';

/// `WCard` is a utility-first card widget in the Wind plugin.
/// It simplifies creating styled card components with support for shadows, borders, padding, and more.
///
/// ## Example:
///
/// ```dart
/// WCard(
///   className: 'bg-white shadow-lg rounded-lg p-4',
///   child: WText(
///     'This is a card.',
///     className: 'text-gray-800',
///   ),
/// );
/// ```
///
/// ## Supported Utility Classes:
/// - Responsive Design: `sm:`, `xs:`, `md:`, etc.
/// - Flex-x: `flex-1`, `flex-3`, etc.
/// - Flex Fit Classes: `flex-grow`, `flex-auto`, etc.
/// - Alignment: `alignment-top-left`, `alignment-center-right`, etc.
/// - Padding: `p-4`, `px-[20]`, `py-2`
/// - Margin: `m-8`, `m-[16]`, etc.
/// - Width: `w-10`, `w-[40]`, etc.
/// - Height: `h-10`, `h-[50]`, etc.
/// - Max-Width & Min-Width: `max-w-10`, `min-w-[20]`, etc.
/// - Max-Height & Min-Height: `max-h-10`, `min-h-[30]`, etc.
/// - Background Color: `bg-red-500`, `bg-green`, etc.
/// - Border Width: `border-4`, `border-[6]`
/// - Border Color: `border-red-500`, `border-[#1abc9c]`
/// - Border Radius: `rounded-lg`, `rounded-full`
/// - Shadow: `shadow-sm`, `shadow-lg`
///
/// For more examples and details, visit the official documentation:
/// [WCard Documentation](https://wind.fluttersdk.com/widgets/wcard)
class WCard extends StatelessWidget {
  const WCard({
    super.key,
    this.className = '',
    this.color,
    this.shadowColor,
    this.surfaceTintColor,
    this.elevation,
    this.shape,
    this.borderOnForeground = true,
    this.margin,
    this.clipBehavior,
    this.child,
    this.semanticContainer = true,
  });

  final dynamic className;
  final Color? color;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final double? elevation;
  final ShapeBorder? shape;
  final bool borderOnForeground;
  final Clip? clipBehavior;
  final EdgeInsetsGeometry? margin;
  final bool semanticContainer;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final String parsedClassName = classNameParser(className);

    Widget childComponent = Card(
      color:
          color ?? BackgroundColorParser.applyColor(context, parsedClassName),
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      elevation:
          elevation ?? ShadowParser.applyElevation(context, parsedClassName),
      shape: shape ?? BorderParser.applyBorder(context, parsedClassName),
      borderOnForeground: borderOnForeground,
      margin: margin ?? MarginParser.applyGeometry(context, parsedClassName),
      clipBehavior: clipBehavior,
      semanticContainer: semanticContainer,
      child: child != null
          ? PaddingParser.apply(context, parsedClassName, child!)
          : null,
    );

    if (SizeParser.hasAnyValid(parsedClassName)) {
      childComponent = ConstrainedBox(
        constraints: SizeParser.applyBoxConstraints(context, parsedClassName),
        child: childComponent,
      );
    }

    childComponent = PaddingParser.apply(context, parsedClassName, childComponent);
    return FlexParser.applyFlexible(context, parsedClassName, childComponent);
  }
}
