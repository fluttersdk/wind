import 'package:flutter/widgets.dart';

import '../parser/wind_parser.dart';
import '../parser/wind_style.dart';

/// **WSpacer - Lightweight Spacing Widget**
///
/// A minimal widget for adding consistent spacing between elements using
/// Tailwind-like utility classes. Unlike [WDiv], this widget renders as a
/// simple [SizedBox] without any decoration or complex composition.
///
/// ### Use Cases:
/// - Vertical spacing between form fields: `WSpacer(className: 'h-4')`
/// - Horizontal spacing in rows: `WSpacer(className: 'w-4')`
/// - Replacing `SizedBox(height: 16)` with `WSpacer(className: 'h-4')`
///
/// ### Supported Classes:
/// - **Height:** `h-1`, `h-2`, `h-4`, `h-6`, `h-8`, `h-[20px]`, etc.
/// - **Width:** `w-1`, `w-2`, `w-4`, `w-6`, `w-8`, `w-[12px]`, etc.
/// - **Responsive:** `md:h-8`, `lg:w-6`, etc.
///
/// ### Example Usage:
///
/// ```dart
/// // Vertical spacing (replaces SizedBox(height: 16))
/// WDiv(
///   className: 'flex flex-col',
///   children: [
///     WFormInput(...),
///     WSpacer(className: 'h-4'),  // 16px vertical gap
///     WFormInput(...),
///   ],
/// )
///
/// // Horizontal spacing (replaces SizedBox(width: 8))
/// WDiv(
///   className: 'flex flex-row',
///   children: [
///     WButton(...),
///     WSpacer(className: 'w-2'),  // 8px horizontal gap
///     WButton(...),
///   ],
/// )
///
/// // Responsive spacing
/// WSpacer(className: 'h-4 md:h-6 lg:h-8')
/// ```
///
/// ### Why WSpacer instead of WDiv?
/// - **Lighter:** No decoration, shadows, or complex composition
/// - **Semantic:** Clearly communicates spacing intent
/// - **Efficient:** Renders as single SizedBox widget
/// - **Consistent:** Uses Wind's spacing scale (4px base)
class WSpacer extends StatelessWidget {
  /// The utility class string defining the spacing.
  ///
  /// Supports:
  /// - **Height:** `h-1` (4px), `h-2` (8px), `h-4` (16px), `h-[20px]`
  /// - **Width:** `w-1` (4px), `w-2` (8px), `w-4` (16px), `w-[12px]`
  /// - **Responsive:** `md:h-8`, `lg:w-6`
  ///
  /// Non-sizing classes (bg-*, text-*, etc.) are parsed but ignored
  /// since WSpacer only outputs a SizedBox.
  final String? className;

  /// Creates a new [WSpacer] instance.
  ///
  /// Example:
  /// ```dart
  /// const WSpacer(className: 'h-4')  // 16px height
  /// const WSpacer(className: 'w-2')  // 8px width
  /// const WSpacer(className: 'h-4 w-2')  // Both dimensions
  /// ```
  const WSpacer({super.key, this.className});

  @override
  Widget build(BuildContext context) {
    // Early return for no className - render empty SizedBox
    if (className == null || className!.trim().isEmpty) {
      return const SizedBox();
    }

    // Parse className to extract sizing values
    final WindStyle styles = WindParser.parse(className!, context);

    // Extract width and height from parsed styles
    final double? width = styles.width;
    final double? height = styles.height;

    return SizedBox(width: width, height: height);
  }
}
