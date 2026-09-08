import 'package:flutter/foundation.dart';

/// **The State Snapshot**
///
/// `WindAnchorState` gives you a point-in-time snapshot of user interactions.
/// It works hand-in-hand with [WAnchor] and [WindStateProvider].
///
/// ### Properties:
/// - **isHovering:** True when mouse is over the widget.
/// - **isFocused:** True when the widget, or anything inside it, has keyboard
///   focus.
/// - **hasPrimaryFocus:** True when the widget, or the control it decorates,
///   is the focus. Never true merely because something inside it is.
/// - **isDisabled:** True when interactions are blocked.
/// - **customStates:** Set of user-defined states like `selected` or `loading`.
///
/// This object is immutable and typically accessed via `WindStateProvider.of(context)`.
@immutable
class WindAnchorState {
  /// Whether the mouse pointer is hovering over the widget.
  final bool isHovering;

  /// Whether the widget, or anything inside it, has keyboard focus.
  ///
  /// This is focus-WITHIN, because it comes from `FocusNode.hasFocus`, which is
  /// true for an ancestor of the node that actually holds focus. That is the
  /// right signal for a ring drawn around a text field's container, and the
  /// wrong one for asking "is this element the focus".
  final bool isFocused;

  /// Whether this widget, or the control it decorates, is the focus.
  ///
  /// Not the same as "this exact node holds focus", and the difference is
  /// deliberate. A gestureless [WAnchor] cannot request focus at all, so a
  /// styling wrapper reports the primary focus of the anchor it decorates,
  /// passing the signal on to any wrapper nested inside it. Without that a ring
  /// two wrappers deep stayed dark, and one `hover:` class on a div in between
  /// is enough to create the second wrapper.
  ///
  /// What it is never true for is containment. A tappable card holding a text
  /// field reports [isFocused] the whole time the user types, because that is
  /// focus-within; this stays false, which is what keeps a wrapper sitting
  /// BESIDE the field from lighting up with it.
  final bool hasPrimaryFocus;

  /// Whether the widget is disabled and ignoring interactions.
  final bool isDisabled;

  /// Custom states for dynamic styling.
  ///
  /// Examples:
  /// - `loading` -> activates `loading:` prefix
  /// - `selected` -> activates `selected:` prefix
  /// - `error` -> activates `error:` prefix
  final Set<String>? customStates;

  /// Creates a new instance of `WindPressableState`.
  ///
  /// All arguments are required.
  const WindAnchorState({
    required this.isHovering,
    required this.isFocused,
    required this.isDisabled,
    this.hasPrimaryFocus = false,
    this.customStates,
  });

  /// A constant representing the default state where no interactions are occurring.
  ///
  /// This is useful as a baseline state.
  static const WindAnchorState none = WindAnchorState(
    isHovering: false,
    isFocused: false,
    isDisabled: false,
  );

  /// Overrides the equality operator to compare instances based on their properties.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WindAnchorState &&
        other.isHovering == isHovering &&
        other.isFocused == isFocused &&
        other.hasPrimaryFocus == hasPrimaryFocus &&
        other.isDisabled == isDisabled &&
        setEquals(other.customStates, customStates);
  }

  /// Overrides the hash code to generate a unique hash based on the properties.
  @override
  int get hashCode =>
      isHovering.hashCode ^
      isFocused.hashCode ^
      hasPrimaryFocus.hashCode ^
      isDisabled.hashCode ^
      (customStates == null ? 0 : Object.hashAllUnordered(customStates!));
}
