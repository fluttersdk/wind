import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  group('Background Parsing Tests', () {
    setUp(WindParser.clearCache);

    testWidgets('a later bg-transparent clears an earlier fill', (
      tester,
    ) async {
      // The reported symptom, at the widget level: a ghost button whose base
      // class paints a brand fill and whose variant clears it rendered filled,
      // with the muted text meant for a transparent surface on top of it.
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'bg-primary bg-transparent border text-gray-500',
              children: [Text('Continue as Guest')],
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, const Color(0x00000000));
    });

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
