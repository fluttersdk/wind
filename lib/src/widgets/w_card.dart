import 'package:flutter/widgets.dart';

import 'w_div.dart';

/// **A Surface Container for Card-Style Layouts**
///
/// `WCard` composes a `WDiv` (flex-col) with an optional `header` slot,
/// a required `child` body, and an optional `footer` slot. All styling is
/// className-driven — no colors or variants are baked in; tone and appearance
/// are the caller's responsibility via `className` or a `WindRecipe` in the
/// consuming component layer.
///
/// ### Slots
///
/// - **header** — optional widget rendered above the body (e.g. a title row,
///   an image, or a section label).
/// - **child** — required body content.
/// - **footer** — optional widget rendered below the body (e.g. action buttons
///   or metadata).
///
/// ### Example Usage:
///
/// ```dart
/// WCard(
///   className: 'rounded-xl border border-gray-200 dark:border-gray-700 p-4 flex flex-col gap-4',
///   header: WText('Settings', className: 'text-lg font-semibold'),
///   child: WDiv(className: 'flex flex-col gap-2', children: [...]),
///   footer: WButton(onPressed: save, className: '...', child: WText('Save')),
/// )
/// ```
///
/// See also:
///
///  * [WDiv], which this widget delegates all rendering to.
class WCard extends StatelessWidget {
  /// The main body content of the card.
  final Widget child;

  /// Optional widget rendered above the [child] body.
  ///
  /// Typical usage: a title row, a card image, or a section label.
  final Widget? header;

  /// Optional widget rendered below the [child] body.
  ///
  /// Typical usage: action buttons or status/metadata rows.
  final Widget? footer;

  /// Utility classes controlling the card's outer container.
  ///
  /// Supports all `WDiv` className tokens: `rounded-*`, `border*`, `shadow-*`,
  /// `p-*`, `bg-*`, `dark:*`, etc. When omitted, the default provides a
  /// minimal flex-col container without imposing colors or spacing, so the
  /// consuming component (via a `WindRecipe`) decides the appearance.
  ///
  /// Example:
  /// ```dart
  /// className: 'rounded-xl bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 p-4'
  /// ```
  final String? className;

  /// Creates a [WCard] widget.
  const WCard({
    super.key,
    required this.child,
    this.header,
    this.footer,
    this.className,
  });

  /// The default className applied when [className] is not provided.
  ///
  /// A minimal flex-col container: no colors, no spacing imposed. The
  /// consuming layer (recipe or caller className) adds tone and spacing.
  static const String _defaultClassName = 'w-full flex flex-col';

  @override
  Widget build(BuildContext context) {
    // 1. Resolve the effective className for the root container.
    final String effectiveClassName = className ?? _defaultClassName;

    // 2. Build the slot children list: header? + body + footer?
    final List<Widget> slotChildren = [
      if (header != null) header!,
      child,
      if (footer != null) footer!,
    ];

    // 3. Render via WDiv, which handles all layout + decoration.
    return WDiv(
      className: effectiveClassName,
      children: slotChildren,
    );
  }
}
