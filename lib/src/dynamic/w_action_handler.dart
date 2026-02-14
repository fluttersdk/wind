import 'dart:async';

import 'package:flutter/foundation.dart';

import 'wind_dynamic_state.dart';

/// Dispatches actions from dynamic widgets to registered handlers.
///
/// Supports two callback signatures:
/// - `(Map<String, dynamic> args)` — simple action without state
/// - `(Map<String, dynamic> args, WindDynamicState state)` — action with state access
class WindActionHandler {
  final Map<String, Function> _actions;
  final WindDynamicState _state;

  WindActionHandler({
    required Map<String, Function> actions,
    required WindDynamicState state,
  })  : _actions = actions,
        _state = state;

  /// Dispatch an action by name with arguments.
  ///
  /// Returns silently if the action is not registered (safe by design).
  FutureOr<void> dispatch(String actionName, Map<String, dynamic> args) {
    final handler = _actions[actionName];
    if (handler == null) {
      debugPrint('WindDynamic: Unknown action "$actionName" — ignored.');
      return null;
    }

    try {
      // Try stateful signature first (args, state), fallback to simple (args)
      if (handler is Function(Map<String, dynamic>, WindDynamicState)) {
        return handler(args, _state);
      } else if (handler is Function(Map<String, dynamic>)) {
        return handler(args);
      } else {
        // Attempt generic call
        return Function.apply(handler, [args, _state]);
      }
    } catch (e) {
      debugPrint('WindDynamic: Action "$actionName" error: $e');
    }
    return null;
  }

  /// Parse an action prop from JSON and return a VoidCallback.
  ///
  /// JSON format: `{"action": "actionName", "args": {...}}`
  VoidCallback? parseAction(dynamic actionProp) {
    if (actionProp is! Map) return null;
    final actionName = actionProp['action'];
    if (actionName is! String) return null;
    final args = actionProp['args'];
    final safeArgs = args is Map<String, dynamic>
        ? args
        : args is Map
            ? Map<String, dynamic>.from(args)
            : <String, dynamic>{};
    return () => dispatch(actionName, safeArgs);
  }

  /// Parse an action prop and return a typed callback for value changes.
  ///
  /// Merges the changed value into args under `_value` key.
  ValueChanged<T>? parseValueAction<T>(dynamic actionProp, {String? stateId}) {
    if (actionProp is! Map) return null;
    final actionName = actionProp['action'];
    if (actionName is! String) return null;
    final baseArgs = actionProp['args'];
    final safeBaseArgs = baseArgs is Map<String, dynamic>
        ? baseArgs
        : baseArgs is Map
            ? Map<String, dynamic>.from(baseArgs)
            : <String, dynamic>{};

    return (T value) {
      // Update state if this widget has an id
      if (stateId != null) {
        _state.set(stateId, value);
      }
      final args = {...safeBaseArgs, '_value': value};
      dispatch(actionName, args);
    };
  }
}
