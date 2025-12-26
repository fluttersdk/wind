import 'package:flutter/widgets.dart';
import '../state/wind_anchor_state.dart';
import '../state/wind_anchor_state_provider.dart';

/// **The Foundational State Wrapper**
///
/// `WAnchor` acts as the "Brain" for interaction state management in Wind.
/// It detects user gestures (Hover, Focus, Press) and propagates that state
/// down to all descendant widgets via `WindStateProvider`.
///
/// Use `WAnchor` when you want to enable `hover:`, `focus:`, or `disabled:`
/// styling on a `WDiv` or any custom widget.
///
/// ### Supported Features:
/// - **Hover Detection:** Activates `hover:` class prefix
/// - **Focus Management:** Activates `focus:` class prefix
/// - **Gestures:** `onTap`, `onLongPress`, `onDoubleTap`
/// - **Disabling:** `isDisabled` prop prevents all interactions
///
/// ### Example Usage:
///
/// ```dart
/// WAnchor(
///   onTap: () => print('Pressed'),
///   child: WDiv(
///     // Reacts to hover state provided by WAnchor
///     className: 'p-4 bg-white hover:bg-gray-100 transition-colors',
///     child: WText('Hover Me'),
///   ),
/// )
/// ```
@immutable
class WAnchor extends StatefulWidget {
  /// The widget that will receive the hover, focus, and gesture states.
  /// This is the interactive area of the `WAnchor`.
  final Widget child;

  /// An optional callback that is triggered when the widget is tapped.
  ///
  /// This callback is ignored if `isDisabled` is `true`.
  final VoidCallback? onTap;

  /// An optional callback that is triggered when the widget is long-pressed.
  ///
  /// This callback is ignored if `isDisabled` is `true`.
  final VoidCallback? onLongPress;

  /// An optional callback that is triggered when the widget is double-tapped.
  ///
  /// This callback is ignored if `isDisabled` is `true`.
  final VoidCallback? onDoubleTap;

  /// Determines whether the widget is interactive.
  ///
  /// When `true`:
  /// - All gestures (`onTap`, etc.) are ignored.
  /// - Hover and focus states are suppressed.
  /// - The `disabled:` prefix becomes active for descendants.
  final bool isDisabled;

  /// Custom states for dynamic styling.
  ///
  /// These states are propagated to descendants and allow for custom class prefixes.
  ///
  /// Example:
  /// - If `states` contains `'error'`, then `error:border-red-500` will activate.
  /// - If `states` contains `'active'`, then `active:bg-blue-600` will activate.
  final Set<String>? states;

  /// Creates a `WAnchor` widget.
  ///
  /// The [child] argument is required and represents the interactive area.
  /// By default, the widget is enabled ([isDisabled] is `false`).
  const WAnchor({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.isDisabled = false,
    this.states,
  });

  @override
  State<WAnchor> createState() => _WAnchorState();
}

/// The state for the [WAnchor] widget.
///
/// This class manages the internal state for `isHovering` and `isFocused`,
/// and handles the logic for updating these states based on user interaction.
class _WAnchorState extends State<WAnchor> {
  bool _isHovering = false;
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  /// Initializes the state and adds a listener to the `FocusNode` to track focus changes.
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  /// Cleans up the `FocusNode` and its listener to prevent memory leaks.
  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  /// Called when the focus state of the `FocusNode` changes.
  ///
  /// Updates the `_isFocused` state via `setState` if the widget is not disabled,
  /// which triggers a rebuild to propagate the new state.
  void _onFocusChange() {
    if (widget.isDisabled) return;
    if (_focusNode.hasFocus != _isFocused) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    }
  }

  /// Called when the mouse pointer enters or exits the `MouseRegion`.
  ///
  /// Updates the `_isHovering` state via `setState` if the widget is not disabled,
  /// which triggers a rebuild to propagate the new state.
  void _onHover(bool isHovering) {
    if (widget.isDisabled) return;
    if (isHovering != _isHovering) {
      setState(() {
        _isHovering = isHovering;
      });
    }
  }

  /// Builds the widget tree for `WAnchor`.
  ///
  /// This method constructs a `WindPressableState` from the current internal
  /// state (`_isHovering`, `_isFocused`, `widget.isDisabled`) and provides it
  /// to the widget's descendants using `WindStateProvider`.
  ///
  /// It wraps the `child` in a `MouseRegion` for hover detection and a
  /// `GestureDetector` for tap events, disabling them if `widget.isDisabled` is true.
  @override
  Widget build(BuildContext context) {
    final currentState = WindAnchorState(
      isHovering: _isHovering,
      isFocused: _isFocused,
      isDisabled: widget.isDisabled,
      customStates: widget.states,
    );

    return WindAnchorStateProvider(
      state: currentState,
      child: MouseRegion(
        cursor: widget.isDisabled
            ? SystemMouseCursors.basic
            : SystemMouseCursors.click,
        onEnter: widget.isDisabled ? null : (_) => _onHover(true),
        onExit: widget.isDisabled ? null : (_) => _onHover(false),
        child: GestureDetector(
          onTap: widget.isDisabled ? null : widget.onTap,
          onLongPress: widget.isDisabled ? null : widget.onLongPress,
          onDoubleTap: widget.isDisabled ? null : widget.onDoubleTap,
          child: Focus(
            focusNode: _focusNode,
            canRequestFocus: !widget.isDisabled,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
