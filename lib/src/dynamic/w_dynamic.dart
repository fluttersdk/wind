import 'package:flutter/widgets.dart';

import 'wind_action_handler.dart';
import 'wind_dynamic_config.dart';
import 'wind_dynamic_controller.dart';
import 'wind_dynamic_renderer.dart';
import 'wind_dynamic_state.dart';

/// Main widget for rendering dynamic UI from JSON configuration.
///
/// Combines JSON parsing, state management, and action handling into a single
/// declarative widget. Supports Wind widgets, Flutter core widgets, and custom
/// widget builders.
///
/// Example:
/// ```dart
/// WindDynamic(
///   json: {
///     "type": "WDiv",
///     "props": {"className": "flex gap-4 p-6"},
///     "children": [
///       {
///         "type": "WButton",
///         "props": {
///           "className": "bg-blue-500 text-white px-4 py-2 rounded",
///           "onTap": {"action": "handleSubmit", "args": {"formId": "login"}}
///         },
///         "children": [
///           {"type": "WText", "props": {"text": "Submit"}}
///         ]
///       }
///     ]
///   },
///   actions: {
///     'handleSubmit': (args, state) {
///       print('Form submitted: ${state.getAll()}');
///     },
///   },
/// )
/// ```
class WindDynamic extends StatefulWidget {
  /// JSON configuration defining the widget tree.
  final Map<String, dynamic> json;

  /// Action handlers keyed by name. Called when interactive widgets trigger events.
  /// Signature: `(Map<String, dynamic> args)` or `(Map<String, dynamic> args, WindDynamicState state)`.
  final Map<String, Function> actions;

  /// Optional controller for external state access.
  final WindDynamicController? controller;

  /// Widget types to deny (remove from default whitelist).
  final Set<String>? denyWidgets;

  /// Custom widget builders keyed by type name.
  final Map<String, WindWidgetBuilder>? builders;

  /// Maximum recursion depth for nested widgets. Default: 50.
  final int maxDepth;

  /// Called when a widget build throws an error.
  final Widget Function(String type, Object error)? onError;

  /// Called when a widget type is not allowed or unknown.
  final Widget Function(String type, Map<String, dynamic> props)?
      onUnknownWidget;

  const WindDynamic({
    super.key,
    required this.json,
    this.actions = const {},
    this.controller,
    this.denyWidgets,
    this.builders,
    this.maxDepth = 50,
    this.onError,
    this.onUnknownWidget,
  });

  @override
  State<WindDynamic> createState() => _WindDynamicState();
}

class _WindDynamicState extends State<WindDynamic> {
  late final WindDynamicState _state;
  late final bool _ownsState;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _state = widget.controller!.state;
      _ownsState = false;
    } else {
      _state = WindDynamicState();
      _ownsState = true;
    }
  }

  @override
  void dispose() {
    if (_ownsState) {
      _state.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = WindDynamicConfig(
      denyWidgets: widget.denyWidgets ?? const {},
      builders: widget.builders ?? const {},
      maxDepth: widget.maxDepth,
      onError: widget.onError,
      onUnknownWidget: widget.onUnknownWidget,
    );

    final actionHandler = WindActionHandler(
      actions: widget.actions,
      state: _state,
    );

    final renderer = WindDynamicRenderer(
      config: config,
      actionHandler: actionHandler,
      state: _state,
    );

    return renderer.build(widget.json);
  }
}
