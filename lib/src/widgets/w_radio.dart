import 'package:flutter/widgets.dart';

import 'w_anchor.dart';
import 'w_div.dart';
import '../utils/wind_logger.dart';
import '../parser/wind_parser.dart';
import '../parser/wind_style.dart';

/// **A Utility-First Radio Button Component**
///
/// `WRadio<T>` renders a radio-button control driven entirely by className.
/// It composes `WAnchor` (interaction state) and two `WDiv` layers (the outer
/// ring shell and the inner filled indicator that appears when selected).
///
/// Mutually-exclusive group behavior is the caller's responsibility: pass the
/// same `groupValue` to every `WRadio` in a group and update it through
/// `onChanged`.
///
/// ### Supported Features:
/// - **Selection:** drives the `selected:` state prefix on className tokens
/// - **Disabled:** drives the `disabled:` state prefix, blocks tap
/// - **Styling:** `w-5`, `h-5`, `rounded-full`, `border`, `border-gray-300`
/// - **Selected State:** `selected:border-primary-500`, `selected:bg-primary`
/// - **Hover / Focus:** inherited from the wrapping `WAnchor`
///
/// ### Example Usage:
///
/// ```dart
/// WRadio<String>(
///   value: 'light',
///   groupValue: _theme,
///   onChanged: (val) => setState(() => _theme = val),
///   className: '''
///     w-5 h-5 rounded-full border border-gray-300
///     selected:border-primary-500
///     hover:border-primary-400
///     disabled:opacity-50
///   ''',
/// )
/// ```
class WRadio<T> extends StatelessWidget {
  /// The value represented by this radio button.
  final T value;

  /// The currently selected value for the group.
  ///
  /// This radio is selected when `value == groupValue`.
  final T? groupValue;

  /// Called with [value] when this radio is tapped and not already selected.
  ///
  /// Null makes the radio non-interactive (but still responds to [disabled]).
  final ValueChanged<T>? onChanged;

  /// Utility classes for the outer radio shell.
  ///
  /// Supports:
  /// - **Dimensions:** `w-5`, `h-5` (required for a visible hit area)
  /// - **Shape:** `rounded-full`
  /// - **Border:** `border`, `border-gray-300`
  /// - **States:** `selected:border-primary-500`, `hover:border-primary-400`,
  ///   `disabled:opacity-50`
  ///
  /// Example: `'w-5 h-5 rounded-full border border-gray-300 selected:border-primary-500'`
  final String? className;

  /// Utility classes for the inner indicator dot shown when selected.
  ///
  /// Defaults to a filled circle. Example: `'w-2.5 h-2.5 rounded-full bg-primary'`
  final String? indicatorClassName;

  /// Whether this radio button is disabled.
  ///
  /// When true, `onChanged` is suppressed and the `disabled:` prefix activates.
  final bool disabled;

  /// Additional custom states merged with the built-in `selected` / `disabled`
  /// states.
  ///
  /// Example: `{'error'}` activates `error:border-red-500`.
  final Set<String>? states;

  /// An explicit accessible label for the Semantics node.
  ///
  /// Set this on icon-only or unlabelled radios so screen readers can announce
  /// the option. When null, `MergeSemantics` merges any descendant text.
  final String? semanticLabel;

  /// Creates a [WRadio] widget.
  const WRadio({
    super.key,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.className,
    this.indicatorClassName,
    this.disabled = false,
    this.states,
    this.semanticLabel,
  });

  bool get _isSelected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    // A null onChanged means the radio is non-interactive: treat it exactly
    // like disabled == true so the disabled: prefix activates, no gesture is
    // attached, and Semantics reports the control as not enabled.
    final bool isDisabled = disabled || onChanged == null;

    // 1. Build the active states set from props + custom states.
    final Set<String> activeStates = {
      if (_isSelected) 'selected',
      if (isDisabled) 'disabled',
      ...?states,
    };

    // 2. Resolve className to WindStyle for debug-logger initialisation.
    final WindStyle styles = className != null
        ? WindParser.parse(className!, context, states: activeStates)
        : const WindStyle();

    final logger = WindLogger(
      debug: styles.debug,
      widgetName: runtimeType.toString(),
    );

    if (styles.debug) {
      logger.logStep('ClassName', "'$className'");
      logger.setCoreWidget('WAnchor -> WDiv (shell) -> WDiv (indicator)');
      logger.printFinalCode();
    }

    // 3. The indicator dot is visible only when selected.
    final Widget indicator = WDiv(
      className: indicatorClassName ??
          'w-2.5 h-2.5 rounded-full bg-primary selected:opacity-100',
      states: activeStates,
    );

    // 4. Compose the radio shell with an optional indicator.
    final Widget shell = WDiv(
      className: className ??
          'w-5 h-5 rounded-full border border-gray-300 flex items-center justify-center selected:border-primary-500',
      states: activeStates,
      children: [
        if (_isSelected) indicator,
      ],
    );

    // 5. Wrap shell in WAnchor for interaction + state propagation.
    //
    // Tapping a radio that is already selected is a no-op (radio semantics:
    // you cannot de-select a radio by re-tapping it).
    final Widget anchor = WAnchor(
      onTap: isDisabled || _isSelected ? null : () => onChanged!.call(value),
      isDisabled: isDisabled,
      states: activeStates,
      semanticLabel: semanticLabel,
      child: shell,
    );

    // 6. Wrap with Semantics so Playwright / assistive tech sees a radio role.
    //
    // `inMutuallyExclusiveGroup: true` surfaces the radio group relationship
    // in the accessibility tree alongside the checked state.
    return Semantics(
      container: true,
      checked: _isSelected,
      enabled: !isDisabled,
      inMutuallyExclusiveGroup: true,
      child: MergeSemantics(child: anchor),
    );
  }
}
