import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/parser/wind_parser.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme_data.dart';
import 'package:fluttersdk_wind/src/widgets/w_text.dart';

void main() {
  // These tests pump className-styled widgets, and the parser cache outlives a
  // test: a sibling priming it is what turns a regression into a pass.
  setUp(WindParser.clearCache);

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

    group('capitalize', () {
      Future<void> pumpCapitalized(WidgetTester tester, String text) {
        return tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: WText(text, className: 'capitalize'),
            ),
          ),
        );
      }

      testWidgets('uppercases the first letter of every word', (tester) async {
        await pumpCapitalized(tester, 'hello world');

        expect(find.text('Hello World'), findsOneWidget);
      });

      testWidgets('leaves the rest of each word as typed', (tester) async {
        // CSS `text-transform: capitalize` raises the word initial and touches
        // nothing else, so an acronym the caller typed survives.
        await pumpCapitalized(tester, 'the HTTP client');

        expect(find.text('The HTTP Client'), findsOneWidget);
      });

      testWidgets('skips a word\'s leading punctuation', (tester) async {
        await pumpCapitalized(tester, '"quoted words" (and parens)');

        expect(find.text('"Quoted Words" (And Parens)'), findsOneWidget);
      });

      testWidgets('preserves the original whitespace', (tester) async {
        await pumpCapitalized(tester, 'two  spaces\nand a newline');

        expect(find.text('Two  Spaces\nAnd A Newline'), findsOneWidget);
      });

      testWidgets('leaves a word that opens with a digit alone', (
        tester,
      ) async {
        // Measured in Chromium: a digit or an underscore belongs to the word
        // rather than separating it, so the letter behind it is not a word
        // initial and stays lowercase.
        await pumpCapitalized(tester, '4th of july and _underscore lead');

        expect(
          find.text('4th Of July And _underscore Lead'),
          findsOneWidget,
        );
      });

      testWidgets('opens a new word on a hyphen, a slash or a dot', (
        tester,
      ) async {
        await pumpCapitalized(tester, 'well-known read/write u.s.a. builds');

        expect(
          find.text('Well-Known Read/Write U.S.A. Builds'),
          findsOneWidget,
        );
      });

      testWidgets('does not split a decomposed letter mid-word', (
        tester,
      ) async {
        // NFD, written as an escape so the source encoding cannot silently
        // precompose it and pass the test for the wrong reason. macOS hands
        // text back this way, and a combining mark continues the word in a
        // browser, so the `v` behind it is not a word initial.
        await pumpCapitalized(tester, 'nai\u0308ve approach');

        expect(find.text('Nai\u0308ve Approach'), findsOneWidget);
      });

      testWidgets('does not split on an invisible format character', (
        tester,
      ) async {
        // A soft hyphen is a line-break hint rather than a word boundary, so a
        // browser renders this as `Cooperate Now`.
        await pumpCapitalized(tester, 'co\u00ADoperate now');

        expect(find.text('Co\u00ADoperate Now'), findsOneWidget);
      });

      testWidgets('keeps a letter after an apostrophe as typed', (
        tester,
      ) async {
        // The apostrophe continues the word in Chromium, which is what keeps
        // `L'orange` from rendering as `L'Orange`.
        await pumpCapitalized(tester, "l'orange soup, o'brien street");

        expect(find.text("L'orange Soup, O'brien Street"), findsOneWidget);
      });
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

    // New tests for extended coverage
    testWidgets('applies arbitrary font size (text-[32px])', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WText('Arbitrary Size', className: 'text-[32px]'),
          ),
        ),
      );

      final textFinder = find.byType(Text);
      final Text textWidget = tester.widget(textFinder);

      expect(textWidget.style?.fontSize, 32.0);
    });

    testWidgets('applies font weight arbitrary (font-[700])', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WText('Arbitrary Weight', className: 'font-[700]'),
          ),
        ),
      );

      final textFinder = find.byType(Text);
      final Text textWidget = tester.widget(textFinder);

      expect(textWidget.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('applies font size and line height slash syntax (text-xl/8)', (
      tester,
    ) async {
      final themeData = WindThemeData();
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: themeData,
            child: const WText('Slash Syntax', className: 'text-xl/8'),
          ),
        ),
      );

      final textFinder = find.byType(Text);
      final Text textWidget = tester.widget(textFinder);

      // text-xl is usually 1.25rem (20px)
      // /8 = 8 * 4 = 32px line-height
      // Flutter's TextStyle.height is a multiplier: 32 / 20 = 1.6
      expect(textWidget.style?.fontSize, themeData.fontSizes['xl']);
      expect(textWidget.style?.height, closeTo(1.6, 0.01));
    });
  });
}
