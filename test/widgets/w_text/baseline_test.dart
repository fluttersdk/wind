import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/parser/wind_parser.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme_data.dart';
import 'package:fluttersdk_wind/src/widgets/w_text.dart';

void main() {
  setUp(WindParser.clearCache);

  group('WText baseline rendering', () {
    group('bare context (no Material / Scaffold ancestor)', () {
      testWidgets(
        'renders non-null text color when no className text-* is given',
        (tester) async {
          // Pump WText under only a WindTheme + Directionality — no
          // MaterialApp, no Scaffold, no DefaultTextStyle with a real color.
          await tester.pumpWidget(
            Directionality(
              textDirection: TextDirection.ltr,
              child: WindTheme(
                data: WindThemeData(),
                child: const WText('x'),
              ),
            ),
          );

          final Text textWidget = tester.widget(find.byType(Text));

          // The effective style must carry a non-null color so Flutter does
          // not fall back to its yellow-underline debug appearance.
          final BuildContext ctx = tester.element(find.byType(Text));
          final TextStyle effective = DefaultTextStyle.of(ctx).style.merge(
                textWidget.style,
              );
          expect(
            effective.color,
            isNotNull,
            reason: 'A bare WText must resolve a baseline color.',
          );
        },
      );

      testWidgets(
        'renders without crashing when Directionality ancestor is absent',
        (tester) async {
          // No Directionality ancestor at all. WText must provide one.
          await tester.pumpWidget(
            WindTheme(
              data: WindThemeData(),
              child: const WText('x'),
            ),
          );

          expect(find.byType(Text), findsOneWidget);
          // Must not throw a "No Directionality widget found" error.
        },
      );

      testWidgets(
        'resolves TextDirection from the injected Directionality',
        (tester) async {
          await tester.pumpWidget(
            WindTheme(
              data: WindThemeData(),
              child: const WText('x'),
            ),
          );

          // The Text widget itself lives inside a Directionality subtree,
          // so resolving TextDirection must succeed (no exception).
          final BuildContext ctx = tester.element(find.byType(Text));
          final TextDirection? dir = Directionality.maybeOf(ctx);
          expect(
            dir,
            isNotNull,
            reason: 'WText must guarantee a TextDirection for its subtree.',
          );
        },
      );

      testWidgets(
        'baseline color follows platform brightness (white on dark)',
        (tester) async {
          await tester.pumpWidget(
            MediaQuery(
              data: const MediaQueryData(platformBrightness: Brightness.dark),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: WindTheme(
                  data: WindThemeData(),
                  child: const WText('x'),
                ),
              ),
            ),
          );

          final Text textWidget = tester.widget(find.byType(Text));
          expect(
            textWidget.style?.color,
            Colors.white,
            reason: 'Bare WText on a dark platform falls back to white, '
                'not an invisible black.',
          );
        },
      );
    });

    group('explicit styles still win over baseline', () {
      testWidgets(
        'className text-* color overrides baseline fallback',
        (tester) async {
          final themeData = WindThemeData();
          await tester.pumpWidget(
            Directionality(
              textDirection: TextDirection.ltr,
              child: WindTheme(
                data: themeData,
                child: const WText('x', className: 'text-red-500'),
              ),
            ),
          );

          final Text textWidget = tester.widget(find.byType(Text));
          expect(
            textWidget.style?.color,
            themeData.colors['red']![500],
            reason: 'className text-* must still control the text color.',
          );
        },
      );

      testWidgets(
        'foregroundColor prop overrides baseline fallback',
        (tester) async {
          const explicitColor = Color(0xFF123456);
          await tester.pumpWidget(
            Directionality(
              textDirection: TextDirection.ltr,
              child: WindTheme(
                data: WindThemeData(),
                child: const WText('x', foregroundColor: explicitColor),
              ),
            ),
          );

          final Text textWidget = tester.widget(find.byType(Text));
          expect(
            textWidget.style?.color,
            explicitColor,
            reason: 'foregroundColor prop must still control the text color.',
          );
        },
      );

      testWidgets(
        'textStyle prop color overrides baseline fallback',
        (tester) async {
          const explicitColor = Color(0xFFABCDEF);
          await tester.pumpWidget(
            Directionality(
              textDirection: TextDirection.ltr,
              child: WindTheme(
                data: WindThemeData(),
                child: const WText(
                  'x',
                  textStyle: TextStyle(color: explicitColor),
                ),
              ),
            ),
          );

          final Text textWidget = tester.widget(find.byType(Text));
          expect(
            textWidget.style?.color,
            explicitColor,
            reason: 'textStyle prop color must still control the text color.',
          );
        },
      );
    });

    group('inherits an ancestor color (CSS cascade)', () {
      testWidgets(
        'colorless WText inherits an ancestor DefaultTextStyle color over the '
        'platform baseline',
        (tester) async {
          // A parent WDiv with a `text-*` class publishes its color through a
          // DefaultTextStyle.merge; a colorless WText must inherit it exactly
          // like CSS text-color cascades. The platform here is dark, which the
          // old baseline would have forced to white, hiding the text whenever
          // the app theme disagreed with the OS theme.
          const ancestorColor = Color(0xFF00AA55);
          await tester.pumpWidget(
            MediaQuery(
              data: const MediaQueryData(platformBrightness: Brightness.dark),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: WindTheme(
                  data: WindThemeData(),
                  child: const DefaultTextStyle(
                    style: TextStyle(color: ancestorColor),
                    child: WText('x'),
                  ),
                ),
              ),
            ),
          );

          final Text textWidget = tester.widget(find.byType(Text));
          final BuildContext ctx = tester.element(find.byType(Text));
          final TextStyle effective = DefaultTextStyle.of(ctx).style.merge(
                textWidget.style,
              );
          expect(
            effective.color,
            ancestorColor,
            reason: 'A colorless WText must inherit the ancestor color, not '
                'the platform-brightness baseline.',
          );
        },
      );
    });
  });
}
