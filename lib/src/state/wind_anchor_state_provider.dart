import 'package:flutter/material.dart';

import 'wind_anchor_state.dart';

/// **The State Propagator**
///
/// `WindAnchorStateProvider` is an [InheritedWidget] that bubbles up the current
/// [WindAnchorState] to all its descendants.
///
/// This allows widgets deep in the tree to know if they are being hovered or focused
/// without explicitly passing `isHovering` parameters down every level.
///
/// ### How it works:
///
/// 1.  `WAnchor` detects a hover/focus event.
/// 2.  It wraps its children in a `WindAnchorStateProvider` with new state.
/// 3.  Descendants call `WindAnchorStateProvider.of(context)` to read the state.
class WindAnchorStateProvider extends InheritedWidget {
  /// The current pressable state being provided to descendants.
  final WindAnchorState state;

  /// Creates a `WindStateProvider` to hold the given [state].
  ///
  /// The [state] and [child] arguments are required.
  const WindAnchorStateProvider({
    super.key,
    required this.state,
    required super.child,
  });

  /// Retrieves the nearest `WindPressableState` from an ancestor `WindStateProvider`.
  ///
  /// This method subscribes the calling `BuildContext` to changes in the
  /// `WindStateProvider`. When the state changes, the dependent widget will be
  /// rebuilt.
  ///
  /// If no `WindStateProvider` is found in the ancestry, it returns `null`.
  ///
  /// ### Example
  /// ```dart
  /// final pressableState = WindStateProvider.of(context);
  /// final isHovering = pressableState?.isHovering ?? false;
  /// ```
  static WindAnchorState? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<WindAnchorStateProvider>()
        ?.state;
  }

  /// Determines whether the framework should notify widgets that inherit from this widget.
  ///
  /// This method is called when the `WindStateProvider` is rebuilt. It compares
  /// the old state with the new state. If they are different, it returns `true`,
  /// triggering a rebuild of dependent widgets.
  @override
  bool updateShouldNotify(WindAnchorStateProvider oldWidget) {
    return oldWidget.state != state;
  }
}
