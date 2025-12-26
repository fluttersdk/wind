import 'package:flutter/widgets.dart';

/// **SelectOption - Data Model for WSelect Options**
///
/// A generic data class that represents a single option in a [WSelect] dropdown.
///
/// ### Example Usage:
///
/// ```dart
/// final options = [
///   SelectOption(value: 'us', label: 'United States'),
///   SelectOption(value: 'uk', label: 'United Kingdom'),
///   SelectOption(value: 'ca', label: 'Canada', disabled: true),
/// ];
/// ```
///
/// ### With Icons:
///
/// ```dart
/// final options = [
///   SelectOption(
///     value: 'apple',
///     label: 'Apple',
///     icon: Icon(Icons.apple, size: 16),
///   ),
///   SelectOption(
///     value: 'android',
///     label: 'Android',
///     icon: Icon(Icons.android, size: 16),
///   ),
/// ];
/// ```

/// A data model representing a single option in a [WSelect] dropdown.
///
/// Each option has a [value] of type [T], a display [label], an optional
/// [disabled] flag, and an optional [icon] widget.
class SelectOption<T> {
  /// The actual value of this option.
  ///
  /// This is the value that will be passed to [WSelect.onChange] when selected.
  final T value;

  /// The display label shown to the user.
  final String label;

  /// Whether this option is disabled and cannot be selected.
  ///
  /// Disabled options are visually distinct and cannot be tapped.
  final bool disabled;

  /// Optional icon to display alongside the label.
  ///
  /// The icon is rendered before the label in the default item rendering.
  final Widget? icon;

  /// Creates a new [SelectOption] instance.
  ///
  /// The [value] and [label] are required. [disabled] defaults to `false`.
  const SelectOption({
    required this.value,
    required this.label,
    this.disabled = false,
    this.icon,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SelectOption<T> &&
        other.value == value &&
        other.label == label &&
        other.disabled == disabled;
  }

  @override
  int get hashCode => Object.hash(value, label, disabled);

  @override
  String toString() =>
      'SelectOption(value: $value, label: $label, disabled: $disabled)';
}
