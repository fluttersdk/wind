import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/parser/wind_parser.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme_data.dart';
import 'package:fluttersdk_wind/src/widgets/w_text.dart';

void main() {
  group('WText inline foregroundColor', () {
    setUp(() {
      WindParser.clearCache();
    });

    testWidgets('applies foregroundColor to Text style when no text-* class',
        (tester) async {
      const color = Color(0xFF112233);
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WText(
              'hello',
              className: 'text-lg',
              foregroundColor: color,
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('hello'));
      expect(text.style?.color, color);
    });

    testWidgets('foregroundColor wins over text-* className', (tester) async {
      const override = Color(0xFFCC00CC);
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WText(
              'hello',
              className: 'text-red-500',
              foregroundColor: override,
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('hello'));
      expect(text.style?.color, override);
    });
  });

  group('WText visibility', () {
    setUp(() {
      WindParser.clearCache();
    });

    testWidgets('hidden className returns SizedBox.shrink', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WText('invisible text', className: 'hidden'),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.text('invisible text'), findsNothing);
    });
  });

  group('WText text transform', () {
    setUp(() {
      WindParser.clearCache();
    });

    testWidgets('lowercase className transforms text to lower case',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WText('HELLO WORLD', className: 'lowercase'),
          ),
        ),
      );

      expect(find.text('hello world'), findsOneWidget);
      expect(find.text('HELLO WORLD'), findsNothing);
    });

    testWidgets('normal-case className leaves text unchanged', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WText('Mixed Case Text', className: 'normal-case'),
          ),
        ),
      );

      expect(find.text('Mixed Case Text'), findsOneWidget);
    });
  });

  group('WText textStyle prop', () {
    setUp(() {
      WindParser.clearCache();
    });

    testWidgets('explicit textStyle merges with className styles', (
      tester,
    ) async {
      const explicitStyle = TextStyle(letterSpacing: 3.0);
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WText(
              'styled',
              className: 'text-lg',
              textStyle: explicitStyle,
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('styled'));
      expect(text.style?.letterSpacing, 3.0);
      expect(text.style?.fontSize, isNotNull);
    });
  });

  group('WText composition pipeline', () {
    setUp(() {
      WindParser.clearCache();
    });

    testWidgets('margin className wraps text in a Padding widget', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WText('margin test', className: 'm-4'),
          ),
        ),
      );

      final paddingFinder = find.ancestor(
        of: find.text('margin test'),
        matching: find.byType(Padding),
      );
      expect(paddingFinder, findsWidgets);
    });
  });
}
