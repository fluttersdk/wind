import 'package:flutter/foundation.dart';

/// An immutable class representing the pressable state of a widget.
///
/// This class holds boolean flags for hover, focus, and disabled states. It is used
/// by `WindStateProvider` to propagate the state down the widget tree.
///
/// It overrides `==` and `hashCode` to ensure correct behavior when used.
@immutable
class WindAnchorState {
  /// Whether the widget is currently being hovered over.
  final bool isHovering;

  /// Whether the widget currently has focus.
  final bool isFocused;

  /// Whether the widget is disabled.
  final bool isDisabled;

  /// Custom states for dynamic styling (e.g., 'error', 'success', 'loading').
  ///
  /// These are propagated to child widgets and activate their corresponding
  /// prefix classes (e.g., `error:border-red-500`).
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
