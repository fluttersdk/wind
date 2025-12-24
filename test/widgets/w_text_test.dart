import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme_data.dart';
import 'package:fluttersdk_wind/src/widgets/w_text.dart';

void main() {
  group('WText Widget Tests', () {
    testWidgets('renders Text widget with correct data', (tester) async {
      const testText = 'Hello Wind';
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(data: WindThemeData(), child: const WText(testText)),
        ),
      );

      expect(find.text(testText), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('applies text color (text-red-500)', (tester) async {
      final themeData = WindThemeData();
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: themeData,
            child: const WText('Color Test', className: 'text-red-500'),
          ),
        ),
      );

      final textFinder = find.byType(Text);
      final Text textWidget = tester.widget(textFinder);

      expect(textWidget.style?.color, isNotNull);
      expect(textWidget.style?.color, themeData.colors['red']![500]);
    });

    testWidgets('applies font size (text-xl)', (tester) async {
      final themeData = WindThemeData();
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: themeData,
            child: const WText('Size Test', className: 'text-xl'),
          ),
        ),
      );

      final textFinder = find.byType(Text);
      final Text textWidget = tester.widget(textFinder);

      expect(textWidget.style?.fontSize, themeData.fontSizes['xl']);
    });

    testWidgets('applies font weight (font-bold)', (tester) async {
      final themeData = WindThemeData();
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: themeData,
            child: const WText('Weight Test', className: 'font-bold'),
          ),
        ),
      );

      final textFinder = find.byType(Text);
      final Text textWidget = tester.widget(textFinder);

      expect(textWidget.style?.fontWeight, themeData.fontWeights['bold']);
    });

    testWidgets('applies text decoration (underline)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WText('Decoration Test', className: 'underline'),
          ),
        ),
      );

      final textFinder = find.byType(Text);
      final Text textWidget = tester.widget(textFinder);

      expect(textWidget.style?.decoration, TextDecoration.underline);
    });

    testWidgets('applies text transform (uppercase)', (tester) async {
      const originalText = 'hello world';
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WText(originalText, className: 'uppercase'),
          ),
        ),
      );

      expect(find.text('HELLO WORLD'), findsOneWidget);
      expect(find.text(originalText), findsNothing);
    });

    testWidgets('applies text transform (capitalize)', (tester) async {
      const originalText = 'hello world';
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WText(originalText, className: 'capitalize'),
          ),
        ),
      );

      expect(find.text('Hello world'), findsOneWidget);
    });

    testWidgets(
      'renders SelectableText when selectable prop or class is used',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: Column(
                children: const [
                  WText('Selectable 1', selectable: true),
                  WText('Selectable 2', className: 'selectable'),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(SelectableText), findsNWidgets(2));
        expect(find.byType(Text), findsNothing);
      },
    );

    testWidgets('applies text alignment (text-center)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WText('Align Test', className: 'text-center'),
          ),
        ),
      );

      final textFinder = find.byType(Text);
      final Text textWidget = tester.widget(textFinder);

      expect(textWidget.textAlign, TextAlign.center);
    });

    testWidgets('applies line clamp (line-clamp-2)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WText('Long text...', className: 'line-clamp-2'),
          ),
        ),
      );

      final textFinder = find.byType(Text);
      final Text textWidget = tester.widget(textFinder);

      expect(textWidget.maxLines, 2);
      expect(textWidget.overflow, TextOverflow.ellipsis);
    });

    testWidgets('applies background color (bg-blue-500) via Container', (
      tester,
    ) async {
      final themeData = WindThemeData();
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: themeData,
            child: const WText('Bg Test', className: 'bg-blue-500'),
          ),
        ),
      );

      final containerFinder = find.ancestor(
        of: find.text('Bg Test'),
        matching: find.byType(Container),
      );

      expect(containerFinder, findsOneWidget);
      final Container container = tester.widget(containerFinder);
      final BoxDecoration decoration = container.decoration as BoxDecoration;

      expect(decoration.color, isNotNull);
      expect(decoration.color, themeData.colors['blue']![500]);
    });
  });
}
