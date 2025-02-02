import 'package:flutter/material.dart';

import '../helpers.dart';
import '../parsers/flex_parser.dart';

/// A utility-first widget that applies flexible behavior to its child using
/// utility classes. The `WFlexible` widget corresponds to the `flex` property
/// in HTML+CSS and integrates seamlessly with the Wind plugin.
///
/// ## Example:
///
/// ```dart
/// WFlexible(
///   className: 'flex-1',
///   child: WText('Flexible Item'),
/// );
/// ```
/// This widget allows defining flexible behavior like `flex-grow` and `flex-x`
/// directly using utility classes.
///
/// ## Supported Utility Classes:
/// - Responsive Design: `sm:`, `xs:`, `md:`, etc.
/// - Flex-x: `flex-1`, `flex-2`, `flex-3`, etc.
/// - Flex Fit Classes: `flex-grow`, `flex-auto`, `flex-none`
///
/// For more examples and details, visit the documentation:
/// [WFlexible Documentation](https://wind.fluttersdk.com/widgets/wflexible)
class WFlexible extends StatelessWidget {
  const WFlexible({
    super.key,
    this.className,
    this.flex,
    this.fit,
    required this.child,
  });

  final dynamic className;
  final int? flex;
  final FlexFit? fit;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final parsedClassName = classNameParser(className);

    return Flexible(
      flex: flex ?? FlexParser.applyFlex(context, parsedClassName) ?? 1,
      fit: fit ??
          FlexParser.applyFlexFit(context, parsedClassName) ??
          FlexFit.loose,
      child: child,
    );
  }
}
