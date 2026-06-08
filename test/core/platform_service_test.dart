import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/core/platform_service.dart';

/// Tests for [WindPlatformService].
///
/// The singleton is shared across tests; the `platform` and `isMobile` fields
/// are immutable after construction, so no reset is needed for those.
/// `resolvePlatform()` reads `defaultTargetPlatform` at call-time, so each
/// test overrides `debugDefaultTargetPlatformOverride` and resets in tearDown.
void main() {
  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
  });

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

  group('WindPlatformService.resolvePlatform', () {
    test('returns ios + isMobile=true for TargetPlatform.iOS', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      expect(WindPlatformService.resolvePlatform(), ('ios', true));
    });

    test('returns android + isMobile=true for TargetPlatform.android', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      expect(WindPlatformService.resolvePlatform(), ('android', true));
    });

    test('returns linux + isMobile=false for TargetPlatform.linux', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;

      expect(WindPlatformService.resolvePlatform(), ('linux', false));
    });

    test('returns macos + isMobile=false for TargetPlatform.macOS', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;

      expect(WindPlatformService.resolvePlatform(), ('macos', false));
    });

    test('returns windows + isMobile=false for TargetPlatform.windows', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;

      expect(WindPlatformService.resolvePlatform(), ('windows', false));
    });

    test('returns unknown + isMobile=false for TargetPlatform.fuchsia', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

      expect(WindPlatformService.resolvePlatform(), ('unknown', false));
    });
  });
}
