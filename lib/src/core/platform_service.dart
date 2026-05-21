import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

/// Service to determine the current platform and whether it's mobile.
/// Usage:
///  final platformService = WindPlatformService();
///  print(platformService.platform); // e.g., "ios", "android", "web", etc.
///  print(platformService.isMobile); // true or false
class WindPlatformService {
  // Private constructor
  WindPlatformService._internal() {
    _initialize();
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

  // Initialize platform information
  void _initialize() {
    if (kIsWeb) {
      platform = "web";
      isMobile = false;
      return;
    }

    if (Platform.isIOS) {
      // CI runs on Linux + dev on macOS; iOS body unreachable from flutter_test on the host.
      platform = "ios"; // coverage:ignore-line
      isMobile = true; // coverage:ignore-line
    } else if (Platform.isAndroid) {
      // CI runs on Linux + dev on macOS; Android body unreachable from flutter_test on the host.
      platform = "android"; // coverage:ignore-line
      isMobile = true; // coverage:ignore-line
    } else if (Platform.isLinux) {
      platform = "linux"; // NO pragma; reachable on CI host.
      isMobile = false; // NO pragma; reachable on CI host.
    } else if (Platform.isMacOS) {
      platform = "macos"; // NO pragma; reachable on dev host.
      isMobile = false; // NO pragma; reachable on dev host.
    } else if (Platform.isWindows) {
      // Wind has no Windows CI runner or dev host; Windows body unreachable from flutter_test in this project.
      platform = "windows"; // coverage:ignore-line
      isMobile = false; // coverage:ignore-line
    } else {
      // Fallback for unknown platforms; not reachable from any test host this project supports.
      platform = "unknown"; // coverage:ignore-line
      isMobile = false; // coverage:ignore-line
    }
  }
}
