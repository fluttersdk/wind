import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  group('Shadow Integration Tests', () {
    testWidgets('renders shadow-sm on WDiv', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'shadow-sm p-4 bg-white',
              children: [Text('Shadow Test')],
            ),
          ),
        ),
      );

      final containerFinder = find.byType(Container);
      // WDiv might create multiple containers (one for decoration).
      // We look for the one with boxShadow.
      final containerWithShadow = containerFinder.evaluate().firstWhere((
        element,
      ) {
        final widget = element.widget as Container;
        final decoration = widget.decoration;
        if (decoration is BoxDecoration) {
          return decoration.boxShadow != null;
        }
        return false;
      }, orElse: () => throw Exception('Container with shadow not found'));

      final container = containerWithShadow.widget as Container;
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.length, 1);
      expect(decoration.boxShadow![0].blurRadius, 2);
    });

    testWidgets('renders shadow-lg with color on WDiv', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'shadow-lg shadow-blue-500',
              children: [Text('Shadow Test')],
            ),
          ),
        ),
      );

      final containerFinder = find.byType(Container);
      final containerWithShadow = containerFinder.evaluate().firstWhere((
        element,
      ) {
        final widget = element.widget as Container;
        final decoration = widget.decoration;
        if (decoration is BoxDecoration) {
          return decoration.boxShadow != null;
        }
        return false;
      }, orElse: () => throw Exception('Container with shadow not found'));

      final container = containerWithShadow.widget as Container;
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.length, 2); // shadow-lg has 2 layers

      // Check color tinting (opacity is applied to base color)
      // Blue 500 is typically Primary/Material Color.
      // Exact check might depend on theme defaults, but assuming standard blue.
      // We check if it's NOT the default shadow color.
      final shadowColor = decoration.boxShadow![0].color;
      expect(shadowColor.r, isNot(0)); // Default is black (0,0,0)
    });

    testWidgets('renders arbitrary colored shadow on WDiv', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'shadow-md shadow-[#00ff00]',
              children: [Text('Shadow Test')],
            ),
          ),
        ),
      );

      final containerFinder = find.byType(Container);
      final containerWithShadow = containerFinder.evaluate().firstWhere((
        element,
      ) {
        final widget = element.widget as Container;
        final decoration = widget.decoration;
        if (decoration is BoxDecoration) {
          return decoration.boxShadow != null;
        }
        return false;
      }, orElse: () => throw Exception('Container with shadow not found'));

      final container = containerWithShadow.widget as Container;
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.boxShadow, isNotNull);
      // Green #00ff00
      final shadowColor = decoration.boxShadow![0].color;
      expect(shadowColor.g, 1.0); // 255 becomes 1.0
      expect(shadowColor.r, 0);
      expect(shadowColor.b, 0);
    });
  });
}
