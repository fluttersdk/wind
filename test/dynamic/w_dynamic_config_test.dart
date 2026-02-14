import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/dynamic/wind_dynamic_config.dart';

void main() {
  group('WindDynamicConfig', () {
    test('default config allows all Wind widgets', () {
      const config = WindDynamicConfig();

      for (final type in WindDynamicConfig.defaultWindWidgets) {
        expect(config.isAllowed(type), isTrue, reason: '$type should be allowed');
      }
    });

    test('default config allows Flutter core widgets', () {
      const config = WindDynamicConfig();

      for (final type in WindDynamicConfig.defaultFlutterWidgets) {
        expect(config.isAllowed(type), isTrue, reason: '$type should be allowed');
      }
    });

    test('unknown widget type is not allowed', () {
      const config = WindDynamicConfig();
      expect(config.isAllowed('CustomUnknown'), isFalse);
    });

    test('denyWidgets blocks specific widgets', () {
      const config = WindDynamicConfig(
        denyWidgets: {'WInput', 'WSelect'},
      );

      expect(config.isAllowed('WInput'), isFalse);
      expect(config.isAllowed('WSelect'), isFalse);
      expect(config.isAllowed('WDiv'), isTrue);
      expect(config.isAllowed('WText'), isTrue);
    });

    test('custom builders are always allowed', () {
      final config = WindDynamicConfig(
        builders: {
          'ProductCard': (props, children) => const SizedBox(),
        },
      );

      expect(config.isAllowed('ProductCard'), isTrue);
    });

    test('custom builders bypass deny list', () {
      final config = WindDynamicConfig(
        denyWidgets: {'ProductCard'},
        builders: {
          'ProductCard': (props, children) => const SizedBox(),
        },
      );

      expect(config.isAllowed('ProductCard'), isTrue);
    });

    test('maxDepth defaults to 50', () {
      const config = WindDynamicConfig();
      expect(config.maxDepth, 50);
    });
  });
}
