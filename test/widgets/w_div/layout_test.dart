import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  group('Layout & Flexbox Parsing Tests', () {
    testWidgets('renders hidden correctly (class="hidden")', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'hidden',
              children: [Text('I am hidden')],
            ),
          ),
        ),
      );

      expect(find.text('I am hidden'), findsNothing);
    });

    testWidgets('renders visible again with flex (class="hidden flex")', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'hidden flex',
              children: [Text('I am visible')],
            ),
          ),
        ),
      );

      expect(find.text('I am visible'), findsOneWidget);
      // Should find a Row because default flex direction is row
      expect(find.byType(Row), findsOneWidget);
    });

    testWidgets('renders hidden with flex hidden (class="flex hidden")', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'flex hidden',
              children: [Text('I am hidden')],
            ),
          ),
        ),
      );

      expect(find.text('I am hidden'), findsNothing);
    });

    testWidgets('renders block (class="block")', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'block',
              children: [Text('Block'), Text('Block2')],
            ),
          ),
        ),
      );

      expect(find.text('Block'), findsOneWidget);
      expect(
        find.byType(Column),
        findsOneWidget,
      ); // WDiv defaults to Column for block
    });

    testWidgets('renders grid with gap (class="grid gap-4")', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'grid gap-4',
              children: [Text('GridItem')],
            ),
          ),
        ),
      );

      expect(find.text('GridItem'), findsOneWidget);
      // Grid now uses Wrap for flexible item heights (Tailwind-like behavior)
      final wrapFinder = find.byType(Wrap);
      expect(wrapFinder, findsOneWidget);

      final Wrap wrap = tester.widget(wrapFinder);
      expect(wrap.spacing, 16.0); // gap-4 = 4 * 4 = 16
      expect(wrap.runSpacing, 16.0);
    });

    testWidgets('renders place-content (class="place-content-center")', (
      tester,
    ) async {
      // Just verifying regex matching mainly, as Flutter support might vary
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'grid place-content-center',
              children: [Text('Center')],
            ),
          ),
        ),
      );

      // place-content isn't fully mapped to Flutter props in the current parser code (just added regex)
      // but it shouldn't crash.
      expect(find.text('Center'), findsOneWidget);
    });
    testWidgets('respects responsive prefixes (md:flex)', (tester) async {
      // Small screen (mobile)
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'hidden md:flex',
              children: [Text('Responsive Item')],
            ),
          ),
        ),
      );

      // Should be hidden on small screen
      expect(find.text('Responsive Item'), findsNothing);

      // Large screen (desktop/tablet)
      tester.view.physicalSize = const Size(1000, 800);
      await tester.pumpAndSettle();

      // Should be visible on large screen
      expect(find.text('Responsive Item'), findsOneWidget);
      expect(find.byType(Row), findsOneWidget); // Default flex is row

      // Reset
      addTearDown(tester.view.resetPhysicalSize);
    });
  });
}
