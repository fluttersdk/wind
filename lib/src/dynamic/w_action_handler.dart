import 'dart:async';

import 'package:flutter/foundation.dart';

import 'w_dynamic_state.dart';

/// Bridges JSON action definitions to Dart callback handlers in the dynamic module.
///
/// `WActionHandler` is the action dispatch system for Wind's dynamic widgets. It maps
/// string action names from JSON to registered Dart functions, enabling interactive
/// behavior in JSON-driven UIs without hardcoding widget logic.
///
/// ## Handler Signatures
///
/// Two callback signatures are supported:
///
/// **Simple handler** (no state access):
/// ```dart
/// (Map<String, dynamic> args) => void
/// ```
///
/// **Stateful handler** (with state access):
/// ```dart
/// (Map<String, dynamic> args, WDynamicState state) => void
/// ```
///
/// Both signatures can return `void` or `Future<void>` for async operations.
///
/// ## Dispatch Resolution
///
/// When `dispatch()` is called, the handler signature is resolved in this order:
///
/// 1. **Type check for stateful signature**: `Function(Map<String, dynamic>, WDynamicState)`
/// 2. **Type check for simple signature**: `Function(Map<String, dynamic>)`
/// 3. **Fallback to Function.apply**: Attempts generic invocation with `[args, state]`
///
/// If the action name is not registered, the call is silently ignored with a `debugPrint`.
/// If an exception occurs during handler execution, it is caught and logged via `debugPrint`.
///
/// ## Action Parsing
///
/// ### Simple Actions (parseAction)
///
/// Used for tap/click events that don't pass values. JSON shape:
///
/// ```json
/// {
///   "action": "actionName",
///   "args": {
///     "key": "value"
///   }
/// }
/// ```
///
/// Returns `VoidCallback?` that calls `dispatch(actionName, args)` when invoked.
///
/// ### Value Actions (parseValueAction)
///
/// Used for input changes, selections, and other value-emitting events. JSON shape:
///
/// ```json
/// {
///   "action": "actionName",
///   "args": {
///     "key": "value"
///   }
/// }
/// ```
///
/// Returns `ValueChanged<T>?` that:
/// 1. Updates `WDynamicState` if `stateId` is provided: `state.set(stateId, value)`
/// 2. Injects the changed value into args as `_value`
/// 3. Calls `dispatch(actionName, {...args, _value: value})`
///
/// ## State Integration
///
/// When `parseValueAction` is called with a `stateId`:
///
/// - The changed value is automatically written to `WDynamicState` before action dispatch
/// - The value is injected into action args under the `_value` key
/// - Widgets with matching `id` props will reactively rebuild with the new state value
///
/// This enables two-way data binding: widget → state → action handler.
///
/// ## Error Handling
///
/// **Unknown action**: If an action name is not in the registered actions map, the call
/// is silently ignored and a debug message is printed: `"Unknown action {name}, ignored."`
///
/// **Handler exception**: If a handler throws an exception, it is caught and logged:
/// `"Action {name} error: {exception}"`. The error does not propagate to the widget tree.
///
/// ## Example Usage
///
/// ```dart
/// final actionHandler = WActionHandler(
///   actions: {
///     'navigate': (args) {
///       final route = args['route'] as String;
///       Navigator.pushNamed(context, route);
///     },
///     'updateUser': (args, state) {
///       final field = args['field'] as String;
///       final value = args['_value']; // Injected by parseValueAction
///       print('Update $field to $value');
///       // Access other state values via state.get(id)
///     },
///     'submitForm': (args, state) async {
///       final email = state.get('email');
///       final password = state.get('password');
///       await api.login(email, password);
///     },
///   },
///   state: WDynamicState(),
/// );
///
/// // In JSON widget definition:
/// // {
/// //   "type": "WButton",
/// //   "props": {
/// //     "onTap": {"action": "navigate", "args": {"route": "/home"}}
/// //   }
/// // }
/// //
/// // {
/// //   "type": "WInput",
/// //   "props": {
/// //     "id": "email",
/// //     "onChange": {"action": "updateUser", "args": {"field": "email"}}
/// //   }
/// // }
/// ```
class WActionHandler {
  final Map<String, Function> _actions;
  final WDynamicState _state;

  WActionHandler({
    required Map<String, Function> actions,
    required WDynamicState state,
  })  : _actions = actions,
        _state = state;

  /// Dispatch a registered action handler with the provided arguments.
  ///
  /// Resolves the handler signature dynamically and invokes it with appropriate parameters.
  /// Unknown actions are silently ignored. Handler exceptions are caught and logged.
  FutureOr<void> dispatch(String actionName, Map<String, dynamic> args) {
    final handler = _actions[actionName];
    if (handler == null) {
      debugPrint('WindDynamic: Unknown action "$actionName", ignored.');
      return null;
    }

    try {
      // Try stateful signature first (args, state), fallback to simple (args)
      if (handler is Function(Map<String, dynamic>, WDynamicState)) {
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

  /// Parse a simple action from JSON and return a VoidCallback.
  ///
  /// Expects JSON shape: `{"action": "actionName", "args": {...}}`
  ///
  /// Returns `null` if the prop is not a Map or if `action` key is missing/invalid.
  /// The returned callback invokes `dispatch(actionName, args)` when called.
  ///
  /// Used for tap/click events that don't pass values (e.g., `onTap` on WButton).
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

  /// Parse a value action from JSON and return a typed ValueChanged callback.
  ///
  /// Expects JSON shape: `{"action": "actionName", "args": {...}}`
  ///
  /// Returns `null` if the prop is not a Map or if `action` key is missing/invalid.
  /// The returned callback performs these steps when invoked with a value:
  ///
  /// 1. If `stateId` is provided, updates state: `state.set(stateId, value)`
  /// 2. Injects the value into args as `_value`: `{...args, _value: value}`
  /// 3. Calls `dispatch(actionName, mergedArgs)`
  ///
  /// Used for input changes, selections, and other value-emitting events
  /// (e.g., `onChange` on WInput, WCheckbox, WSelect).
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
