import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  group('WDiv AspectRatio Feature Tests', () {
    testWidgets('aspect-square wraps with AspectRatio widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'aspect-square w-32 bg-blue-500',
              children: [Text('Content')],
            ),
          ),
        ),
      );

      expect(find.byType(AspectRatio), findsOneWidget);
      final aspectRatio = tester.widget<AspectRatio>(find.byType(AspectRatio));
      expect(aspectRatio.aspectRatio, 1.0);
    });

    testWidgets('aspect-video applies 16:9 ratio', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'aspect-video w-64 bg-red-500',
              children: [Text('Content')],
            ),
          ),
        ),
      );

      expect(find.byType(AspectRatio), findsOneWidget);
      final aspectRatio = tester.widget<AspectRatio>(find.byType(AspectRatio));
      expect(aspectRatio.aspectRatio, 16 / 9);
    });

    testWidgets('aspect-[4/3] applies custom ratio', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'aspect-[4/3] w-48 bg-green-500',
              children: [Text('Content')],
            ),
          ),
        ),
      );

      expect(find.byType(AspectRatio), findsOneWidget);
      final aspectRatio = tester.widget<AspectRatio>(find.byType(AspectRatio));
      expect(aspectRatio.aspectRatio, 4 / 3);
    });

    testWidgets('aspect-auto does not add AspectRatio widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'aspect-auto w-32 h-24 bg-purple-500',
              children: [Text('Content')],
            ),
          ),
        ),
      );

      expect(find.byType(AspectRatio), findsNothing);
    });

    testWidgets('no aspect class does not add AspectRatio widget', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'w-32 h-32 bg-gray-500',
              children: [Text('Content')],
            ),
          ),
        ),
      );

      expect(find.byType(AspectRatio), findsNothing);
    });
  });
}
