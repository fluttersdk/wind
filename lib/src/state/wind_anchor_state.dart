import 'package:flutter/foundation.dart';

/// **The State Snapshot**
///
/// `WindAnchorState` gives you a point-in-time snapshot of user interactions.
/// It works hand-in-hand with [WAnchor] and [WindStateProvider].
///
/// ### Properties:
/// - **isHovering:** True when mouse is over the widget.
/// - **isFocused:** True when the widget has keyboard focus.
/// - **isDisabled:** True when interactions are blocked.
/// - **customStates:** Set of user-defined states like `selected` or `loading`.
///
/// This object is immutable and typically accessed via `WindStateProvider.of(context)`.
@immutable
class WindAnchorState {
  /// Whether the mouse pointer is hovering over the widget.
  final bool isHovering;

  /// Whether the widget has keyboard focus.
  final bool isFocused;

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
        other.isDisabled == isDisabled &&
        setEquals(other.customStates, customStates);
  }

  /// Overrides the hash code to generate a unique hash based on the properties.
  @override
  int get hashCode =>
      isHovering.hashCode ^
      isFocused.hashCode ^
      isDisabled.hashCode ^
      (customStates == null ? 0 : Object.hashAllUnordered(customStates!));
}
