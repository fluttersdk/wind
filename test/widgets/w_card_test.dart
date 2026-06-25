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

  group('WCard Widget Tests', () {
    group('Construction', () {
      test('creates with child only', () {
        const card = WCard(child: Text('body'));
        expect(card.child, isA<Text>());
        expect(card.header, isNull);
        expect(card.footer, isNull);
        expect(card.className, isNull);
      });

      test('stores header and footer slots', () {
        const card = WCard(
          header: Text('header'),
          footer: Text('footer'),
          child: Text('body'),
        );
        expect(card.header, isA<Text>());
        expect(card.footer, isA<Text>());
      });

      test('stores className', () {
        const card = WCard(
          className: 'rounded-xl shadow-md p-4',
          child: Text('body'),
        );
        expect(card.className, 'rounded-xl shadow-md p-4');
      });
    });

    group('Rendering', () {
      testWidgets('renders child body', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WCard(child: Text('body content')),
          ),
        );
        await tester.pump();

        expect(find.text('body content'), findsOneWidget);
      });

      testWidgets('renders without header and footer when not provided', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WCard(child: Text('body')),
          ),
        );
        await tester.pump();

        // Only body text is present
        expect(find.text('body'), findsOneWidget);
        expect(find.text('header'), findsNothing);
        expect(find.text('footer'), findsNothing);
      });

      testWidgets('renders header slot when provided', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WCard(
              header: Text('card header'),
              child: Text('body'),
            ),
          ),
        );
        await tester.pump();

        expect(find.text('card header'), findsOneWidget);
        expect(find.text('body'), findsOneWidget);
      });

      testWidgets('renders footer slot when provided', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WCard(
              footer: Text('card footer'),
              child: Text('body'),
            ),
          ),
        );
        await tester.pump();

        expect(find.text('card footer'), findsOneWidget);
        expect(find.text('body'), findsOneWidget);
      });

      testWidgets('renders all three slots when all provided', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WCard(
              header: Text('card header'),
              footer: Text('card footer'),
              child: Text('body'),
            ),
          ),
        );
        await tester.pump();

        expect(find.text('card header'), findsOneWidget);
        expect(find.text('body'), findsOneWidget);
        expect(find.text('card footer'), findsOneWidget);
      });
    });

    group('className threading', () {
      testWidgets('passes className to root WDiv', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WCard(
              className: 'rounded-lg shadow-sm p-4',
              child: Text('body'),
            ),
          ),
        );
        await tester.pump();

        // The root WDiv carries the provided className
        final rootDiv = tester.widgetList<WDiv>(find.byType(WDiv)).first;
        expect(rootDiv.className, contains('rounded-lg'));
        expect(rootDiv.className, contains('shadow-sm'));
        expect(rootDiv.className, contains('p-4'));
      });

      testWidgets('uses default className when none provided', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WCard(child: Text('body')),
          ),
        );
        await tester.pump();

        final rootDiv = tester.widgetList<WDiv>(find.byType(WDiv)).first;
        // Default className includes flex-col for vertical card layout
        expect(rootDiv.className, contains('flex-col'));
      });
    });
  });
}
