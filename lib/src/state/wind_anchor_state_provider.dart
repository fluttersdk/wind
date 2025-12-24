import 'package:flutter/material.dart';

import 'wind_anchor_state.dart';

/// An `InheritedWidget` that provides `WindPressableState` to its descendants.
///
/// `WindStateProvider` is the core mechanism for propagating hover and focus
/// states down the widget tree. It is designed to be used by `WAnchor` and
/// is not typically instantiated directly.
///
/// Descendant widgets, such as `WDiv` or `WText`, can access the state by calling
/// `WindStateProvider.of(context)`. This allows them to react to state changes
/// and apply `hover:` or `focus:` styles without direct prop drilling.
///
/// This is a private implementation detail of the Wind framework and is not
/// intended for public use.
class WindAnchorStateProvider extends InheritedWidget {
  /// The current pressable state being provided to descendants.
  final WindAnchorState state;

  /// Creates a `WindStateProvider` to hold the given [state].
  ///
  /// The [state] and [child] arguments are required.
  const WindAnchorStateProvider({
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

