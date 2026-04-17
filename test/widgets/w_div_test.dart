import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme_data.dart';
import 'package:fluttersdk_wind/src/parser/wind_parser.dart';
import 'package:fluttersdk_wind/src/widgets/w_div.dart';
import 'package:fluttersdk_wind/src/theme/defaults/colors.dart'
    as default_colors;

void main() {
  group('WDiv Composition Tests', () {
    testWidgets('renders Padding widget when p-4 is used', (tester) async {
      // Arrange
      const testKey = Key('test-wdiv');
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: WDiv(
              key: testKey,
              className: 'p-4',
              child: const Text('Test'),
            ),
          ),
        ),
      );

      // Assert
      final wDivFinder = find.byKey(testKey);
      expect(wDivFinder, findsOneWidget);

      // Additional check to ensure Padding is applied
      final paddingFinder = find.descendant(
        of: wDivFinder,
        matching: find.byWidgetPredicate((widget) {
          if (widget is Padding) {
            return widget.padding == const EdgeInsets.all(16.0);
          }
          return false;
        }),
      );

      expect(paddingFinder, findsOneWidget);
    });

    testWidgets('renders Row when flex class is present', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'flex',
              children: [Text('A'), Text('B')],
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Column), findsNothing);
    });

    testWidgets('renders Expanded when flex-1 is used on child', (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const Column(
              children: [
                WDiv(className: 'flex-1', child: Text('Expanded Item')),
              ],
            ),
          ),
        ),
      );

      // Assert
      final expandedFinder = find.byType(Expanded);
      expect(expandedFinder, findsOneWidget);

      final Expanded expanded = tester.widget(expandedFinder);
      expect(expanded.flex, 1);
    });
  });

  testWidgets('renders Margin using Padding widget when m-4 is used', (
    tester,
  ) async {
    const testKey = Key('test-wdiv-margin');
    await tester.pumpWidget(
      MaterialApp(
        home: WindTheme(
          data: WindThemeData(),
          child: WDiv(
            key: testKey,
            className: 'm-4', // Margin adds outer padding
            child: const Text('Margin Test'),
          ),
        ),
      ),
    );

    // Assert
    final wDivFinder = find.byKey(testKey);

    // WDiv internally uses Padding for margin.
    // Since we only have 'm-4' and no 'p-', we expect exactly one Padding.
    final paddingFinder = find.descendant(
      of: wDivFinder,
      matching: find.byWidgetPredicate((widget) {
        if (widget is Padding) {
          return widget.padding == const EdgeInsets.all(16.0);
        }
        return false;
      }),
    );

    expect(paddingFinder, findsOneWidget);
  });

  testWidgets('renders Container with decoration when bg-red-500 is used', (
    tester,
  ) async {
    const testKey = Key('test-wdiv-bg');
    await tester.pumpWidget(
      MaterialApp(
        home: WindTheme(
          data: WindThemeData(),
          child: WDiv(
            key: testKey,
            className: 'bg-red-500',
            child: const Text('Background Test'),
          ),
        ),
      ),
    );

    // Assert
    // Look for a Container that has a BoxDecoration with red color
    final containerFinder = find.descendant(
      of: find.byKey(testKey),
      matching: find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration is BoxDecoration) {
          final decoration = widget.decoration as BoxDecoration;
          return decoration.color == default_colors.colors['red']![500];
        }
        return false;
      }),
    );

    expect(containerFinder, findsOneWidget);
  });

  testWidgets('renders Wrap-based grid when grid class is present', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: WindTheme(
          data: WindThemeData(),
          child: WDiv(
            className: 'grid grid-cols-3',
            children: List.generate(6, (i) => Text('Item $i')),
          ),
        ),
      ),
    );

    // Grid now uses Wrap for flexible item heights (Tailwind-like behavior)
    expect(find.byType(Wrap), findsOneWidget);
    // Ensure it's not a Row or Column
    expect(find.byType(Row), findsNothing);
    expect(find.byType(Column), findsNothing);
  });

  testWidgets('hides content when hidden class is present', (tester) async {
    const testKey = Key('test-wdiv-hidden');
    await tester.pumpWidget(
      MaterialApp(
        home: WindTheme(
          data: WindThemeData(),
          child: Column(
            children: [
              const Text('Visible Before'),
              WDiv(
                key: testKey,
                className: 'hidden', // Should return SizedBox.shrink()
                child: const Text('You cannot see me'),
              ),
              const Text('Visible After'),
            ],
          ),
        ),
      ),
    );

    // Assert
    // The text inside WDiv should NOT be found in the tree
    expect(find.text('You cannot see me'), findsNothing);
    expect(find.text('Visible Before'), findsOneWidget);

    // Verify SizedBox.shrink() usage (it has size 0)
    final wDivFinder = find.byKey(testKey);
    final size = tester.getSize(wDivFinder);
    expect(size, Size.zero);
  });

  testWidgets('injects SizedBox gaps when gap-4 is used in flex', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: WindTheme(
          data: WindThemeData(),
          child: const WDiv(
            className: 'flex gap-4', // gap-4 = 16px
            children: [Text('A'), Text('B')],
          ),
        ),
      ),
    );

    // Assert
    // In a Row with 2 children and a gap, we expect 3 items total in the row's children list.
    // [Text('A'), SizedBox(width: 16), Text('B')]
    final rowFinder = find.byType(Row);
    final Row rowWidget = tester.widget(rowFinder);

    expect(rowWidget.children.length, 3);

    // The middle element should be a SizedBox with width 16
    final gapWidget = rowWidget.children[1];
    expect(gapWidget, isA<SizedBox>());
    expect((gapWidget as SizedBox).width, 16.0);
  });

  testWidgets('w-full works inside scroll view (overflow-y-auto)', (
    tester,
  ) async {
    // This tests that w-full works inside a vertical scroll view
    // Note: h-full cannot work in unbounded scroll - use fixed height instead
    await tester.pumpWidget(
      MaterialApp(
        home: WindTheme(
          data: WindThemeData(),
          child: const SizedBox(
            width: 400,
            height: 600,
            child: WDiv(
              className: 'w-full h-full overflow-y-auto',
              child: WDiv(
                className: 'w-full h-64 flex items-center justify-center',
                child: Text('Centered'),
              ),
            ),
          ),
        ),
      ),
    );

    // Should not throw any errors and render successfully
    expect(find.text('Centered'), findsOneWidget);

    // Verify we have SingleChildScrollView (from overflow-y-auto)
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });

  group('WDiv inline backgroundColor', () {
    setUp(() {
      WindParser.clearCache();
    });

    testWidgets(
        'paints Container color when backgroundColor is provided '
        'without any bg-* className', (tester) async {
      const color = Color(0xFF123456);
      const testKey = Key('bg-only');
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              key: testKey,
              className: 'w-10 h-10',
              backgroundColor: color,
            ),
          ),
        ),
      );

      final containerFinder = find.descendant(
        of: find.byKey(testKey),
        matching: find.byWidgetPredicate((widget) {
          if (widget is! Container) return false;
          final decoration = widget.decoration;
          return decoration is BoxDecoration && decoration.color == color;
        }),
      );
      expect(containerFinder, findsOneWidget);
    });

    testWidgets('inline backgroundColor wins over bg-* className',
        (tester) async {
      const override = Color(0xFFABCDEF);
      const testKey = Key('bg-override');
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              key: testKey,
              className: 'w-10 h-10 bg-red-500',
              backgroundColor: override,
            ),
          ),
        ),
      );

      final containerFinder = find.descendant(
        of: find.byKey(testKey),
        matching: find.byWidgetPredicate((widget) {
          if (widget is! Container) return false;
          final decoration = widget.decoration;
          return decoration is BoxDecoration && decoration.color == override;
        }),
      );
      expect(containerFinder, findsOneWidget);
    });

    testWidgets(
        'inline backgroundColor clears className gradient so solid color '
        'is not painted over', (tester) async {
      const override = Color(0xFF00AA00);
      const testKey = Key('bg-vs-gradient');
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              key: testKey,
              className: 'w-10 h-10 bg-gradient-to-r from-red-500 to-blue-500',
              backgroundColor: override,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byKey(testKey),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, override);
      expect(decoration.gradient, isNull);
      expect(decoration.image, isNull);
    });

    testWidgets(
        'parser cache entry is shared across WDivs with different '
        'backgroundColor but identical className', (tester) async {
      WindParser.clearCache();
      const sameClass = 'w-8 h-8 rounded-md';

      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const Column(
              children: [
                WDiv(className: sameClass, backgroundColor: Color(0xFF111111)),
                WDiv(className: sameClass, backgroundColor: Color(0xFF222222)),
              ],
            ),
          ),
        ),
      );

      // Two WDivs parsed the same className; only one cache entry should exist.
      expect(WindParser.cacheSize, 1);
    });
  });
}
