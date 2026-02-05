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
  group('WSpacer Widget Tests', () {
    group('Basic Rendering', () {
      testWidgets('renders without className', (tester) async {
        await tester.pumpWidget(wrapWithTheme(const WSpacer()));

        expect(find.byType(WSpacer), findsOneWidget);
        expect(find.byType(SizedBox), findsOneWidget);
      });

      testWidgets('renders with className', (tester) async {
        await tester.pumpWidget(wrapWithTheme(const WSpacer(className: 'h-4')));

        expect(find.byType(WSpacer), findsOneWidget);
      });
    });

    group('Height Spacing (Vertical)', () {
      testWidgets('applies h-1 (4px)', (tester) async {
        await tester.pumpWidget(wrapWithTheme(const WSpacer(className: 'h-1')));

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        expect(sizedBox.height, 4.0);
      });

      testWidgets('applies h-2 (8px)', (tester) async {
        await tester.pumpWidget(wrapWithTheme(const WSpacer(className: 'h-2')));

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        expect(sizedBox.height, 8.0);
      });

      testWidgets('applies h-4 (16px)', (tester) async {
        await tester.pumpWidget(wrapWithTheme(const WSpacer(className: 'h-4')));

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        expect(sizedBox.height, 16.0);
      });

      testWidgets('applies h-6 (24px)', (tester) async {
        await tester.pumpWidget(wrapWithTheme(const WSpacer(className: 'h-6')));

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        expect(sizedBox.height, 24.0);
      });

      testWidgets('applies h-8 (32px)', (tester) async {
        await tester.pumpWidget(wrapWithTheme(const WSpacer(className: 'h-8')));

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        expect(sizedBox.height, 32.0);
      });

      testWidgets('applies arbitrary height h-[20px]', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WSpacer(className: 'h-[20px]')),
        );

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        expect(sizedBox.height, 20.0);
      });
    });

    group('Width Spacing (Horizontal)', () {
      testWidgets('applies w-1 (4px)', (tester) async {
        await tester.pumpWidget(wrapWithTheme(const WSpacer(className: 'w-1')));

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        expect(sizedBox.width, 4.0);
      });

      testWidgets('applies w-2 (8px)', (tester) async {
        await tester.pumpWidget(wrapWithTheme(const WSpacer(className: 'w-2')));

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        expect(sizedBox.width, 8.0);
      });

      testWidgets('applies w-4 (16px)', (tester) async {
        await tester.pumpWidget(wrapWithTheme(const WSpacer(className: 'w-4')));

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        expect(sizedBox.width, 16.0);
      });

      testWidgets('applies arbitrary width w-[12px]', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WSpacer(className: 'w-[12px]')),
        );

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        expect(sizedBox.width, 12.0);
      });
    });

    group('Combined Width and Height', () {
      testWidgets('applies both w-4 and h-6', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WSpacer(className: 'w-4 h-6')),
        );

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        expect(sizedBox.width, 16.0);
        expect(sizedBox.height, 24.0);
      });

      testWidgets('applies arbitrary w-[10px] h-[20px]', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WSpacer(className: 'w-[10px] h-[20px]')),
        );

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        expect(sizedBox.width, 10.0);
        expect(sizedBox.height, 20.0);
      });
    });

    group('Responsive Breakpoints', () {
      testWidgets('applies responsive height classes', (tester) async {
        // Set screen size to md breakpoint (768px)
        tester.view.physicalSize = const Size(768, 1024);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          wrapWithTheme(const WSpacer(className: 'h-4 md:h-8')),
        );

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        expect(sizedBox.height, 32.0); // md:h-8 should apply at 768px
      });
    });

    group('Usage in Flex Layouts', () {
      testWidgets('works inside Column', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            Column(
              children: const [
                Text('Before'),
                WSpacer(className: 'h-4'),
                Text('After'),
              ],
            ),
          ),
        );

        expect(find.text('Before'), findsOneWidget);
        expect(find.text('After'), findsOneWidget);
        expect(find.byType(WSpacer), findsOneWidget);
      });

      testWidgets('works inside Row', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            Row(
              children: const [
                Text('Left'),
                WSpacer(className: 'w-4'),
                Text('Right'),
              ],
            ),
          ),
        );

        expect(find.text('Left'), findsOneWidget);
        expect(find.text('Right'), findsOneWidget);
        expect(find.byType(WSpacer), findsOneWidget);
      });

      testWidgets('works inside WDiv flex-col', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WDiv(
              className: 'flex flex-col',
              children: const [
                WText('First'),
                WSpacer(className: 'h-6'),
                WText('Second'),
              ],
            ),
          ),
        );

        expect(find.byType(WSpacer), findsOneWidget);
        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
        expect(sizedBox.height, 24.0);
      });

      testWidgets('works inside WDiv flex-row', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WDiv(
              className: 'flex flex-row',
              children: const [
                WText('Left'),
                WSpacer(className: 'w-8'),
                WText('Right'),
              ],
            ),
          ),
        );

        expect(find.byType(WSpacer), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles empty className gracefully', (tester) async {
        await tester.pumpWidget(wrapWithTheme(const WSpacer(className: '')));

        expect(find.byType(WSpacer), findsOneWidget);
        // Should render as empty SizedBox
        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        expect(sizedBox.width, isNull);
        expect(sizedBox.height, isNull);
      });

      testWidgets('handles whitespace-only className', (tester) async {
        await tester.pumpWidget(wrapWithTheme(const WSpacer(className: '   ')));

        expect(find.byType(WSpacer), findsOneWidget);
      });

      testWidgets('ignores non-sizing classes', (tester) async {
        // bg-red-500 should be ignored, only h-4 applied
        await tester.pumpWidget(
          wrapWithTheme(const WSpacer(className: 'h-4 bg-red-500')),
        );

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        expect(sizedBox.height, 16.0);
        // SizedBox doesn't have decoration, bg-* should be ignored
      });
    });

    group('Const Constructor', () {
      testWidgets('can be used as const', (tester) async {
        // This test verifies const constructor works
        const spacer = WSpacer(className: 'h-4');
        await tester.pumpWidget(wrapWithTheme(spacer));

        expect(find.byType(WSpacer), findsOneWidget);
      });

      testWidgets('multiple const spacers render consistently', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            Column(
              children: const [
                WSpacer(className: 'h-4'),
                WSpacer(className: 'h-4'),
              ],
            ),
          ),
        );

        // Both spacers should render with same height
        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
        expect(sizedBoxes.length, greaterThanOrEqualTo(2));
      });
    });
  });
}
