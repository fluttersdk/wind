import 'package:flutter/foundation.dart';

/// Reactive state store for dynamic widget values.
///
/// Tracks form field values (inputs, checkboxes, selects) by their `id` prop.
/// Action handlers receive this state to read current form values.
class WDynamicState extends ChangeNotifier {
  final Map<String, dynamic> _values = {};
  final Map<String, List<ValueChanged<dynamic>>> _listeners = {};

  /// Get a value by id.
  dynamic get(String id) => _values[id];

  /// Set a value by id, notifying listeners.
  void set(String id, dynamic value) {
    final old = _values[id];
    if (old == value) return;
    _values[id] = value;
    notifyListeners();
    final idListeners = _listeners[id];
    if (idListeners != null) {
      for (final listener in idListeners) {
        listener(value);
      }
    }
  }

  /// Get all values as a map.
  Map<String, dynamic> getAll() => Map.unmodifiable(_values);

  /// Reset all values.
  void reset() {
    _values.clear();
    notifyListeners();
  }

  /// Add a listener for a specific id. Returns a dispose function.
  VoidCallback addIdListener(String id, ValueChanged<dynamic> callback) {
    _listeners.putIfAbsent(id, () => []).add(callback);
    return () => _listeners[id]?.remove(callback);
  }

  /// Whether a value exists for the given id.
  bool has(String id) => _values.containsKey(id);

  @override
  void dispose() {
    _listeners.clear();
    _values.clear();
    super.dispose();
  }
}
