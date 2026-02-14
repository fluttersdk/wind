import 'package:flutter/widgets.dart';

/// Builder function for custom widget types.
typedef WindWidgetBuilder = Widget Function(
  Map<String, dynamic> props,
  List<Widget> children,
);

/// Configuration for [WindDynamic] rendering.
class WindDynamicConfig {
  /// Default Wind widget types that are always available.
  static const Set<String> defaultWindWidgets = {
    'WDiv',
    'WText',
    'WButton',
    'WImage',
    'WIcon',
    'WAnchor',
    'WInput',
    'WCheckbox',
    'WSvg',
    'WSelect',
    'WPopover',
    'WDatePicker',
    'WSpacer',
  };

  /// Flutter core widget types supported as convenience.
  static const Set<String> defaultFlutterWidgets = {
    'Column',
    'Row',
    'Center',
    'SizedBox',
    'Expanded',
    'Container',
    'Wrap',
    'Stack',
    'Positioned',
    'Padding',
    'Align',
    'Opacity',
    'AspectRatio',
    'FittedBox',
    'ClipRRect',
    'Spacer',
  };

  /// Widget types to deny (remove from default whitelist).
  final Set<String> denyWidgets;

  /// Custom widget builders keyed by type name.
  final Map<String, WindWidgetBuilder> builders;

  /// Maximum recursion depth for nested widgets.
  final int maxDepth;

  /// Called when a widget type is not allowed or unknown.
  final Widget Function(String type, Map<String, dynamic> props)?
      onUnknownWidget;

  /// Called when a widget build throws an error.
  final Widget Function(String type, Object error)? onError;

  const WindDynamicConfig({
    this.denyWidgets = const {},
    this.builders = const {},
    this.maxDepth = 50,
    this.onUnknownWidget,
    this.onError,
  });

  /// Check if a widget type is allowed to render.
  bool isAllowed(String type) {
    if (builders.containsKey(type)) return true;
    if (denyWidgets.contains(type)) return false;
    return defaultWindWidgets.contains(type) ||
        defaultFlutterWidgets.contains(type);
  }
}
