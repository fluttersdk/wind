import 'package:flutter/material.dart';
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
  group('WIcon Widget Tests', () {
    group('Basic Rendering', () {
      testWidgets('renders icon without className', (tester) async {
        await tester.pumpWidget(wrapWithTheme(const WIcon(Icons.star)));

        expect(find.byIcon(Icons.star), findsOneWidget);
      });

      testWidgets('renders icon with className', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WIcon(Icons.favorite, className: 'text-red-500')),
        );

        expect(find.byIcon(Icons.favorite), findsOneWidget);
      });
    });

    group('Color Styling', () {
      testWidgets('applies text color class', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WIcon(Icons.star, className: 'text-yellow-500')),
        );

        final icon = tester.widget<Icon>(find.byType(Icon));
        expect(icon.color, isNotNull);
      });

      testWidgets('applies arbitrary hex color', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WIcon(Icons.star, className: 'text-[#ff5500]')),
        );

        final icon = tester.widget<Icon>(find.byType(Icon));
        expect(icon.color, isNotNull);
      });
    });

    group('Size Styling', () {
      testWidgets('applies width class for size', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WIcon(Icons.home, className: 'w-8 h-8')),
        );

        final icon = tester.widget<Icon>(find.byType(Icon));
        expect(icon.size, 32.0); // w-8 = 8 * 4 = 32
      });

      testWidgets('applies height class for size', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WIcon(Icons.home, className: 'h-6')),
        );

        final icon = tester.widget<Icon>(find.byType(Icon));
        expect(icon.size, 24.0); // h-6 = 6 * 4 = 24
      });
    });

    group('Opacity', () {
      testWidgets('applies opacity class', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WIcon(Icons.circle, className: 'opacity-50')),
        );

        expect(find.byType(Opacity), findsOneWidget);
        final opacity = tester.widget<Opacity>(find.byType(Opacity));
        expect(opacity.opacity, 0.5);
      });
    });

    group('States', () {
      testWidgets('accepts states parameter', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WIcon(
              Icons.favorite,
              className: 'text-gray-400 hover:text-red-500',
              states: {'hover'},
            ),
          ),
        );

        // Should apply hover state color
        final icon = tester.widget<Icon>(find.byType(Icon));
        expect(icon.color, isNotNull);
      });
    });

    group('Accessibility', () {
      testWidgets('passes through semanticLabel', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WIcon(Icons.star, semanticLabel: 'Star rating')),
        );

        final icon = tester.widget<Icon>(find.byType(Icon));
        expect(icon.semanticLabel, 'Star rating');
      });
    });

    group('Text Size Classes', () {
      testWidgets('applies text-lg for size', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WIcon(Icons.star, className: 'text-gray-500 text-lg'),
          ),
        );

        final icon = tester.widget<Icon>(find.byType(Icon));
        // text-lg is 18px
        expect(icon.size, 18.0);
      });

      testWidgets('applies text-2xl for size', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WIcon(Icons.star, className: 'text-gray-500 text-2xl'),
          ),
        );

        final icon = tester.widget<Icon>(find.byType(Icon));
        // text-2xl is 24px
        expect(icon.size, 24.0);
      });
    });

    group('Parent Inheritance', () {
      testWidgets('inherits color from DefaultTextStyle', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            DefaultTextStyle(
              style: const TextStyle(color: Color(0xFFFF0000)),
              child: const WIcon(Icons.star),
            ),
          ),
        );

        final icon = tester.widget<Icon>(find.byType(Icon));
        expect(icon.color, const Color(0xFFFF0000));
      });

      testWidgets('inherits size from DefaultTextStyle', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            DefaultTextStyle(
              style: const TextStyle(fontSize: 32.0),
              child: const WIcon(Icons.star),
            ),
          ),
        );

        final icon = tester.widget<Icon>(find.byType(Icon));
        expect(icon.size, 32.0);
      });

      testWidgets('className overrides inherited values', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            DefaultTextStyle(
              style: const TextStyle(color: Color(0xFFFF0000), fontSize: 32.0),
              child: const WIcon(
                Icons.star,
                className: 'text-blue-500 text-sm',
              ),
            ),
          ),
        );

        final icon = tester.widget<Icon>(find.byType(Icon));
        // Should use className values, not inherited
        expect(icon.size, 14.0); // text-sm = 14px
        expect(icon.color, isNot(const Color(0xFFFF0000)));
      });
    });
  });
}
