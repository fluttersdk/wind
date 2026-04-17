import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/parser/parsers/order_parser.dart';
import 'package:fluttersdk_wind/src/parser/wind_context.dart';
import 'package:fluttersdk_wind/src/parser/wind_style.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme_data.dart';

WindContext createTestContext() {
  return WindContext(
    theme: WindThemeData(),
    activeBreakpoint: 'base',
    platform: 'unknown',
    isMobile: false,
    screenWidth: 400,
    screenHeight: 800,
    activeStates: const {},
  );
}

void main() {
  group('OrderParser', () {
    late OrderParser parser;
    late WindContext context;

    setUp(() {
      parser = const OrderParser();
      context = createTestContext();
    });

    group('canParse', () {
      test('recognizes order-* classes', () {
        expect(parser.canParse('order-0'), isTrue);
        expect(parser.canParse('order-3'), isTrue);
        expect(parser.canParse('order-12'), isTrue);
        expect(parser.canParse('order-first'), isTrue);
        expect(parser.canParse('order-last'), isTrue);
        expect(parser.canParse('order-none'), isTrue);
        expect(parser.canParse('order-[5]'), isTrue);
        expect(parser.canParse('order-[-3]'), isTrue);
      });

      test('rejects unrelated classes', () {
        expect(parser.canParse('flex'), isFalse);
        expect(parser.canParse('p-4'), isFalse);
        expect(parser.canParse('orderly'), isFalse);
      });
    });

    group('parse', () {
      test('parses numeric order', () {
        final styles = parser.parse(WindStyle(), ['order-3'], context);
        expect(styles.order, 3);
      });

      test('parses order-0', () {
        final styles = parser.parse(WindStyle(), ['order-0'], context);
        expect(styles.order, 0);
      });

      test('parses order-first as sentinel', () {
        final styles = parser.parse(WindStyle(), ['order-first'], context);
        expect(styles.order, -9999);
      });

      test('parses order-last as sentinel', () {
        final styles = parser.parse(WindStyle(), ['order-last'], context);
        expect(styles.order, 9999);
      });

      test('parses order-none as 0', () {
        final styles = parser.parse(WindStyle(), ['order-none'], context);
        expect(styles.order, 0);
      });

      test('parses arbitrary positive order', () {
        final styles = parser.parse(WindStyle(), ['order-[42]'], context);
        expect(styles.order, 42);
      });

      test('parses arbitrary negative order', () {
        final styles = parser.parse(WindStyle(), ['order-[-5]'], context);
        expect(styles.order, -5);
      });

      test('last class wins', () {
        final styles = parser.parse(
            WindStyle(), ['order-1', 'order-5', 'order-3'], context);
        expect(styles.order, 3);
      });

      test('ignores invalid tokens', () {
        final styles = parser.parse(WindStyle(), ['order-foo'], context);
        expect(styles.order, isNull);
      });

      test('rejects out-of-range numeric order (13)', () {
        final styles = parser.parse(WindStyle(), ['order-13'], context);
        expect(styles.order, isNull);
      });

      test('rejects out-of-range numeric order (99)', () {
        final styles = parser.parse(WindStyle(), ['order-99'], context);
        expect(styles.order, isNull);
      });

      test('accepts arbitrary values beyond the 0-12 scale', () {
        final styles = parser.parse(WindStyle(), ['order-[99]'], context);
        expect(styles.order, 99);
      });

      test('returns unchanged styles for null classes', () {
        final initial = WindStyle();
        final styles = parser.parse(initial, null, context);
        expect(styles.order, isNull);
      });

      test('returns unchanged styles for empty classes', () {
        final styles = parser.parse(WindStyle(), const [], context);
        expect(styles.order, isNull);
      });
    });
  });
}
