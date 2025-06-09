import 'package:flutter/material.dart';

import '../helpers.dart';
import '../parsers/display_parser.dart';
import '../parsers/flex_parser.dart';

/// A utility-first widget for creating flexible layouts in the Wind plugin.
///
/// `WFlex` is similar to the HTML `<div class="flex">` with TailwindCSS classes.
/// It allows you to efficiently define the direction, alignment, spacing, and overflow of its child widgets.
///
/// ## Example:
///
/// ```dart
/// WFlex(
///   className: 'flex-row justify-center items-center gap-4',
///   children: [
///     WText('Child 1', className: 'text-red-500'),
///     WText('Child 2', className: 'text-blue-500'),
///   ],
/// );
/// ```
///
/// This example creates a horizontally aligned row with centered children, spaced by a gap.
///
/// ## Supported Utility Classes:
/// - **Responsive Design:** `sm:`, `xs:`, `md:`, etc.
/// - **Flex Direction:** `flex-row`, `flex-col`
/// - **Justify Content:** `justify-center`, `justify-start`, `justify-end`, `justify-between`, `justify-around`, `justify-evenly`
/// - **Align Items:** `items-start`, `items-center`, `items-end`, `items-baseline`, `items-stretch`
/// - **Axis Sizes:** `axis-max`, `axis-min`
/// - **Gap (Spacing):** `gap-2`, `gap-[4]`
/// - **Overflow:** `overflow-scroll`, `overflow-hidden`, `overflow-visible`
///
/// ## Notes:
/// - `WFlex` wraps Flutter's `Flex` widget.
/// - If any Flutter `Flex` parameter conflicts with a utility class, the provided parameter will take precedence.
///
/// For more details, visit the [WFlex Documentation](https://wind.fluttersdk.com/widgets/wflex).
class WFlex extends StatelessWidget {
  const WFlex({
    super.key,
    this.className = '',
    this.direction,
    this.mainAxisAlignment,
    this.mainAxisSize,
    this.crossAxisAlignment,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline, // NO DEFAULT: we don't know what the text's baseline should be
    this.clipBehavior = Clip.none,
    required this.children,
  });

  final dynamic className;
  final Axis? direction;
  final MainAxisAlignment? mainAxisAlignment;
  final MainAxisSize? mainAxisSize;
  final CrossAxisAlignment? crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;
  final Clip clipBehavior;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final String parsedClassName = classNameParser(className);

    if (hasDebugClassName(className)) {
      print('WFlex: $parsedClassName');
    }

    if (DisplayParser.hide(context, parsedClassName)) {
      return const SizedBox.shrink();
    }

    final widget = FlexParser.applyOverflow(
        context,
        parsedClassName,
        Flex(
          direction:
              direction ?? FlexParser.applyDirection(context, parsedClassName),
          mainAxisAlignment: mainAxisAlignment ??
              FlexParser.applyJustifyContent(context, parsedClassName),
          mainAxisSize: mainAxisSize ??
              FlexParser.applyMainAxisSize(context, parsedClassName),
          crossAxisAlignment: crossAxisAlignment ??
              FlexParser.applyAlignItems(context, parsedClassName),
          textDirection: textDirection,
          verticalDirection: verticalDirection,
          textBaseline: textBaseline,
          clipBehavior: clipBehavior,
          children:
              FlexParser.applyGapToChildren(context, parsedClassName, children),
        ));

    if (hasDebugClassName(className)) {
      print('WFlex: $parsedClassName widget: ${widget.toStringDeep()}');
    }

    return widget;
  }
}
