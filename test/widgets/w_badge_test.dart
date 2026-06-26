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
  setUp(() {
    WindParser.clearCache();
  });

  group('WBadge Widget Tests', () {
    group('Construction', () {
      test('creates with required label', () {
        const widget = WBadge('Active');
        expect(widget.label, 'Active');
      });

      test('accepts null className', () {
        const widget = WBadge('Draft');
        expect(widget.className, isNull);
      });

      test('stores className', () {
        const widget = WBadge(
          'Success',
          className: 'bg-green-100 text-green-800',
        );
        expect(widget.className, 'bg-green-100 text-green-800');
      });
    });

    group('Rendering', () {
      testWidgets('renders the label text', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WBadge('Beta')),
        );
        await tester.pump();

        expect(find.text('Beta'), findsOneWidget);
      });

      testWidgets('renders a WDiv and a WText', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WBadge('New')),
        );
        await tester.pump();

        expect(find.byType(WDiv), findsOneWidget);
        expect(find.byType(WText), findsOneWidget);
      });

      testWidgets('WDiv.className contains the default layout classes', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrapWithTheme(const WBadge('Info')),
        );
        await tester.pump();

        final div = tester.widget<WDiv>(find.byType(WDiv));
        expect(div.className, contains('inline-flex'));
        expect(div.className, contains('rounded-full'));
        expect(div.className, contains('px-'));
        expect(div.className, contains('py-'));
      });

      testWidgets('WDiv.className contains caller-supplied className', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WBadge(
              'Error',
              className: 'bg-red-100 text-red-800',
            ),
          ),
        );
        await tester.pump();

        final div = tester.widget<WDiv>(find.byType(WDiv));
        expect(div.className, contains('bg-red-100'));
        expect(div.className, contains('text-red-800'));
      });

      testWidgets('WText carries text-xs class', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WBadge('Small')),
        );
        await tester.pump();

        final text = tester.widget<WText>(find.byType(WText));
        expect(text.className, contains('text-xs'));
      });

      testWidgets('renders without className when not provided', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrapWithTheme(const WBadge('Plain')),
        );
        await tester.pump();

        expect(find.byType(WBadge), findsOneWidget);
        expect(find.text('Plain'), findsOneWidget);
      });
    });

    group('className pass-through', () {
      testWidgets(
        'dark: variant class is threaded into WDiv.className',
        (tester) async {
          await tester.pumpWidget(
            wrapWithTheme(
              const WBadge(
                'Dark',
                className:
                    'bg-gray-100 dark:bg-gray-700 text-gray-800 dark:text-gray-100',
              ),
            ),
          );
          await tester.pump();

          final div = tester.widget<WDiv>(find.byType(WDiv));
          expect(div.className, contains('dark:bg-gray-700'));
          expect(div.className, contains('dark:text-gray-100'));
        },
      );

      testWidgets(
        'multiple caller classes all appear in WDiv.className',
        (tester) async {
          const extraClass = 'bg-blue-500 text-white font-semibold';
          await tester.pumpWidget(
            wrapWithTheme(const WBadge('Multi', className: extraClass)),
          );
          await tester.pump();

          final div = tester.widget<WDiv>(find.byType(WDiv));
          expect(div.className, contains('bg-blue-500'));
          expect(div.className, contains('text-white'));
          expect(div.className, contains('font-semibold'));
        },
      );
    });
  });
}
