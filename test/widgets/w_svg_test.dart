import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

Widget wrapWithTheme(Widget child) {
  return MaterialApp(
    home: WindTheme(
      data: WindThemeData(),
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  const testSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
  <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
</svg>
''';

  group('SvgParser via WindParser Tests', () {
    testWidgets('parses fill-red-500', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: Builder(
              builder: (context) {
                final style = WindParser.parse('fill-red-500', context);
                expect(
                  style.fillColor,
                  isNotNull,
                  reason: 'fillColor should be parsed from fill-red-500',
                );
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('parses stroke-blue-500', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: Builder(
              builder: (context) {
                final style = WindParser.parse('stroke-blue-500', context);
                expect(
                  style.strokeColor,
                  isNotNull,
                  reason: 'strokeColor should be parsed from stroke-blue-500',
                );
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('parses fill-none', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: Builder(
              builder: (context) {
                final style = WindParser.parse('fill-none', context);
                expect(
                  (style.fillColor!.a * 255).round(),
                  equals(0),
                  reason: 'fill-none should be transparent',
                );
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });
  });

  group('WSvg Widget Tests', () {
    testWidgets('renders SVG from string', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const WSvg.string(testSvg, className: 'fill-yellow-500 w-8 h-8'),
        ),
      );
      await tester.pump();

      expect(find.byType(WSvg), findsOneWidget);
    });

    testWidgets('renders with fill color', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const WSvg.string(testSvg, className: 'fill-red-500 w-8 h-8'),
        ),
      );
      await tester.pump();

      expect(find.byType(WSvg), findsOneWidget);
    });

    testWidgets('renders with stroke color', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const WSvg.string(testSvg, className: 'stroke-blue-500 w-8 h-8'),
        ),
      );
      await tester.pump();

      expect(find.byType(WSvg), findsOneWidget);
    });

    testWidgets('renders from asset src and produces SvgPicture',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const WSvg(src: 'assets/icons/test.svg', className: 'w-8 h-8'),
        ),
      );
      await tester.pump();

      // The asset branch (SvgPicture.asset) must produce exactly one SvgPicture.
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('wraps with Opacity widget when opacity class is applied',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const WSvg.string(testSvg, className: 'opacity-50 w-8 h-8'),
        ),
      );
      await tester.pump();

      // The opacity branch produces an Opacity wrapper around SvgPicture.
      expect(find.byType(Opacity), findsWidgets);
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets(
        'wraps with AnimatedOpacity when opacity + duration classes are applied',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const WSvg.string(testSvg,
              className: 'opacity-75 duration-300 w-8 h-8'),
        ),
      );
      await tester.pump();

      // The animated opacity branch produces AnimatedOpacity, not plain Opacity.
      expect(find.byType(AnimatedOpacity), findsOneWidget);
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('applies colorFilter to SvgPicture when fill className is set',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const WSvg.string(testSvg, className: 'fill-blue-500 w-8 h-8'),
        ),
      );
      await tester.pump();

      // The SvgPicture must carry a non-null colorFilter derived from fill-blue-500.
      final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));
      expect(svgPicture.colorFilter, isNotNull);
    });
  });
}
