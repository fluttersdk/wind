import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Tests for [WindPlatformService].
///
/// The service is a singleton — all tests share the same instance initialized
/// on first access. No reset is needed because the state is immutable after
/// `_initialize()` runs once.
///
/// Platform-branch coverage note: iOS, Android, Windows, and the unknown
/// fallback bodies are pragma'd in the source (`// coverage:ignore-line`).
/// The Linux body is hit on CI; the macOS body is hit on dev. These tests
/// use set-membership and consistency checks that pass on both hosts.
void main() {
  group('WindPlatformService', () {
    test('factory constructor returns the same singleton instance', () {
      final s1 = WindPlatformService();
      final s2 = WindPlatformService();

      expect(identical(s1, s2), isTrue);
    });

    test('platform is one of the known platform identifiers', () {
      const knownPlatforms = [
        'ios',
        'android',
        'web',
        'linux',
        'macos',
        'windows',
        'unknown',
      ];

      expect(knownPlatforms, contains(WindPlatformService().platform));
    });

    test('isMobile is consistent with the platform value', () {
      final service = WindPlatformService();
      final expectedMobile =
          service.platform == 'ios' || service.platform == 'android';

      expect(service.isMobile, equals(expectedMobile));
    });
  });
}
