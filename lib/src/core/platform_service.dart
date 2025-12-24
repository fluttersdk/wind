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
      platform = "ios";
      isMobile = true;
    } else if (Platform.isAndroid) {
      platform = "android";
      isMobile = true;
    } else if (Platform.isLinux) {
      platform = "linux";
      isMobile = false;
    } else if (Platform.isMacOS) {
      platform = "macos";
      isMobile = false;
    } else if (Platform.isWindows) {
      platform = "windows";
      isMobile = false;
    } else {
      platform = "unknown";
      isMobile = false;
    }
  }
}
