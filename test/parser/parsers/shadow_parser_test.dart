import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  group('Shadow Parsing Tests', () {
    testWidgets('renders shadow-sm', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'shadow-sm',
              children: [Text('Shadow')],
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.length, 1);
      expect(decoration.boxShadow![0].blurRadius, 2);
    });

    testWidgets('renders shadow (default)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(className: 'shadow', children: [Text('Shadow')]),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.length, 2); // Default has 2 shadows
    });

    testWidgets('renders shadow-xl', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'shadow-xl',
              children: [Text('Shadow')],
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.length, 2);
      expect(decoration.boxShadow![0].blurRadius, 25);
    });

    testWidgets('renders colored shadow (shadow-red-500)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'shadow-lg shadow-red-500',
              children: [Text('Shadow')],
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.boxShadow, isNotNull);
      // shadow-lg has 2 shadows. Both should be tinted red.
      expect(
        decoration.boxShadow![0].color,
        const Color(0xffef4444).withValues(alpha: 0.1),
      );
    });

    testWidgets('renders arbitrary colored shadow (shadow-[#1da1f2])', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'shadow-lg shadow-[#1da1f2]',
              children: [Text('Shadow')],
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.boxShadow, isNotNull);
      expect(
        decoration.boxShadow![0].color,
        const Color(0xff1da1f2).withValues(alpha: 0.1),
      );
    });
  });
}
