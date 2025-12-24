import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  group('Sizing Parsing Tests', () {
    testWidgets('Parsing width/height numeric values correctly (using theme)', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(), // base: 4.0
            child: const WDiv(className: 'w-10 h-20', children: [Text('Test')]),
          ),
        ),
      );

      // w-10 -> 10 * 4 = 40.0
      // h-20 -> 20 * 4 = 80.0

      final containerFinder = find.byType(Container);
      expect(containerFinder, findsOneWidget);
      final Container container = tester.widget(containerFinder);
      expect(container.constraints!.minWidth, 40.0);
      expect(container.constraints!.maxWidth, 40.0);
      expect(container.constraints!.minHeight, 80.0);
      expect(container.constraints!.maxHeight, 80.0);
    });

    testWidgets('Parsing fractions', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'w-1/2 h-full',
              children: [Text('Test')],
            ),
          ),
        ),
      );

      expect(find.byType(FractionallySizedBox), findsOneWidget);
      final FractionallySizedBox box = tester.widget(
        find.byType(FractionallySizedBox),
      );
      expect(box.widthFactor, 0.5);
      expect(box.heightFactor, 1.0);
    });
  });
}
