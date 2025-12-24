import 'package:flutter/widgets.dart';
import '../state/wind_anchor_state.dart';
import '../state/wind_anchor_state_provider.dart';

/// A foundational widget that provides hover, focus, and disabled states to its descendants.
///
/// `WAnchor` is the cornerstone of Wind's state-based styling system. It detects
/// user interactions such as hovering, focusing, and gestures (`onTap`, `onLongPress`,
/// `onDoubleTap`), and makes this state available to any descendant widget through
/// a `WindStateProvider`.
///
/// This allows widgets like `WDiv` and `WText` to dynamically change their
/// appearance using `hover:`, `focus:`, and `disabled:` style variants, without
/// needing to manage the state themselves.
///
/// ### State Propagation
/// When the state of `WAnchor` changes (e.g., a user hovers over it), it rebuilds
/// and passes the new `WindPressableState` down the tree. Any descendant widget
/// that uses `WindStateProvider.of(context)` will be rebuilt with the new state,
/// allowing for dynamic and efficient UI updates.
///
/// ### Usage
///
/// Wrap any widget or tree of widgets with `WAnchor` to enable state-based
/// styling within that tree.
///
/// ```dart
/// WAnchor(
///   onTap: () => print('Anchor tapped!'),
///   isDisabled: false,
///   child: WDiv(
///     // This text will be blue by default, red on hover, and gray when disabled.
///     className: 'text-blue-500 hover:text-red-500 disabled:text-gray-400',
///     child: WText('Interact with me!'),
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
  /// When `true`, all gesture callbacks (`onTap`, `onLongPress`, `onDoubleTap`)
  /// are ignored, hover and focus events are suppressed, and the `disabled:`
  /// state is propagated to descendant widgets. This is useful for temporarily
  /// disabling a component without changing its appearance logic.
  final bool isDisabled;

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
    );

    return WindAnchorStateProvider(
      state: currentState,
      child: MouseRegion(
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

