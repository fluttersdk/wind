import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  // Helper to set mock system brightness
  void setMockBrightness(WidgetTester tester, Brightness brightness) {
    tester.binding.platformDispatcher.platformBrightnessTestValue = brightness;
    tester.binding.handlePlatformBrightnessChanged();
  }

  group('WindTheme Sync', () {
    testWidgets(
        'syncWithSystem=true (default) picks up platform brightness on init',
        (tester) async {
      // Set system to dark before pumping
      tester.binding.platformDispatcher.platformBrightnessTestValue =
          Brightness.dark;

      await tester.pumpWidget(
        WindTheme(
          data: WindThemeData(
              syncWithSystem:
                  true), // Default is true, but explicit for clarity
          builder: (context, controller) {
            return MaterialApp(
              theme: controller.toThemeData(),
              home: Scaffold(body: Container()),
            );
          },
        ),
      );

      final context = tester.element(find.byType(Scaffold));
      final theme = WindTheme.of(context);

      expect(theme.brightness, equals(Brightness.dark));
    });

    testWidgets('syncWithSystem=true updates when platform brightness changes',
        (tester) async {
      // Start with light
      tester.binding.platformDispatcher.platformBrightnessTestValue =
          Brightness.light;

      await tester.pumpWidget(
        WindTheme(
          data: WindThemeData(syncWithSystem: true),
          builder: (context, controller) {
            return MaterialApp(
              theme: controller.toThemeData(),
              home: Scaffold(body: Container()),
            );
          },
        ),
      );

      // Verify initial light
      var context = tester.element(find.byType(Scaffold));
      expect(WindTheme.of(context).brightness, equals(Brightness.light));

      // Change system to dark
      setMockBrightness(tester, Brightness.dark);
      await tester.pump();

      // Verify update to dark
      context = tester.element(find.byType(Scaffold));
      expect(WindTheme.of(context).brightness, equals(Brightness.dark));
    });

    testWidgets('syncWithSystem=false ignores platform changes',
        (tester) async {
      // Start with light
      tester.binding.platformDispatcher.platformBrightnessTestValue =
          Brightness.light;

      await tester.pumpWidget(
        WindTheme(
          data: WindThemeData(
            syncWithSystem: false,
            brightness: Brightness.light,
          ),
          builder: (context, controller) {
            return MaterialApp(
              theme: controller.toThemeData(),
              home: Scaffold(body: Container()),
            );
          },
        ),
      );

      // Verify initial light
      var context = tester.element(find.byType(Scaffold));
      expect(WindTheme.of(context).brightness, equals(Brightness.light));

      // Change system to dark
      setMockBrightness(tester, Brightness.dark);
      await tester.pump();

      // Verify STILL light
      context = tester.element(find.byType(Scaffold));
      expect(WindTheme.of(context).brightness, equals(Brightness.light));
    });

    testWidgets(
      'toggleTheme disables syncWithSystem so system changes are ignored',
      (tester) async {
        tester.binding.platformDispatcher.platformBrightnessTestValue =
            Brightness.light;

        await tester.pumpWidget(
          WindTheme(
            data: WindThemeData(syncWithSystem: true),
            builder: (context, controller) {
              return MaterialApp(
                theme: controller.toThemeData(),
                home: Scaffold(body: Container()),
              );
            },
          ),
        );

        var context = tester.element(find.byType(Scaffold));
        expect(WindTheme.of(context).brightness, equals(Brightness.light));

        // Manual toggle — should disable syncWithSystem
        WindTheme.of(context).toggleTheme();
        await tester.pump();

        expect(WindTheme.of(context).brightness, equals(Brightness.dark));

        // System brightness changes should be IGNORED after manual toggle
        setMockBrightness(tester, Brightness.light);
        await tester.pump();

        expect(
          WindTheme.of(context).brightness,
          equals(Brightness.dark),
          reason:
              'After manual toggle, system brightness changes should be ignored',
        );
      },
    );

    testWidgets(
        'Observer cleanup: no errors after dispose when brightness changes',
        (tester) async {
      tester.binding.platformDispatcher.platformBrightnessTestValue =
          Brightness.light;

      await tester.pumpWidget(
        WindTheme(
          data: WindThemeData(syncWithSystem: true),
          builder: (context, controller) => Container(),
        ),
      );

      // Replace widget to trigger dispose
      await tester.pumpWidget(Container());

      // Trigger brightness change
      setMockBrightness(tester, Brightness.dark);
      await tester.pump();

      // If we are here without exception, pass.
    });

    testWidgets('Consumer rebuild: Widgets rebuild on theme change',
        (tester) async {
      int buildCount = 0;

      await tester.pumpWidget(
        WindTheme(
          data: WindThemeData(syncWithSystem: true),
          builder: (context, controller) {
            buildCount++;
            return Container(key: ValueKey(controller.brightness));
          },
        ),
      );

      expect(buildCount, 1);

      // Change system brightness
      setMockBrightness(tester, Brightness.dark);
      await tester.pump();

      expect(buildCount, 2);
    });
  });

  group('WindTheme Manual Override', () {
    // Helper to set mock system brightness.
    void setMockBrightness(WidgetTester tester, Brightness brightness) {
      tester.binding.platformDispatcher.platformBrightnessTestValue =
          brightness;
      tester.binding.handlePlatformBrightnessChanged();
    }

    testWidgets(
      'toggleTheme sets syncWithSystem to false on the controller data',
      (tester) async {
        tester.binding.platformDispatcher.platformBrightnessTestValue =
            Brightness.light;

        await tester.pumpWidget(
          WindTheme(
            data: WindThemeData(syncWithSystem: true),
            builder: (context, controller) {
              return MaterialApp(
                theme: controller.toThemeData(),
                home: Scaffold(body: Container()),
              );
            },
          ),
        );

        final context = tester.element(find.byType(Scaffold));
        final controller = WindTheme.of(context);

        expect(controller.data.syncWithSystem, isTrue);

        controller.toggleTheme();
        await tester.pump();

        expect(
          controller.data.syncWithSystem,
          isFalse,
          reason:
              'toggleTheme should disable syncWithSystem so user preference sticks',
        );
      },
    );

    testWidgets(
      'resetToSystem re-enables syncWithSystem and syncs with platform',
      (tester) async {
        tester.binding.platformDispatcher.platformBrightnessTestValue =
            Brightness.light;

        await tester.pumpWidget(
          WindTheme(
            data: WindThemeData(syncWithSystem: true),
            builder: (context, controller) {
              return MaterialApp(
                theme: controller.toThemeData(),
                home: Scaffold(body: Container()),
              );
            },
          ),
        );

        final context = tester.element(find.byType(Scaffold));
        final controller = WindTheme.of(context);

        // 1. Manual toggle to dark.
        controller.toggleTheme();
        await tester.pump();
        expect(controller.brightness, equals(Brightness.dark));
        expect(controller.data.syncWithSystem, isFalse);

        // 2. System is still light — change to dark.
        setMockBrightness(tester, Brightness.dark);
        await tester.pump();

        // 3. Reset to system — should re-enable sync and pick up system.
        controller.resetToSystem();
        await tester.pump();
        expect(controller.data.syncWithSystem, isTrue);
        expect(controller.brightness, equals(Brightness.dark));

        // 4. System changes should now be followed again.
        setMockBrightness(tester, Brightness.light);
        await tester.pump();
        expect(controller.brightness, equals(Brightness.light));
      },
    );

    testWidgets(
      'onThemeChanged callback fires when theme toggles',
      (tester) async {
        Brightness? reportedBrightness;

        await tester.pumpWidget(
          WindTheme(
            data: WindThemeData(brightness: Brightness.light),
            onThemeChanged: (brightness) {
              reportedBrightness = brightness;
            },
            builder: (context, controller) {
              return MaterialApp(
                theme: controller.toThemeData(),
                home: Scaffold(body: Container()),
              );
            },
          ),
        );

        final context = tester.element(find.byType(Scaffold));
        WindTheme.of(context).toggleTheme();
        await tester.pump();

        expect(
          reportedBrightness,
          equals(Brightness.dark),
          reason: 'onThemeChanged should fire with the new brightness',
        );
      },
    );

    testWidgets(
      'onThemeChanged does NOT fire on system-initiated changes',
      (tester) async {
        int callCount = 0;

        tester.binding.platformDispatcher.platformBrightnessTestValue =
            Brightness.light;

        await tester.pumpWidget(
          WindTheme(
            data: WindThemeData(syncWithSystem: true),
            onThemeChanged: (brightness) {
              callCount++;
            },
            builder: (context, controller) {
              return MaterialApp(
                theme: controller.toThemeData(),
                home: Scaffold(body: Container()),
              );
            },
          ),
        );

        // System change should NOT trigger onThemeChanged
        setMockBrightness(tester, Brightness.dark);
        await tester.pump();

        expect(
          callCount,
          equals(0),
          reason:
              'onThemeChanged should only fire on user-initiated theme changes',
        );
      },
    );
  });
}
