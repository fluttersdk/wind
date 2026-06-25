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

  group('WTabs Widget Tests', () {
    group('Construction', () {
      test('creates with required props', () {
        final widget = WTabs(
          tabs: const ['One', 'Two'],
          selectedIndex: 0,
          panelBuilder: _fakePanelBuilder,
        );
        expect(widget.tabs.length, 2);
        expect(widget.selectedIndex, 0);
      });

      test('accepts optional classNames', () {
        final widget = WTabs(
          tabs: const ['A'],
          selectedIndex: 0,
          panelBuilder: _fakePanelBuilder,
          listClassName: 'flex gap-2',
          tabClassName: 'px-4 py-2',
          selectedTabClassName: 'border-b-2',
          panelClassName: 'pt-4',
        );
        expect(widget.listClassName, 'flex gap-2');
        expect(widget.tabClassName, 'px-4 py-2');
        expect(widget.selectedTabClassName, 'border-b-2');
        expect(widget.panelClassName, 'pt-4');
      });

      test('asserts tabs must not be empty', () {
        expect(
          () => WTabs(
            tabs: const [],
            selectedIndex: 0,
            panelBuilder: _fakePanelBuilder,
          ),
          throwsA(isA<AssertionError>()),
        );
      });

      test('asserts selectedIndex must be within range (too high)', () {
        expect(
          () => WTabs(
            tabs: const ['One', 'Two'],
            selectedIndex: 2,
            panelBuilder: _fakePanelBuilder,
          ),
          throwsA(isA<AssertionError>()),
        );
      });

      test('asserts selectedIndex must be within range (negative)', () {
        expect(
          () => WTabs(
            tabs: const ['One', 'Two'],
            selectedIndex: -1,
            panelBuilder: _fakePanelBuilder,
          ),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    group('Rendering', () {
      testWidgets('renders a WDiv for the tab list and each tab', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WTabs(
              tabs: const ['Alpha', 'Beta', 'Gamma'],
              selectedIndex: 0,
              panelBuilder: (index) => Text('Panel $index'),
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(WTabs), findsOneWidget);
        // 3 tab labels
        expect(find.text('Alpha'), findsOneWidget);
        expect(find.text('Beta'), findsOneWidget);
        expect(find.text('Gamma'), findsOneWidget);
      });

      testWidgets('renders panel content for the selected tab', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WTabs(
              tabs: const ['Tab1', 'Tab2'],
              selectedIndex: 1,
              panelBuilder: (index) => Text('Content $index'),
            ),
          ),
        );
        await tester.pump();

        expect(find.text('Content 1'), findsOneWidget);
        expect(find.text('Content 0'), findsNothing);
      });

      testWidgets('renders WAnchor for each tab', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WTabs(
              tabs: const ['X', 'Y'],
              selectedIndex: 0,
              panelBuilder: (index) => Text('P$index'),
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(WAnchor), findsNWidgets(2));
      });
    });

    group('Selected state', () {
      testWidgets('active tab WAnchor carries selected state', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WTabs(
              tabs: const ['First', 'Second'],
              selectedIndex: 0,
              panelBuilder: (index) => Text('Panel $index'),
            ),
          ),
        );
        await tester.pump();

        // Find all WAnchor widgets — first one is the selected tab.
        final anchors = tester.widgetList<WAnchor>(find.byType(WAnchor));
        final firstAnchor = anchors.first;
        expect(firstAnchor.states, contains('selected'));
      });

      testWidgets('inactive tab WAnchor does not carry selected state', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WTabs(
              tabs: const ['First', 'Second'],
              selectedIndex: 0,
              panelBuilder: (index) => Text('Panel $index'),
            ),
          ),
        );
        await tester.pump();

        final anchors =
            tester.widgetList<WAnchor>(find.byType(WAnchor)).toList();
        // Second anchor (index 1) is not selected.
        expect(anchors[1].states?.contains('selected') ?? false, isFalse);
      });

      testWidgets('tabClassName applied to each tab WDiv', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WTabs(
              tabs: const ['A', 'B'],
              selectedIndex: 0,
              tabClassName: 'px-4 py-2 text-sm',
              panelBuilder: (index) => Text('P$index'),
            ),
          ),
        );
        await tester.pump();

        final divs = tester.widgetList<WDiv>(find.byType(WDiv)).toList();
        // The tab WDivs are the ones carrying the tabClassName.
        final tabDivs = divs
            .where((d) => d.className != null && d.className!.contains('px-4'))
            .toList();
        expect(tabDivs, isNotEmpty);
      });

      testWidgets('selectedTabClassName applied to active tab WDiv', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WTabs(
              tabs: const ['One', 'Two'],
              selectedIndex: 0,
              tabClassName: 'px-3 py-1',
              selectedTabClassName: 'border-b-2 border-blue-500',
              panelBuilder: (index) => Text('P$index'),
            ),
          ),
        );
        await tester.pump();

        // Find WDivs whose className contains the selectedTabClassName tokens.
        final divs = tester.widgetList<WDiv>(find.byType(WDiv)).toList();
        final selectedDiv = divs.firstWhere(
          (d) =>
              d.className != null &&
              d.className!.contains('border-b-2') &&
              d.className!.contains('border-blue-500'),
        );
        expect(selectedDiv, isNotNull);
      });
    });

    group('Interaction', () {
      testWidgets('calls onChanged with new index when tab tapped', (
        tester,
      ) async {
        int? tappedIndex;

        await tester.pumpWidget(
          wrapWithTheme(
            WTabs(
              tabs: const ['Tab A', 'Tab B', 'Tab C'],
              selectedIndex: 0,
              onChanged: (i) => tappedIndex = i,
              panelBuilder: (index) => Text('Panel $index'),
            ),
          ),
        );
        await tester.pump();

        await tester.tap(find.text('Tab B'));
        await tester.pump();

        expect(tappedIndex, 1);
      });

      testWidgets('tapping the already-selected tab still fires onChanged', (
        tester,
      ) async {
        int? tappedIndex;

        await tester.pumpWidget(
          wrapWithTheme(
            WTabs(
              tabs: const ['One', 'Two'],
              selectedIndex: 0,
              onChanged: (i) => tappedIndex = i,
              panelBuilder: (index) => Text('P $index'),
            ),
          ),
        );
        await tester.pump();

        await tester.tap(find.text('One'));
        await tester.pump();

        expect(tappedIndex, 0);
      });

      testWidgets(
        'a null onChanged leaves each tab non-interactive (no gesture)',
        (tester) async {
          await tester.pumpWidget(
            wrapWithTheme(
              WTabs(
                tabs: const ['One', 'Two'],
                selectedIndex: 0,
                panelBuilder: _fakePanelBuilder,
              ),
            ),
          );
          await tester.pump();

          final anchors =
              tester.widgetList<WAnchor>(find.byType(WAnchor)).toList();
          expect(anchors, isNotEmpty);
          for (final anchor in anchors) {
            expect(anchor.onTap, isNull);
          }
        },
      );

      testWidgets('panel swaps when selectedIndex changes', (tester) async {
        int currentIndex = 0;

        await tester.pumpWidget(
          wrapWithTheme(
            StatefulBuilder(
              builder: (context, setState) {
                return WTabs(
                  tabs: const ['Alpha', 'Beta'],
                  selectedIndex: currentIndex,
                  onChanged: (i) => setState(() => currentIndex = i),
                  panelBuilder: (index) => Text('Content $index'),
                );
              },
            ),
          ),
        );
        await tester.pump();

        expect(find.text('Content 0'), findsOneWidget);
        expect(find.text('Content 1'), findsNothing);

        await tester.tap(find.text('Beta'));
        await tester.pump();

        expect(find.text('Content 0'), findsNothing);
        expect(find.text('Content 1'), findsOneWidget);
      });
    });

    group('className threading', () {
      testWidgets('listClassName applied to the tab list WDiv', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WTabs(
              tabs: const ['P', 'Q'],
              selectedIndex: 0,
              listClassName: 'flex flex-row border-b border-gray-200',
              panelBuilder: (index) => Text('P$index'),
            ),
          ),
        );
        await tester.pump();

        final divs = tester.widgetList<WDiv>(find.byType(WDiv)).toList();
        final listDiv = divs.firstWhere(
          (d) =>
              d.className != null && d.className!.contains('border-gray-200'),
        );
        expect(listDiv.className, contains('flex'));
      });

      testWidgets('panelClassName applied to the panel wrapper WDiv', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WTabs(
              tabs: const ['X'],
              selectedIndex: 0,
              panelClassName: 'pt-4 text-gray-800',
              panelBuilder: (index) => Text('Content $index'),
            ),
          ),
        );
        await tester.pump();

        final divs = tester.widgetList<WDiv>(find.byType(WDiv)).toList();
        final panelDiv = divs.firstWhere(
          (d) => d.className != null && d.className!.contains('text-gray-800'),
        );
        expect(panelDiv.className, contains('pt-4'));
      });
    });
  });
}

Widget _fakePanelBuilder(int index) => Text('Panel $index');
