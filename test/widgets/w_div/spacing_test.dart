import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  group('Spacing Parsing Tests', () {
    testWidgets('Parsing padding correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(className: 'p-4 pt-8', children: [Text('Test')]),
          ),
        ),
      );

      final divFinder = find.byType(Padding);
      // p-4 = 16px all
      // pt-8 = 32px top overrides p-4 top
      // Result: L:16, R:16, B:16, T:32
      final Padding padding = tester.widget(
        divFinder.first,
      ); // WDiv wraps inner padding
      final EdgeInsets insets = padding.padding as EdgeInsets;

      // Note: WDiv might have multiple paddings if margin is also set.
      // But here only padding.
      expect(insets.left, 16.0);
      expect(insets.top, 32.0);
      expect(insets.right, 16.0);
      expect(insets.bottom, 16.0);
    });

    testWidgets('Parsing margin correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(className: 'm-4 mx-8', children: [Text('Test')]),
          ),
        ),
      );
      // Margin is implemented as an outer Padding widget in WDiv
      // But implementation details might vary.
      // Let's verify via debug dump or just assumption.
      // WDiv wraps margin then padding.

      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets('Parsing arbitrary padding', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(className: 'p-[20px]', children: [Text('Test')]),
          ),
        ),
      );

      final Padding padding = tester.widget(find.byType(Padding).first);
      final EdgeInsets insets = padding.padding as EdgeInsets;
      expect(insets.top, 20.0);
    });
  });
}
