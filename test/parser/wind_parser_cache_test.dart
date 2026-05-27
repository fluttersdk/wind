import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/parser/wind_context.dart';
import 'package:fluttersdk_wind/src/parser/wind_parser.dart';
import 'package:fluttersdk_wind/src/parser/wind_style.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme_data.dart';

final testTheme = WindThemeData();

WindContext createTestContext({
  bool isHovering = false,
  bool isFocused = false,
  bool isDisabled = false,
  String activeBreakpoint = 'base',
  Brightness brightness = Brightness.light,
  String platform = 'unknown',
  bool isMobile = false,
}) =>
    WindContext(
      theme: testTheme.copyWith(brightness: brightness),
      activeBreakpoint: activeBreakpoint,
      platform: platform,
      isMobile: isMobile,
      screenWidth: 400,
      screenHeight: 800,
      activeStates: {
        if (isHovering) 'hover',
        if (isFocused) 'focus',
        if (isDisabled) 'disabled',
      },
    );

void main() {
  setUp(WindParser.clearCache);
  tearDown(WindParser.clearCache);

  group('WindParser regression', () {
    test(
      'findAndGroupClasses preserves duplicate tokens so last-class-wins still works on repeated overrides',
      () {
        // top-8 top-4 top-8: the trailing top-8 must override the intermediate
        // top-4. Set-based dedup loses the trailing occurrence and picks top-4.
        final result = WindParser.findAndGroupClasses(
            'top-8 top-4 top-8', createTestContext());

        expect(result['position'], ['top-8', 'top-4', 'top-8']);
      },
    );

    test(
      'findAndGroupClasses still routes duplicates the same way as unique tokens',
      () {
        final result = WindParser.findAndGroupClasses(
          'bg-red-500 text-lg md:bg-blue-500',
          createTestContext(),
        );

        expect(result, {
          'background': ['bg-red-500'],
          'text': ['text-lg'],
        });
      },
    );

    testWidgets(
      'parse with non-null baseStyle bypasses the cache (no stale hit, no write-back pollution)',
      (tester) async {
        late BuildContext capturedContext;
        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: Builder(
                builder: (context) {
                  capturedContext = context;
                  return const SizedBox();
                },
              ),
            ),
          ),
        );

        // 1. Default-flag call populates the cache.
        final firstStyle = WindParser.parse('p-4', capturedContext);
        expect(WindParser.cacheSize, 1);
        expect(firstStyle.padding, isNotNull);

        // 2. baseStyle-call must NOT read from the cache (it would discard the
        //    baseStyle) and must NOT write into the cache (it would poison
        //    later default-flag hits).
        const baseStyle = WindStyle(opacity: 0.5);
        final scopedStyle = WindParser.parse(
          'p-4',
          capturedContext,
          baseStyle: baseStyle,
        );
        expect(scopedStyle.opacity, 0.5);
        expect(scopedStyle.padding, isNotNull);
        expect(WindParser.cacheSize, 1);

        // 3. The original cache slot is untouched: a later default-flag call
        //    returns the same instance as the first one.
        final repeatStyle = WindParser.parse('p-4', capturedContext);
        expect(identical(firstStyle, repeatStyle), isTrue);
      },
    );
  });
}
