import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/parser/wind_context.dart';
import 'package:fluttersdk_wind/src/state/wind_anchor_state.dart';
import 'package:fluttersdk_wind/src/state/wind_anchor_state_provider.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme_data.dart';

void main() {
  group('WindContext', () {
    final screens = {'sm': 640, 'md': 768, 'lg': 1024, 'xl': 1280};
    final testTheme = WindThemeData(screens: screens);

    // Helper function to create a widget tree with all necessary providers for testing
    Widget buildTestWidget({
      required double screenWidth,
      WindThemeData? theme,
      WindAnchorState? pressableState,
      required Widget child,
    }) {
      return MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: Size(screenWidth, 800)),
          child: WindTheme(
            data: theme ?? testTheme,
            child: WindAnchorStateProvider(
              state: pressableState ?? WindAnchorState.none,
              child: child,
            ),
          ),
        ),
      );
    }

    group('build factory and breakpoint calculation', () {
      testWidgets('should set activeBreakpoint to "base" for small screens', (
        tester,
      ) async {
        WindContext? context;
        await tester.pumpWidget(
          buildTestWidget(
            screenWidth: 500,
            child: Builder(
              builder: (ctx) {
                context = WindContext.build(ctx);
                return Container();
              },
            ),
          ),
        );

        expect(context, isNotNull);
        expect(context!.activeBreakpoint, 'base');
      });

      testWidgets(
        'should set activeBreakpoint to "sm" for small-medium screens',
        (tester) async {
          WindContext? context;
          await tester.pumpWidget(
            buildTestWidget(
              screenWidth: 700,
              child: Builder(
                builder: (ctx) {
                  context = WindContext.build(ctx);
                  return Container();
                },
              ),
            ),
          );

          expect(context, isNotNull);
          expect(context!.activeBreakpoint, 'sm');
        },
      );

      testWidgets('should set activeBreakpoint to "md" for medium screens', (
        tester,
      ) async {
        WindContext? context;
        await tester.pumpWidget(
          buildTestWidget(
            screenWidth: 800,
            child: Builder(
              builder: (ctx) {
                context = WindContext.build(ctx);
                return Container();
              },
            ),
          ),
        );

        expect(context, isNotNull);
        expect(context!.activeBreakpoint, 'md');
      });

      testWidgets('should set activeBreakpoint to "lg" for large screens', (
        tester,
      ) async {
        WindContext? context;
        await tester.pumpWidget(
          buildTestWidget(
            screenWidth: 1100,
            child: Builder(
              builder: (ctx) {
                context = WindContext.build(ctx);
                return Container();
              },
            ),
          ),
        );

        expect(context, isNotNull);
        expect(context!.activeBreakpoint, 'lg');
      });

      testWidgets(
        'should set activeBreakpoint to "xl" for extra-large screens',
        (tester) async {
          WindContext? context;
          await tester.pumpWidget(
            buildTestWidget(
              screenWidth: 1300,
              child: Builder(
                builder: (ctx) {
                  context = WindContext.build(ctx);
                  return Container();
                },
              ),
            ),
          );

          expect(context, isNotNull);
          expect(context!.activeBreakpoint, 'xl');
        },
      );
    });

    group('State propagation', () {
      testWidgets('should correctly reflect hover state', (tester) async {
        WindContext? context;
        final pressableState = WindAnchorState(
          isHovering: true,
          isFocused: false,
          isDisabled: false,
        );

        await tester.pumpWidget(
          buildTestWidget(
            screenWidth: 800,
            pressableState: pressableState,
            child: Builder(
              builder: (ctx) {
                context = WindContext.build(ctx);
                return Container();
              },
            ),
          ),
        );

        expect(context, isNotNull);
        expect(context!.isHovering, isTrue);
        expect(context!.isFocused, isFalse);
        expect(context!.isDisabled, isFalse);
      });

      testWidgets('should correctly reflect focused state', (tester) async {
        WindContext? context;
        final pressableState = WindAnchorState(
          isHovering: false,
          isFocused: true,
          isDisabled: false,
        );

        await tester.pumpWidget(
          buildTestWidget(
            screenWidth: 800,
            pressableState: pressableState,
            child: Builder(
              builder: (ctx) {
                context = WindContext.build(ctx);
                return Container();
              },
            ),
          ),
        );

        expect(context, isNotNull);
        expect(context!.isHovering, isFalse);
        expect(context!.isFocused, isTrue);
        expect(context!.isDisabled, isFalse);
      });

      testWidgets('should use default state when WindStateProvider is absent', (
        tester,
      ) async {
        WindContext? context;
        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: testTheme,
              child: Builder(
                builder: (ctx) {
                  context = WindContext.build(ctx);
                  return Container();
                },
              ),
            ),
          ),
        );

        expect(context, isNotNull);
        expect(context!.isHovering, isFalse);
        expect(context!.isFocused, isFalse);
        expect(context!.isDisabled, isFalse);
      });
    });

    group('cacheKey generation', () {
      test('should generate a consistent cache key', () {
        final context1 = WindContext(
          theme: testTheme,
          activeBreakpoint: 'md',
          platform: 'macos',
          isMobile: false,
          screenWidth: 800,
          screenHeight: 600,
        );
        final context2 = WindContext(
          theme: testTheme,
          activeBreakpoint: 'md',
          platform: 'macos',
          isMobile: false,
          screenWidth: 800,
          screenHeight: 600,
        );

        expect(context1.cacheKey('p-4'), context2.cacheKey('p-4'));
      });

      test('should generate different keys for different class names', () {
        final context = WindContext(
          theme: testTheme,
          activeBreakpoint: 'md',
          platform: 'macos',
          isMobile: false,
          screenWidth: 800,
          screenHeight: 600,
        );

        expect(context.cacheKey('p-4'), isNot(context.cacheKey('p-8')));
      });

      test('should generate different keys for different breakpoints', () {
        final context1 = WindContext(
          theme: testTheme,
          activeBreakpoint: 'md',
          platform: 'macos',
          isMobile: false,
          screenWidth: 800,
          screenHeight: 600,
        );
        final context2 = context1.copyWith(activeBreakpoint: 'lg');

        expect(context1.cacheKey('p-4'), isNot(context2.cacheKey('p-4')));
      });

      test('should generate different keys for different states', () {
        final context1 = WindContext(
          theme: testTheme,
          activeBreakpoint: 'md',
          platform: 'macos',
          isMobile: false,
          screenWidth: 800,
          screenHeight: 600,
        );
        final context2 = context1.copyWith(customStates: {'hover'});

        expect(context1.cacheKey('p-4'), isNot(context2.cacheKey('p-4')));
      });

      test('should generate different keys for different brightness modes', () {
        final theme1 = WindThemeData(brightness: Brightness.light);
        final theme2 = WindThemeData(brightness: Brightness.dark);

        final context1 = WindContext(
          theme: theme1,
          activeBreakpoint: 'md',
          platform: 'macos',
          isMobile: false,
          screenWidth: 800,
          screenHeight: 600,
        );
        final context2 = context1.copyWith(theme: theme2);

        expect(context1.cacheKey('p-4'), isNot(context2.cacheKey('p-4')));
      });
    });
  });
}

extension on WindContext {
  WindContext copyWith({
    WindThemeData? theme,
    String? activeBreakpoint,
    String? platform,
    bool? isMobile,
    Set<String>? customStates,
  }) {
    return WindContext(
      theme: theme ?? this.theme,
      activeBreakpoint: activeBreakpoint ?? this.activeBreakpoint,
      platform: platform ?? this.platform,
      isMobile: isMobile ?? this.isMobile,
      screenWidth: screenWidth,
      screenHeight: screenHeight,
      activeStates: {
        if (isHovering) 'hover',
        if (isFocused) 'focus',
        if (isDisabled) 'disabled',
        ...?customStates,
      },
    );
  }
}
