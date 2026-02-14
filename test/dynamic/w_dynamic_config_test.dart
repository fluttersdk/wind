import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/dynamic/w_dynamic_config.dart';

void main() {
  group('WDynamicConfig', () {
    test('default config allows all Wind widgets', () {
      const config = WDynamicConfig();

      for (final type in WDynamicConfig.defaultWindWidgets) {
        expect(config.isAllowed(type), isTrue,
            reason: '$type should be allowed');
      }
    });

    test('default config allows Flutter core widgets', () {
      const config = WDynamicConfig();

      for (final type in WDynamicConfig.defaultFlutterWidgets) {
        expect(config.isAllowed(type), isTrue,
            reason: '$type should be allowed');
      }
    });

    test('unknown widget type is not allowed', () {
      const config = WDynamicConfig();
      expect(config.isAllowed('CustomUnknown'), isFalse);
    });

    test('denyWidgets blocks specific widgets', () {
      const config = WDynamicConfig(
        denyWidgets: {'WInput', 'WSelect'},
      );

      expect(config.isAllowed('WInput'), isFalse);
      expect(config.isAllowed('WSelect'), isFalse);
      expect(config.isAllowed('WDiv'), isTrue);
      expect(config.isAllowed('WText'), isTrue);
    });

    test('custom builders are always allowed', () {
      final config = WDynamicConfig(
        builders: {
          'ProductCard': (props, children) => const SizedBox(),
        },
      );

      expect(config.isAllowed('ProductCard'), isTrue);
    });

    test('custom builders bypass deny list', () {
      final config = WDynamicConfig(
        denyWidgets: {'ProductCard'},
        builders: {
          'ProductCard': (props, children) => const SizedBox(),
        },
      );

      expect(config.isAllowed('ProductCard'), isTrue);
    });

    test('maxDepth defaults to 50', () {
      const config = WDynamicConfig();
      expect(config.maxDepth, 50);
    });
  });
}
