import 'package:flutter/widgets.dart';

import 'w_anchor.dart';
import 'w_div.dart';
import '../parser/wind_parser.dart';
import '../parser/wind_style.dart';
import '../utils/wind_logger.dart';

/// **A Utility-First Toggle Switch Component**
///
/// `WSwitch` is a controlled toggle that composes `WAnchor` + `WDiv` (track)
/// + `WDiv` (thumb). It pushes the `checked:` state prefix into the className
/// context, mirroring how `WCheckbox` and `WButton` push framework states via
/// their active-states sets. The thumb translates right when checked via the
/// caller's `checked:translate-x-*` className.
///
/// ### Supported Features:
/// - **Checked State:** `checked:bg-blue-600`, `checked:border-transparent`
/// - **Disabled State:** `disabled:opacity-50`
/// - **Hover / Focus:** `hover:ring-2 focus:ring-2`
/// - **Thumb translate:** caller supplies `thumbClassName: 'checked:translate-x-5'`
///
/// ### Example Usage:
///
/// ```dart
/// WSwitch(
///   value: isOn,
///   onChanged: (val) => setState(() => isOn = val),
///   className: '''
///     w-11 h-6 rounded-full border-2
///     bg-gray-200 checked:bg-blue-600
///     border-gray-300 checked:border-blue-600
///     disabled:opacity-50
///   ''',
///   thumbClassName: 'translate-x-0 checked:translate-x-5 w-4 h-4 rounded-full bg-white',
/// )
/// ```
///
/// See also:
///
///  * [WAnchor], which provides hover, focus, and gesture state propagation.
///  * [WDiv], which renders the track and thumb surfaces.
///  * [WCheckbox], whose `checked:` state pattern this widget mirrors.
class WSwitch extends StatelessWidget {
  /// Whether the switch is on.
  final bool value;

  /// Called when the switch value changes.
  final ValueChanged<bool>? onChanged;

  /// Utility classes for styling the track (the outer pill container).
  ///
  /// Supports:
  /// - **Dimensions:** `w-11`, `h-6` (recommended)
  /// - **Appearance:** `rounded-full`, `border`, `border-gray-300`
  /// - **States:** `checked:bg-blue-600`, `disabled:opacity-50`
  ///
  /// Example: `'w-11 h-6 rounded-full bg-gray-200 checked:bg-blue-600'`
  final String? className;

  /// Utility classes for styling the thumb (the circular indicator).
  ///
  /// Use `checked:translate-x-*` to slide the thumb when the switch is on.
  ///
  /// Example: `'w-4 h-4 rounded-full bg-white shadow translate-x-0 checked:translate-x-5'`
  final String? thumbClassName;

  /// Whether the switch is disabled.
  final bool disabled;

  /// Custom states for dynamic styling.
  ///
  /// Merged with built-in states (`checked`, `disabled`). Use to add custom
  /// prefixes such as `error:` or `loading:`.
  ///
  /// Example:
  /// ```dart
  /// WSwitch(
  ///   value: isOn,
  ///   states: {'error'},
  ///   className: 'w-11 h-6 error:border-red-500',
  ///   onChanged: (_) {},
  /// )
  /// ```
  final Set<String>? states;

  /// An explicit accessible label for the switch Semantics node.
  ///
  /// Required for icon-only or purely visual switches that carry no
  /// readable text child. Forwarded to [WAnchor.semanticLabel].
  final String? semanticLabel;

  /// Creates a [WSwitch] widget.
  const WSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.className,
    this.thumbClassName,
    this.disabled = false,
    this.states,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    // A null onChanged means the switch is non-interactive: treat it exactly
    // like disabled == true so the disabled: prefix activates, no gesture is
    // attached, and Semantics reports the control as not enabled.
    final bool isDisabled = disabled || onChanged == null;

    // 1. Build active states by merging built-in flags with caller states.
    final Set<String> activeStates = {
      if (value) 'checked',
      if (isDisabled) 'disabled',
      ...?states,
    };

    // 2. Parse track className for debug logging (the track WDiv re-parses
    //    with these same states; we parse here only to surface the debug flag).
    final WindStyle styles = className != null
        ? WindParser.parse(className!, context, states: activeStates)
        : const WindStyle();

    final logger = WindLogger(
      debug: styles.debug,
      widgetName: runtimeType.toString(),
    );

    if (styles.debug) {
      logger.logStep('ClassName', "'$className'");
      logger.setCoreWidget('WAnchor -> WDiv (track) -> WDiv (thumb)');
      logger.printFinalCode();
    }

    // 3. Wrap with Semantics to surface toggle role + state for accessibility
    //    and Playwright `getByRole('switch')` resolution.
    return Semantics(
      container: true,
      toggled: value,
      enabled: !isDisabled,
      child: MergeSemantics(
        child: WAnchor(
          onTap: isDisabled ? null : () => onChanged!.call(!value),
          isDisabled: isDisabled,
          states: activeStates,
          semanticLabel: semanticLabel,
          // 4. Render track and thumb as WDivs so className + state
          //    prefixes flow through WindParser normally.
          child: WDiv(
            className: 'flex items-center relative ${className ?? ''}',
            states: activeStates,
            child: WDiv(
              className: thumbClassName ?? '',
              states: activeStates,
            ),
          ),
        ),
      ),
    );
  }
}
