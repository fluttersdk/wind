import 'package:flutter/widgets.dart';

import '../core/platform_service.dart';
import 'wind_theme_data.dart';

/// An inherited widget that makes a [WindThemeData] object available to
/// its descendants.
class WindTheme extends InheritedWidget {
  /// The theme data.
  late final WindThemeData data;

  /// Creates a new [WindTheme] instance.
  WindTheme({super.key, WindThemeData? data, required super.child}) {
    WindPlatformService();

    this.data = data ?? WindThemeData();
  }

  /// Returns the [WindThemeData] from the closest [WindTheme] ancestor.
  ///
  /// If no ancestor is found, it will throw an assertion error.
  static WindThemeData of(BuildContext context) {
    final WindTheme? result = context
        .dependOnInheritedWidgetOfExactType<WindTheme>();
    assert(result != null, 'No WindTheme found in context');
    return result!.data;
  }

  /// Determines whether the framework should notify widgets that inherit from
  /// this widget.
  @override
  bool updateShouldNotify(WindTheme oldWidget) {
    return data != oldWidget.data;
  }
}
