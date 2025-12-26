import 'package:flutter/widgets.dart';

import 'w_anchor.dart';
import 'w_div.dart';
import 'w_icon.dart';

/// **A Utility-First Checkbox Component**
///
/// `WCheckbox` uses `WAnchor` and `WDiv` to render a fully styled checkbox,
/// bypassing native widget limitations.
///
/// ### Features:
/// - **Checked State:** Shows check icon when checked
/// - **State Styling:** Use `checked:` prefix for checked state styles
/// - **Custom Rendering:** Fully styled with utility classes
///
/// ### Basic Usage:
///
/// ```dart
/// WCheckbox(
///   value: isChecked,
///   onChanged: (val) => setState(() => isChecked = val),
///   className: 'w-5 h-5 rounded border border-gray-300 checked:bg-blue-500 checked:border-transparent',
/// )
/// ```
///
/// ### State Styling:
///
/// ```dart
/// className: '''
///   w-5 h-5 rounded border border-gray-300
///   checked:bg-blue-500 checked:border-transparent
///   hover:border-blue-400
///   disabled:bg-gray-100 disabled:border-gray-200
/// '''
/// ```
class WCheckbox extends StatelessWidget {
  /// Whether the checkbox is checked.
  final bool value;

  /// Called when the checkbox value changes.
  final ValueChanged<bool>? onChanged;

  /// Utility classes for styling.
  ///
  /// Supports:
  /// - `checked:` prefix for checked state
  /// - `hover:` prefix for hover state
  /// - `disabled:` prefix for disabled state
  /// - All standard sizing, border, background classes
  final String? className;

  /// Additional classes for the check icon.
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
