import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme_data.dart';

void main() {
  group('WindTheme', () {
    testWidgets('of returns WindThemeController', (WidgetTester tester) async {
      final themeData = WindThemeData();
      BuildContext? capturedContext;

      await tester.pumpWidget(
        WindTheme(
          data: themeData,
          child: Builder(
            builder: (BuildContext context) {
              capturedContext = context;
              return Container();
            },
          ),
        ),
      );

      final controller = WindTheme.of(capturedContext!);
      expect(controller, isA<WindThemeController>());
      expect(controller.data, themeData);
    });

    testWidgets('dataOf returns WindThemeData', (WidgetTester tester) async {
      final themeData = WindThemeData();
      BuildContext? capturedContext;

      await tester.pumpWidget(
        WindTheme(
          data: themeData,
          child: Builder(
            builder: (BuildContext context) {
              capturedContext = context;
              return Container();
            },
          ),
        ),
      );

      final data = WindTheme.dataOf(capturedContext!);
      expect(data, themeData);
    });

    testWidgets('toggleTheme switches brightness', (WidgetTester tester) async {
      await tester.pumpWidget(
        WindTheme(
          data: WindThemeData(brightness: Brightness.light),
          builder: (context, controller) {
            return Text(
              controller.brightness == Brightness.light ? 'light' : 'dark',
              textDirection: TextDirection.ltr,
            );
          },
        ),
      );

      expect(find.text('light'), findsOneWidget);

      // Get the controller and toggle
      final element = tester.element(find.byType(Text));
      final controller = WindTheme.of(element);
      controller.toggleTheme();

      await tester.pump();

      expect(find.text('dark'), findsOneWidget);
    });

    testWidgets('controller notifies listeners on theme change', (
      WidgetTester tester,
    ) async {
      int rebuildCount = 0;

      await tester.pumpWidget(
        WindTheme(
          data: WindThemeData(),
          builder: (context, controller) {
            rebuildCount++;
            return Container(key: ValueKey(rebuildCount));
          },
        ),
      );

      expect(rebuildCount, 1);

      // Get the controller and toggle
      final element = tester.element(find.byType(Container));
      WindTheme.of(element).toggleTheme();
      await tester.pump();

      expect(rebuildCount, 2);
    });

    testWidgets('uses default WindThemeData when data is null', (
      WidgetTester tester,
    ) async {
      BuildContext? capturedContext;

      await tester.pumpWidget(
        WindTheme(
          child: Builder(
            builder: (BuildContext context) {
              capturedContext = context;
              return Container();
            },
          ),
        ),
      );

      final data = WindTheme.dataOf(capturedContext!);
      expect(data, isNotNull);
      expect(data.brightness, Brightness.light);
    });
  });
}
