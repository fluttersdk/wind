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

    testWidgets('Toggle works manually even with syncWithSystem=true',
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

      // Manual toggle
      WindTheme.of(context).toggleTheme();
      await tester.pump();

      expect(WindTheme.of(context).brightness, equals(Brightness.dark));

      // System change overwrites manual toggle if it happens later
      setMockBrightness(tester, Brightness.light);
      await tester.pump();

      expect(WindTheme.of(context).brightness, equals(Brightness.light));
    });

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
}
