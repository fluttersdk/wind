import 'package:flutter/widgets.dart';

/// Signals that the nearest flex ancestor has a scrollable main axis, so
/// direct flex children must skip `Expanded`/`Flexible` wrapping (those
/// widgets require bounded main-axis constraints and assert inside
/// `overflow-x-auto` / `overflow-y-auto` rows/columns).
///
/// Every `WDiv` that builds a `Row`/`Column` installs this scope for its
/// children, either with [skipExpanded] `true` (scrollable main axis) or
/// `false` (resets the scope so deeper flex subtrees behave normally).
class WindFlexOverflowScope extends InheritedWidget {
  /// Whether direct flex children should skip `Expanded`/`Flexible`.
  final bool skipExpanded;

  const WindFlexOverflowScope({
    super.key,
    required this.skipExpanded,
    required super.child,
  });

  /// Returns the nearest [WindFlexOverflowScope] and subscribes so dependents
  /// rebuild when `skipExpanded` changes (e.g. parent toggles overflow via
  /// `setState`).
  static WindFlexOverflowScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<WindFlexOverflowScope>();
  }

  @override
  bool updateShouldNotify(WindFlexOverflowScope oldWidget) {
    return oldWidget.skipExpanded != skipExpanded;
  }
}
