import 'package:flutter/widgets.dart';

import 'w_anchor.dart';
import 'w_div.dart';
import 'w_icon.dart';
import '../utils/wind_logger.dart';
import '../parser/wind_parser.dart';
import '../parser/wind_style.dart';

/// **A Utility-First Checkbox Component**
///
/// `WCheckbox` uses `WAnchor` and `WDiv` to render a fully styled checkbox,
/// bypassing native widget limitations.
///
/// ### Supported Features:
/// - **Styling:** `w-6`, `h-6`, `rounded`, `border-2`, `border-gray-300`
/// - **Checked State:** `checked:bg-blue-600`, `checked:border-transparent`
/// - **Interactive States:** `hover:border-blue-400`, `disabled:opacity-50`
/// - **Icons:** Customize status icon via `iconClassName` and `checkIcon`
///
/// ### Example Usage:
///
/// ```dart
/// WCheckbox(
///   value: isChecked,
///   onChanged: (val) => setState(() => isChecked = val),
///   className: 'w-5 h-5 rounded border border-gray-300 checked:bg-blue-500 checked:border-transparent transition-colors',
/// )
/// ```
class WCheckbox extends StatelessWidget {
  /// Whether the checkbox is checked.
  final bool value;

  /// Called when the checkbox value changes.
  final ValueChanged<bool>? onChanged;

  /// Utility classes for styling.
  ///
  /// Supports:
  /// - **Dimensions:** `w-5`, `h-5` (Required)
  /// - **Appearance:** `rounded-md`, `border`, `border-gray-300`
  /// - **States:** `checked:bg-blue-600`, `hover:border-blue-500`, `disabled:bg-gray-100`
  ///
  /// Example: `'w-6 h-6 rounded-full border-2 border-red-500 checked:bg-red-500'`
  final String? className;

  /// Additional classes for the check icon.
  ///
  /// Defaults to white text.
  /// Example: `'text-white text-xs'` or `'text-black'`
  final String? iconClassName;

  /// Whether the checkbox is disabled.
  final bool disabled;

  /// Custom check icon.
  final IconData? checkIcon;

  /// Creates a [WCheckbox] widget.
  const WCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.className,
    this.iconClassName,
    this.disabled = false,
    this.checkIcon,
  });

  @override
  Widget build(BuildContext context) {
    // Build states set based on current value
    final Set<String> activeStates = {
      if (value) 'checked',
      if (disabled) 'disabled',
    };

    // Parse just for debug purposes (WCheckbox delegates to WDiv, but we want to log top-level too)
    // Note: This is a bit inefficient as WDiv will parse again, but needed for proper logging.
    final WindStyle styles = className != null
        ? WindParser.parse(className!, context, states: activeStates)
        : const WindStyle();

    final logger = WindLogger(
      debug: styles.debug,
      widgetName: runtimeType.toString(),
    );

    if (styles.debug) {
      logger.logStep("ClassName", "'$className'");
      logger.setCoreWidget("WAnchor -> WDiv");
      logger.printFinalCode();
    }

    return WAnchor(
      onTap: disabled ? null : () => onChanged?.call(!value),
      isDisabled: disabled,
      states: activeStates,
      child: WDiv(
        className:
            className ??
            'w-5 h-5 rounded border border-gray-300 items-center justify-center checked:bg-blue-500 checked:border-transparent',
        states: activeStates, // Pass states to WDiv for checked: prefix
        children: [
          if (value)
            WIcon(
              checkIcon ?? const IconData(0xe156, fontFamily: 'MaterialIcons'),
              className: iconClassName ?? 'text-white text-sm',
            ),
        ],
      ),
    );
  }
}
