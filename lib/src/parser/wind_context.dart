import 'package:flutter/material.dart';

import '../core/platform_service.dart';
import '../state/wind_anchor_state.dart';
import '../state/wind_anchor_state_provider.dart';
import '../theme/wind_theme.dart';
import '../theme/wind_theme_data.dart';

/// **The styling context context**
///
/// `WindContext` holds all environmental factors required to resolve styles:
///
/// 1.  **Theme:** The active [WindThemeData].
/// 2.  **Responsiveness:** Current screen width and active breakpoint (sm, md, lg).
/// 3.  **Platform:** Current OS (mobile vs web) for platform prefixes.
/// 4.  **Interaction:** Active states (`hover`, `focus`) and custom states (`loading`).
///
/// It acts as the "Input" state for the `WindParser`.
///
/// ### State-Based Styling
///
/// Wind uses a unified state set `activeStates`. Built-in states like `hover`
/// are automatically populated from [WAnchor]. Custom states can be passed manually.
///
/// Example:
/// ```dart
/// // The context will contain {'hover', 'focus'} if the user is interacting
/// final context = WindContext.build(context, states: {'custom-state'});
/// ```
@immutable
class WindContext {
  final WindThemeData theme;
  final String activeBreakpoint;

  final double screenWidth;
  final double screenHeight;

  final String platform;
  final bool isMobile;

  /// Unified state set containing all active states.
  ///
  /// Built-in states: `hover`, `focus`, `disabled`
  /// Custom states: Any string passed via `states` parameter
  final Set<String> activeStates;

  const WindContext({
    required this.theme,
    required this.activeBreakpoint,
    required this.screenWidth,
    required this.screenHeight,
    required this.platform,
    required this.isMobile,
    this.activeStates = const {},
  });

  /// Whether the element is currently being hovered.
  bool get isHovering => activeStates.contains('hover');

  /// Whether the element currently has focus.
  bool get isFocused => activeStates.contains('focus');

  /// Whether the element is disabled.
  bool get isDisabled => activeStates.contains('disabled');

  /// Checks if a custom state is active.
  bool hasState(String state) => activeStates.contains(state);

  factory WindContext.build(BuildContext context, {Set<String>? states}) {
    final theme = WindTheme.of(context);
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    final platformService = WindPlatformService();

    final pressableState =
        WindAnchorStateProvider.of(context) ?? WindAnchorState.none;

    // Build unified activeStates set
    final Set<String> builtStates = {
      if (pressableState.isHovering) 'hover',
      if (pressableState.isFocused) 'focus',
      if (pressableState.isDisabled) 'disabled',
      ...?states, // Merge custom states
    };

    return WindContext(
      theme: theme,
      activeBreakpoint: _calculateActiveBreakpoint(screenWidth, theme.screens),
      platform: platformService.platform,
      screenWidth: screenWidth,
      screenHeight: screenHeight,
      isMobile: platformService.isMobile,
      activeStates: builtStates,
    );
  }

  static String _calculateActiveBreakpoint(
    double screenWidth,
    Map<String, int> screens,
  ) {
    String activeBreakpoint = 'base';

    final sortedScreens = screens.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    for (final entry in sortedScreens) {
      if (screenWidth >= entry.value) {
        activeBreakpoint = entry.key;
      } else {
        break;
      }
    }
    return activeBreakpoint;
  }

  /// Generates a unique cache key based on the current context and class name.
  String cacheKey(String? className) {
    final sortedStates = activeStates.toList()..sort();
    final statesKey = sortedStates.isEmpty ? '' : ':${sortedStates.join(',')}';
    return "$className:$activeBreakpoint:${theme.brightness}:$platform$statesKey";
  }
}
