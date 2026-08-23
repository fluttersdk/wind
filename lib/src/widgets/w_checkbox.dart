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
/// - **Checked State:** `checked:bg-primary`, `checked:border-transparent`
/// - **Interactive States:** `hover:border-primary-400`, `disabled:opacity-50`
/// - **Icons:** Customize status icon via `iconClassName` and `checkIcon`
///
/// ### Example Usage:
///
/// ```dart
/// WCheckbox(
///   value: isChecked,
///   onChanged: (val) => setState(() => isChecked = val),
///   className: 'w-5 h-5 rounded border border-gray-300 checked:bg-primary checked:border-transparent transition-colors',
/// )
/// ```
class WCheckbox extends StatelessWidget {
  /// Whether the checkbox is checked.
  final bool value;

  /// Called when the checkbox value changes.
  ///
  /// Null makes the checkbox non-interactive, exactly like `disabled: true`:
  /// no gesture is attached, the `disabled:` prefix activates, and semantics
  /// report the control as not enabled. The `checked` state is still reported,
  /// so a display-only checkbox keeps telling assistive technology whether it
  /// is ticked.
  final ValueChanged<bool>? onChanged;

  /// Utility classes for styling.
  ///
  /// Supports:
  /// - **Dimensions:** `w-5`, `h-5` (Required)
  /// - **Appearance:** `rounded-md`, `border`, `border-gray-300`
  /// - **States:** `checked:bg-primary`, `hover:border-primary-400`, `disabled:bg-gray-100`
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

  /// Custom states for dynamic styling.
  ///
  /// These states are merged with built-in states (`checked`, `disabled`).
  /// Use to add custom states like `error`, `loading`, etc.
  ///
  /// Example:
  /// ```dart
  /// WCheckbox(
  ///   value: isChecked,
  ///   states: {'error'},
  ///   className: 'w-5 h-5 border error:border-red-500',
  /// )
  /// ```
  final Set<String>? states;

  /// Creates a [WCheckbox] widget.
  const WCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.className,
    this.iconClassName,
    this.disabled = false,
    this.checkIcon,
    this.states,
  });

  @override
  Widget build(BuildContext context) {
    // A null onChanged means the checkbox is non-interactive: treat it exactly
    // like disabled == true so the disabled: prefix activates, no gesture is
    // attached, and Semantics reports the control as not enabled. WRadio and
    // WSwitch derive it the same way; a display-only checkbox reporting itself
    // as enabled was the odd one out of the three.
    final bool isDisabled = disabled || onChanged == null;

    // Build states set: merge built-in states with custom states
    final Set<String> activeStates = {
      if (value) 'checked',
      if (isDisabled) 'disabled',
      ...?states, // Merge custom states
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

    // Accessibility: WCheckbox doesn't accept a child label parameter (its
    // visual content is the check glyph only), so the Semantics wrap below
    // surfaces the checked role + state (which is what makes Playwright
    // `getByRole('checkbox')` resolve) and nothing else. A sibling WText in a
    // row is a visible label, not a semantic one: the two stay separate nodes.
    // Callers who want one named node wrap the pair in `MergeSemantics`, which
    // folds this node into it and carries the label plus the checked state.
    return Semantics(
      container: true,
      checked: value,
      enabled: !isDisabled,
      // The presence of `checked` plus the standard interpretation of a
      // tickable container surfaces this node as `role=checkbox` in the
      // Flutter web accessibility tree.
      child: MergeSemantics(
        child: WAnchor(
          // A caller passing `onChanged: null` is rendering a display-only
          // checkbox (a read-only summary row, or a tile whose own tap drives
          // the toggle), and installing `() => onChanged?.call(!value)` for it
          // published a pressable control whose activation runs a no-op.
          // Measured in a consumer's region picker: a 16x16 nameless node
          // carrying a tap action, inside a tile that was already doing the
          // work.
          onTap: isDisabled ? null : () => onChanged!.call(!value),
          isDisabled: isDisabled,
          states: activeStates,
          child: WDiv(
            className:
                'w-5 h-5 rounded border border-gray-300 items-center justify-center error:border-red-500 checked:bg-primary checked:border-transparent ${className != null ? ' $className' : ''}',
            states: activeStates, // Pass states to WDiv for checked: prefix
            children: [
              if (value)
                WIcon(
                  checkIcon ??
                      const IconData(0xe156, fontFamily: 'MaterialIcons'),
                  className: iconClassName ?? 'text-white text-sm',
                ),
            ],
          ),
        ),
      ),
    );
  }
}
