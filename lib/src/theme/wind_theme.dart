import 'package:flutter/material.dart';

import '../core/platform_service.dart';
import 'wind_theme_data.dart';

/// **Theme Controller**
///
/// `WindThemeController` is a [ChangeNotifier] that manages the [WindThemeData]
/// and notifies listeners when the theme changes.
///
/// Use [toggleTheme] to switch between light and dark modes.
/// Use [setTheme] to replace the entire theme data.
///
/// ### Example Usage:
///
/// ```dart
/// // Toggle between light and dark
/// WindTheme.of(context).toggleTheme();
///
/// // Set a completely new theme
/// WindTheme.of(context).setTheme(WindThemeData(
///   brightness: Brightness.dark,
///   colors: {'primary': Colors.indigo},
/// ));
/// ```
class WindThemeController extends ChangeNotifier {
  WindThemeData _data;

  /// Creates a new [WindThemeController] with the given [data].
  WindThemeController(this._data);

  /// The current theme data.
  WindThemeData get data => _data;

  /// Convenience getters for commonly accessed properties.
  Brightness get brightness => _data.brightness;
  Map<String, MaterialColor> get colors => _data.colors;
  Map<String, int> get screens => _data.screens;
  Map<String, double> get fontSizes => _data.fontSizes;
  Map<String, FontWeight> get fontWeights => _data.fontWeights;
  Map<String, String> get fontFamilies => _data.fontFamilies;
  Map<String, double> get borderWidths => _data.borderWidths;
  Map<String, double> get borderRadius => _data.borderRadius;
  double get baseSpacingUnit => _data.baseSpacingUnit;

  /// Toggles between light and dark themes.
  ///
  /// When called, this also disables [syncWithSystem] on the theme data,
  /// preventing system brightness changes from overriding the user's
  /// manual preference. Use [resetToSystem] to re-enable automatic sync.
  ///
  /// This will notify all listeners and trigger a rebuild of the widget tree.
  void toggleTheme() {
    _data = _data.toggleTheme().copyWith(syncWithSystem: false);
    notifyListeners();
  }

  /// Sets a new theme data.
  ///
  /// This will notify all listeners and trigger a rebuild of the widget tree.
  void setTheme(WindThemeData newData) {
    if (_data != newData) {
      _data = newData;
      notifyListeners();
    }
  }

  /// Updates the current theme using [copyWith].
  ///
  /// This is useful for making partial updates to the theme.
  void updateTheme({
    Brightness? brightness,
    Map<String, MaterialColor>? colors,
    Map<String, int>? screens,
    Map<String, double>? fontSizes,
    Map<String, FontWeight>? fontWeights,
    Map<String, String>? fontFamilies,
    Map<String, double>? borderWidths,
    Map<String, double>? borderRadius,
    double? baseSpacingUnit,
  }) {
    _data = _data.copyWith(
      brightness: brightness,
      colors: colors,
      screens: screens,
      fontSizes: fontSizes,
      fontWeights: fontWeights,
      fontFamilies: fontFamilies,
      borderWidths: borderWidths,
      borderRadius: borderRadius,
      baseSpacingUnit: baseSpacingUnit,
    );
    notifyListeners();
  }

  /// Returns the [ThemeData] for use with MaterialApp.
  ThemeData toThemeData() => _data.toThemeData();

  /// Resets the theme to follow the system brightness.
  ///
  /// Re-enables [syncWithSystem] and immediately syncs with the current
  /// platform brightness. After calling this, system brightness changes
  /// will automatically update the theme again.
  void resetToSystem() {
    final systemBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    _data = _data.copyWith(
      syncWithSystem: true,
      brightness: systemBrightness,
    );
    notifyListeners();
  }
}

/// Internal InheritedNotifier for propagating theme changes.
class _WindThemeInherited extends InheritedNotifier<WindThemeController> {
  const _WindThemeInherited({
    required WindThemeController controller,
    required super.child,
  }) : super(notifier: controller);

  WindThemeController get controller => notifier!;
}

/// **The Theme Provider**
///
/// `WindTheme` is a widget that provides the styling configuration
/// to the entire widget tree. It uses [WindThemeController] internally
/// to support reactive theme updates.
///
/// Wrap your app in a `WindTheme` to customize colors, fonts, breakpoints, etc.
///
/// ### Example Usage:
///
/// ```dart
/// WindTheme(
///   data: WindThemeData(
///     colors: {
///       'primary': Colors.blue,
///     },
///     fontFamilies: {
///       'sans': 'Inter',
///     },
///   ),
///   builder: (context, controller) => MaterialApp(
///     theme: controller.toThemeData(),
///     home: MyHomePage(),
///   ),
/// )
/// ```
///
/// ### Toggling Theme:
///
/// ```dart
/// // Anywhere in your app:
/// WindTheme.of(context).toggleTheme();
/// ```
class WindTheme extends StatefulWidget {
  /// The initial theme data.
  ///
  /// Defaults to [WindThemeData()] if not provided.
  final WindThemeData? data;

