import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb, visibleForTesting;

/// Service to determine the current platform and whether it's mobile.
/// Usage:
///  final platformService = WindPlatformService();
///  print(platformService.platform); // e.g., "ios", "android", "web", etc.
///  print(platformService.isMobile); // true or false
class WindPlatformService {
  // Private constructor
  WindPlatformService._internal() {
    final (resolvedPlatform, resolvedIsMobile) = resolvePlatform();
    platform = resolvedPlatform;
    isMobile = resolvedIsMobile;
  }

  // Singleton instance
  static final WindPlatformService _instance = WindPlatformService._internal();

  // Factory constructor to return the singleton instance
  factory WindPlatformService() => _instance;

  // Platform information
  // e.g., "ios", "android", "web", "linux", "macos", "windows", "unknown"
  late final String platform;

  // Whether the platform is mobile (iOS or Android)
  late final bool isMobile;

  /// Resolves the current platform name and mobile flag from Flutter's
  /// [defaultTargetPlatform]. Exposed for testing via
  /// [debugDefaultTargetPlatformOverride].
  @visibleForTesting
  static (String, bool) resolvePlatform() {
    if (kIsWeb) {
      // kIsWeb is always false under flutter test on a native host; this line
      // is structurally unreachable from flutter test.
      return ('web', false); // coverage:ignore-line
    }

    return switch (defaultTargetPlatform) {
      TargetPlatform.iOS => ('ios', true),
      TargetPlatform.android => ('android', true),
      TargetPlatform.linux => ('linux', false),
      TargetPlatform.macOS => ('macos', false),
      TargetPlatform.windows => ('windows', false),
      TargetPlatform.fuchsia => ('unknown', false),
    };
  }
}
