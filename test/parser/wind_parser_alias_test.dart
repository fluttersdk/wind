import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/parser/wind_parser.dart';
import 'package:fluttersdk_wind/src/parser/wind_style.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme_data.dart';
import 'package:fluttersdk_wind/src/widgets/w_div.dart';

/// Wraps [child] in a [WindTheme] carrying the supplied [aliases] so
/// `WindParser.parse` resolves them through the real `parse()` path.
Widget wrapWithAliases(Map<String, String> aliases, Widget child) {
  return MaterialApp(
    home: WindTheme(
      data: WindThemeData(
        screens: const {'sm': 640, 'md': 768, 'lg': 1024, 'xl': 1280},
        aliases: aliases,
      ),
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  setUp(() {
    WindParser.clearCache();
  });

  group('WindParser alias expansion', () {
    testWidgets('expands an alias before parsing so it yields a flex/row style',
        (tester) async {
      late WindStyle style;

      await tester.pumpWidget(
        wrapWithAliases(
          const {'row': 'flex flex-row'},
          Builder(
            builder: (context) {
              style = WindParser.parse('row', context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(style.displayType, WindDisplayType.flex);
      expect(style.flexDirection, Axis.horizontal);
    });

    testWidgets('expands recursively before parsing', (tester) async {
      late WindStyle style;

      await tester.pumpWidget(
        wrapWithAliases(
          const {
            'row': 'flex flex-row',
            'row-c': 'row items-center',
          },
          Builder(
            builder: (context) {
              style = WindParser.parse('row-c', context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(style.displayType, WindDisplayType.flex);
      expect(style.flexDirection, Axis.horizontal);
      expect(style.crossAxisAlignment, CrossAxisAlignment.center);
    });

    testWidgets(
        'two themes with different alias maps keep distinct cache entries',
        (tester) async {
      late WindStyle rowStyle;

      await tester.pumpWidget(
        wrapWithAliases(
          const {'box': 'flex flex-row'},
          Builder(
            builder: (context) {
              rowStyle = WindParser.parse('box', context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(rowStyle.flexDirection, Axis.horizontal);
      final sizeAfterRow = WindParser.cacheSize;

      late WindStyle colStyle;

      await tester.pumpWidget(
        wrapWithAliases(
          const {'box': 'flex flex-col'},
          Builder(
            builder: (context) {
              colStyle = WindParser.parse('box', context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      // Same raw className `box`, different alias values: the cache key is
      // computed from the expanded string, so the two produce distinct entries
      // and distinct results rather than a stale cache hit.
      expect(colStyle.flexDirection, Axis.vertical);
      expect(WindParser.cacheSize, greaterThan(sizeAfterRow));
    });

    testWidgets('a WDiv with className:row renders a horizontal Flex',
        (tester) async {
      // The central-injection smoke: a real widget, not just a parse() call,
      // proves the alias resolves through the rendering path.
      await tester.pumpWidget(
        wrapWithAliases(
          const {'row': 'flex flex-row'},
          const WDiv(
            className: 'row',
            children: [Text('a'), Text('b')],
          ),
        ),
      );

      // A horizontal flex renders as a concrete Row (find.byType matches the
      // exact runtime type, not the Flex superclass).
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Column), findsNothing);
    });
  });

  group('WindParser alias debug diagnostics', () {
    // These diagnostics are kDebugMode-gated; flutter test runs in debug mode,
    // so the branches execute. We capture debugPrint to assert they fire.
    testWidgets('warns once when an alias key shadows a built-in token',
        (tester) async {
      final logs = <String>[];
      final original = debugPrint;
      debugPrint = (message, {wrapWidth}) => logs.add(message ?? '');

      try {
        await tester.pumpWidget(
          wrapWithAliases(
            const {'flex': 'flex-row'},
            Builder(
              builder: (context) {
                WindParser.parse('flex', context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );
      } finally {
        debugPrint = original;
      }

      expect(
        logs.where((l) => l.contains("alias 'flex' shadows a built-in")).length,
        1,
      );
    });

    testWidgets('warns when a cyclic alias is expanded through parse',
        (tester) async {
      final logs = <String>[];
      final original = debugPrint;
      debugPrint = (message, {wrapWidth}) => logs.add(message ?? '');

      try {
        await tester.pumpWidget(
          wrapWithAliases(
            const {'a': 'a'},
            Builder(
              builder: (context) {
                WindParser.parse('a', context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );
      } finally {
        debugPrint = original;
      }

      expect(logs.any((l) => l.contains("alias 'a' forms a cycle")), isTrue);
    });
  });
}
