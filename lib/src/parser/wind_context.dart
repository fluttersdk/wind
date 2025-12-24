import 'package:flutter/material.dart';

import '../core/platform_service.dart';
import '../state/wind_anchor_state.dart';
import '../state/wind_anchor_state_provider.dart';
import '../theme/wind_theme.dart';
import '../theme/wind_theme_data.dart';

/// WindContext holds contextual information for styling components
/// such as the active theme, breakpoint, platform, and interaction states.
///
/// This class is typically constructed via the static `build` method,
/// which extracts the necessary information from the provided `BuildContext`.
///
/// Example usage:
/// ```dart
/// final windContext = WindContext.build(context);
/// ```
///
/// This allows components to adapt their styles based on the current
/// environment and user interactions.
@immutable
class WindContext {
  final WindThemeData theme;
  final String activeBreakpoint;

  final double screenWidth;
  final double screenHeight;

  final String platform;
  final bool isMobile;

  final bool isHovering;
  final bool isFocused;
  final bool isDisabled;

  const WindContext({
    required this.theme,
    required this.activeBreakpoint,
    required this.screenWidth,
    required this.screenHeight,
    required this.platform,
    required this.isMobile,
    required this.isHovering,
    required this.isFocused,
    required this.isDisabled,
  });

  factory WindContext.build(BuildContext context) {
    final theme = WindTheme.of(context);
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    final platformService = WindPlatformService();

    final pressableState =
        WindAnchorStateProvider.of(context) ?? WindAnchorState.none;

    return WindContext(
      theme: theme,
      activeBreakpoint: _calculateActiveBreakpoint(screenWidth, theme.screens),
      platform: platformService.platform,
      screenWidth: screenWidth,
      screenHeight: screenHeight,
      isMobile: platformService.isMobile,
      isHovering: pressableState.isHovering,
      isFocused: pressableState.isFocused,
      isDisabled: pressableState.isDisabled,
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
    return "$className:$activeBreakpoint:${theme.brightness}:$isHovering:$isFocused:$isDisabled:$platform";
  }
}
