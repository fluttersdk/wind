import 'package:flutter/foundation.dart';

import 'w_dynamic_state.dart';

/// Controller for external access to [WDynamic] state.
///
/// Allows reading/writing form values and listening for changes
/// from outside the dynamic widget tree.
///
/// ```dart
/// final controller = WDynamicController();
///
/// // Pre-fill values
/// controller.setValue('email', 'user@example.com');
///
/// // Read values
/// final email = controller.getValue('email');
///
/// // Listen for changes
/// final dispose = controller.addListener('email', (value) {
///   print('Email changed: $value');
/// });
///
/// // Clean up
/// controller.dispose();
/// ```
class WDynamicController {
  /// The internal state store.
  final WDynamicState state;

  /// Whether this controller owns the state (should dispose it).
  final bool _ownsState;

  /// Creates a controller with a new internal state.
  WDynamicController()
      : state = WDynamicState(),
        _ownsState = true;

  /// Creates a controller wrapping an existing state.
  WDynamicController.fromState(this.state) : _ownsState = false;

  /// Get a value by id.
  dynamic getValue(String id) => state.get(id);

  /// Set a value by id.
  void setValue(String id, dynamic value) => state.set(id, value);

  /// Get all current values.
  Map<String, dynamic> getAll() => state.getAll();

  /// Reset all values.
  void reset() => state.reset();

  /// Add a listener for a specific id. Returns a dispose function.
  VoidCallback addListener(String id, ValueChanged<dynamic> callback) {
    return state.addIdListener(id, callback);
  }

  /// Dispose the controller and its owned state.
  void dispose() {
    if (_ownsState) {
      state.dispose();
    }
  }
}
