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
/// their active-states sets. The thumb is a flex child of the track, so the
/// caller moves it with `justify-start` -> `checked:justify-end` on the track
/// className. Do NOT use `translate-x-*`: Wind has no transform parser, so a
/// translate-based thumb never moves.
///
/// ### Supported Features:
/// - **Checked State:** `checked:bg-blue-600`, `checked:border-transparent`
/// - **Disabled State:** `disabled:opacity-50`
/// - **Hover / Focus:** `hover:ring-2 focus:ring-2`
/// - **Thumb position:** the track uses `justify-start checked:justify-end`
///
/// ### Example Usage:
///
/// ```dart
/// WSwitch(
///   value: isOn,
///   onChanged: (val) => setState(() => isOn = val),
///   className: '''
///     w-11 h-6 rounded-full px-0.5
///     flex items-center justify-start checked:justify-end
///     bg-gray-200 checked:bg-blue-600
///     disabled:opacity-50
///   ''',
///   thumbClassName: 'w-5 h-5 rounded-full bg-white shadow',
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
  /// The thumb's POSITION is owned by the track's `justify-*` (it is a flex
  /// child); this className supplies only its shape and color. Do not use
  /// `translate-x-*` (Wind has no transform parser, so it is a no-op).
  ///
  /// Example: `'w-5 h-5 rounded-full bg-white shadow'`
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
    this.onChanged,
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

    // 2. The track always renders as a flex Row so `justify-start` ->
    //    `checked:justify-end` slides the thumb; build the effective track
    //    className once and reuse it for both the debug parse and the WDiv, so
    //    debug output matches the classes actually applied.
    final String trackClassName = className == null
        ? 'flex items-center'
        : 'flex items-center $className';

    final WindStyle styles = WindParser.parse(
      trackClassName,
      context,
      states: activeStates,
    );

    final logger = WindLogger(
      debug: styles.debug,
      widgetName: runtimeType.toString(),
    );

    if (styles.debug) {
      logger.logStep('ClassName', "'$trackClassName'");
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
            // No `relative`: a single-child WDiv with `relative` renders as a
            // Stack (thumb pinned top-left), which kills `justify-*`. The track
            // must stay a flex Row so `justify-start` -> `checked:justify-end`
            // (supplied by the caller className) actually slides the thumb.
            className: trackClassName,
            states: activeStates,
            child: WDiv(
              className: thumbClassName,
              states: activeStates,
            ),
          ),
        ),
      ),
    );
  }
}
