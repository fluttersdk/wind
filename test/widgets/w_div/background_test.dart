import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  group('Background Parsing Tests', () {
    testWidgets('Parsing background color with opacity', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'bg-red-500/50',
              children: [Text('Test')],
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color!.a, closeTo(0.5, 0.01));
    });

    testWidgets('Parsing arbitrary background opacity', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'bg-red-500/[0.2]',
              children: [Text('Test')],
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color!.a, closeTo(0.2, 0.01));
    });

    testWidgets('Parsing linear gradient (to right)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'bg-gradient-to-r from-red-500 to-blue-500',
              children: [Text('Test')],
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.gradient, isA<LinearGradient>());
      final gradient = decoration.gradient as LinearGradient;
      expect(gradient.begin, Alignment.centerLeft);
      expect(gradient.end, Alignment.centerRight);
      expect(gradient.colors.length, 2);
    });

    testWidgets('Parsing linear gradient with via', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className:
                  'bg-gradient-to-b from-red-500 via-green-500 to-blue-500',
              children: [Text('Test')],
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      final gradient = decoration.gradient as LinearGradient;
      expect(gradient.colors.length, 3);
    });
  });
}