  /// The child widget (use this OR builder, not both).
  final Widget? child;

  /// Builder that provides the controller for reactive MaterialApp binding.
  ///
  /// Use this when you need the MaterialApp theme to update reactively:
  /// ```dart
  /// WindTheme(
  ///   data: windTheme,
  ///   builder: (context, controller) => MaterialApp(
  ///     theme: controller.toThemeData(),
  ///     // ...
  ///   ),
  /// )
  /// ```
  final Widget Function(BuildContext context, WindThemeController controller)?
      builder;

  /// Callback fired when the user manually changes the theme.
  ///
  /// This is called when [toggleTheme] is invoked on the controller,
  /// NOT when the system brightness changes automatically.
  ///
  /// Use this to persist the user's theme preference externally:
  /// ```dart
  /// WindTheme(
  ///   onThemeChanged: (brightness) {
  ///     Vault.set('theme_mode', brightness == Brightness.dark ? 'dark' : 'light');
  ///   },
  ///   // ...
  /// )
  /// ```
  final ValueChanged<Brightness>? onThemeChanged;

  /// Creates a new [WindTheme] instance.
  ///
  /// [data] defaults to [WindThemeData()] if not provided.
  const WindTheme({
    super.key,
    this.data,
    this.child,
    this.builder,
    this.onThemeChanged,
  }) : assert(
           child != null || builder != null,
           'Either child or builder must be provided',
         );

  /// Returns the [WindThemeController] from the closest [WindTheme] ancestor.
  ///
  /// Use this to toggle theme, update theme data, or access theme properties.
  ///
  /// Example:
  /// ```dart
  /// WindTheme.of(context).toggleTheme();
  /// WindTheme.of(context).data.colors['primary'];
  /// ```
  static WindThemeController of(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<_WindThemeInherited>();
    assert(inherited != null, 'No WindTheme found in context');
    return inherited!.controller;
  }

  /// Returns only the [WindThemeData] without listening to changes.
  ///
  /// Use this when you only need to read theme data without rebuilding
  /// when the theme changes.
  static WindThemeData dataOf(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<_WindThemeInherited>();
    assert(inherited != null, 'No WindTheme found in context');
    return inherited!.controller.data;
  }

  @override
  State<WindTheme> createState() => _WindThemeState();
}

class _WindThemeState extends State<WindTheme> with WidgetsBindingObserver {
  late WindThemeController _controller;

  /// Tracks whether the current theme change originated from the system.
  /// When true, [onThemeChanged] will NOT fire.
  bool _isSystemChange = false;

  /// Previous brightness — used to detect actual changes.
  Brightness? _previousBrightness;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WindPlatformService();

    // Initialize with provided data or defaults
    var initialData = widget.data ?? WindThemeData();

    // Sync with system brightness on startup (only if syncWithSystem is true)
    // We do this to ensure "Auto" behavior by default
    if (initialData.syncWithSystem) {
      final systemBrightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      initialData = initialData.copyWith(brightness: systemBrightness);
    }

    _controller = WindThemeController(initialData);
    _previousBrightness = _controller.brightness;

    // Listen for controller changes to fire onThemeChanged callback
    _controller.addListener(_onControllerChanged);
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    // Update theme when system brightness changes (only if syncWithSystem is
    // true). Mark as system-initiated so onThemeChanged does NOT fire.
    if (_controller.data.syncWithSystem) {
      _isSystemChange = true;
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      _controller.updateTheme(brightness: brightness);
      _isSystemChange = false;
    }
  }

  @override
  void didUpdateWidget(WindTheme oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != null && widget.data != oldWidget.data) {
      _controller.setTheme(widget.data!);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  /// Detects user-initiated brightness changes and fires [onThemeChanged].
  void _onControllerChanged() {
    final currentBrightness = _controller.brightness;
    if (currentBrightness != _previousBrightness && !_isSystemChange) {
      widget.onThemeChanged?.call(currentBrightness);
    }
    _previousBrightness = currentBrightness;
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (widget.builder != null) {
      // Use ListenableBuilder to rebuild when controller changes
      child = ListenableBuilder(
        listenable: _controller,
        builder: (context, _) => widget.builder!(context, _controller),
      );
    } else {
      child = widget.child!;
    }

    // Apply default font family if configured
    final data = _controller.data;
    if (data.applyDefaultFontFamily) {
      final defaultFont = data.fontFamilies['sans'];
      if (defaultFont != null) {
        child = DefaultTextStyle.merge(
          style: TextStyle(fontFamily: defaultFont),
          child: child,
        );
      }
    }

    return _WindThemeInherited(controller: _controller, child: child);
  }
}
