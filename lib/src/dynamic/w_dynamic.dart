import 'package:flutter/widgets.dart';

import 'w_action_handler.dart';
import 'w_dynamic_config.dart';
import 'w_dynamic_controller.dart';
import 'w_dynamic_renderer.dart';
import 'w_dynamic_state.dart';

/// Main widget for rendering dynamic UI from JSON configuration.
///
/// Combines JSON parsing, state management, and action handling into a single
/// declarative widget. Supports Wind widgets, Flutter core widgets, and custom
/// widget builders.
///
/// Example:
/// ```dart
/// WDynamic(
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
class WDynamic extends StatefulWidget {
  /// JSON configuration defining the widget tree.
  final Map<String, dynamic> json;

  /// Action handlers keyed by name. Called when interactive widgets trigger events.
  /// Signature: `(Map<String, dynamic> args)` or `(Map<String, dynamic> args, WDynamicState state)`.
  final Map<String, Function> actions;

  /// Optional controller for external state access.
  final WDynamicController? controller;

  /// Widget types to deny (remove from default whitelist).
  final Set<String>? denyWidgets;

  /// Custom widget builders keyed by type name.
  final Map<String, WWidgetBuilder>? builders;

  /// Custom icon mappings keyed by name. Merged with built-in defaults.
  final Map<String, IconData>? customIcons;

  /// Maximum recursion depth for nested widgets. Default: 50.
  final int maxDepth;

  /// Called when a widget build throws an error.
  final Widget Function(String type, Object error)? onError;

  /// Called when a widget type is not allowed or unknown.
  final Widget Function(String type, Map<String, dynamic> props)?
      onUnknownWidget;

  const WDynamic({
    super.key,
    required this.json,
    this.actions = const {},
    this.controller,
    this.denyWidgets,
    this.builders,
    this.customIcons,
    this.maxDepth = 50,
    this.onError,
    this.onUnknownWidget,
  });

  @override
  State<WDynamic> createState() => _WDynamicState();
}

class _WDynamicState extends State<WDynamic> {
  late final WDynamicState _state;
  late final bool _ownsState;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _state = widget.controller!.state;
      _ownsState = false;
    } else {
      _state = WDynamicState();
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
    final config = WDynamicConfig(
      denyWidgets: widget.denyWidgets ?? const {},
      builders: widget.builders ?? const {},
      customIcons: widget.customIcons ?? const {},
      maxDepth: widget.maxDepth,
      onError: widget.onError,
      onUnknownWidget: widget.onUnknownWidget,
    );

    final actionHandler = WActionHandler(
      actions: widget.actions,
      state: _state,
    );

    final renderer = WDynamicRenderer(
      config: config,
      actionHandler: actionHandler,
      state: _state,
    );

    return renderer.build(widget.json);
  }
}
