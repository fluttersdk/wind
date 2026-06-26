import 'package:flutter/widgets.dart';

import '../parser/wind_parser.dart';
import '../parser/wind_style.dart';
import '../utils/wind_logger.dart';
import 'w_div.dart';
import 'w_text.dart';

/// **A Utility-First Badge / Label Component**
///
/// `WBadge` renders a small inline status or label chip. It composes a
/// [WDiv] (inline-flex container with rounded-full pill shape + px/py spacing)
/// around a [WText] (text-xs). All visual styling is className-driven: the
/// caller supplies tone tokens (bg-*, text-*, dark:bg-*, dark:text-*) via
/// [className]; no colors are hardcoded here.
///
/// ### Example Usage:
///
/// ```dart
/// WBadge(
///   'Active',
///   className: 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-100',
/// )
///
/// WBadge(
///   'Error',
///   className: 'bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-100',
/// )
/// ```
///
/// See also:
///
///  * [WDiv], which provides the pill container.
///  * [WText], which renders the label text.
class WBadge extends StatelessWidget {
  /// The label text displayed inside the badge.
  final String label;

  /// Caller-supplied utility classes appended to the default layout classes.
  ///
  /// Use this to supply tone (bg-*, text-*, dark: pairs) and any
  /// override classes. The default layout classes are:
  ///   `inline-flex items-center rounded-full px-2 py-0.5`
  ///
  /// Example:
  /// ```dart
  /// className: 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-100'
  /// ```
  final String? className;

  /// Creates a [WBadge] widget.
  const WBadge(
    this.label, {
    super.key,
    this.className,
  });

  /// Base layout classes that every badge carries.
  ///
  /// Callers override tone by appending their own bg-*/text-* tokens; wind's
  /// per-family last-wins rule means a caller `bg-green-100` appended after the
  /// default (which has no bg-*) simply applies. When no className is provided
  /// the badge renders unstyled (transparent background, inherited text color).
  static const String _baseClasses =
      'inline-flex items-center rounded-full px-2 py-0.5';

  @override
  Widget build(BuildContext context) {
    // 1. Resolve styles for debug logging only (WDiv re-parses internally).
    final String composedClassName =
        className != null ? '$_baseClasses $className' : _baseClasses;

    final WindStyle styles = WindParser.parse(
      composedClassName,
      context,
    );

    // 2. Initialize debug logger.
    final logger = WindLogger(
      debug: styles.debug,
      widgetName: runtimeType.toString(),
    );

    if (styles.debug) {
      logger.logStep('ClassName', "'$composedClassName'");
      logger.setCoreWidget('WDiv -> WText');
      logger.printFinalCode();
    }

    // 3. Compose: pill container wrapping the text label.
    return WDiv(
      className: composedClassName,
      child: WText(
        label,
        className: 'text-xs',
      ),
    );
  }
}
