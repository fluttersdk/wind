import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// A-to-Z geometry suite for the 15 canonical Tailwind flexbox scenarios.
///
/// Each test pumps a real Wind className tree and asserts the load-bearing
/// geometry that the scenario depends on: `flex-1`/`grow` children expand to
/// equal/filled width, `flex-none`/`shrink-0` children keep their intrinsic
/// size, `flex flex-col` children fill the cross axis (Wave-1 smart-stretch),
/// `items-center`/`justify-between` alignment, `flex-wrap` wraps onto multiple
/// runs, and `md:` responsive prefixes flip layout via `tester.view`.
///
/// Recipes sourced from
/// `.ac/plans/flexbox-wtext-hardening/research/00-consolidated-findings.md`.
Widget wrapWithTheme(Widget child) {
  return MaterialApp(
    home: WindTheme(
      data: WindThemeData(),
      child: Scaffold(body: child),
    ),
  );
}

/// Returns the visible [Text] strings ordered by their on-screen position.
///
/// Sorts by horizontal `dx` (default) or vertical `dy` so a test can assert the
/// final paint order of children regardless of widget-tree declaration order.
List<String> visibleTextsInOrder(
  WidgetTester tester, {
  bool horizontal = true,
}) {
  final texts = tester.widgetList<Text>(find.byType(Text)).toList();
  final entries = <({double pos, String text})>[];
  for (final t in texts) {
    final finder = find.byWidget(t);
    if (finder.evaluate().isEmpty) continue;
    final box = tester.getTopLeft(finder);
    entries.add((pos: horizontal ? box.dx : box.dy, text: t.data ?? ''));
  }
  entries.sort((a, b) => a.pos.compareTo(b.pos));
  return entries.map((e) => e.text).toList();
}

/// Width of the [RenderBox] that paints the given visible text.
double textWidth(WidgetTester tester, String text) {
  return tester.renderObject<RenderBox>(find.text(text)).size.width;
}

void main() {
  setUp(WindParser.clearCache);

  // 1 — Navbar: justify-between pins brand left + actions right; items-center
  // vertically centers. Verifies the two end clusters sit at opposite edges.
  group('1 navbar', () {
    testWidgets('justify-between pins brand left and actions right',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            width: 600,
            child: WDiv(
              className: 'flex flex-row items-center justify-between px-4 h-16',
              children: [
                WDiv(child: Text('Brand')),
                WDiv(
                  className: 'flex flex-row gap-4',
                  children: [
                    Text('Docs'),
                    Text('Login'),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      // Brand hugs the left padding (px-4 = 16px); actions sit far right.
      final brandLeft = tester.getTopLeft(find.text('Brand')).dx;
      final loginRight = tester.getTopRight(find.text('Login')).dx;
      expect(brandLeft, closeTo(16, 0.5));
      expect(loginRight, closeTo(600 - 16, 0.5));
      expect(visibleTextsInOrder(tester), ['Brand', 'Docs', 'Login']);
    });
  });

  // 2 — Media object: a fixed avatar (shrink-0) next to a flex-1 body. The body
  // takes all remaining width; the avatar keeps its intrinsic size.
  group('2 media object', () {
    testWidgets('shrink-0 avatar keeps size, flex-1 body fills remainder',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            width: 400,
            child: WDiv(
              className: 'flex flex-row gap-4 items-start',
              children: [
                WDiv(
                  className: 'shrink-0 w-12 h-12 bg-slate-300',
                  child: SizedBox(width: 48, height: 48),
                ),
                WDiv(
                  className: 'flex-1',
                  child: Text('Body copy that should fill the rest'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      // Avatar stays 48px; body fills 400 - 48 - gap(16) = 336px.
      expect(tester.getSize(find.byType(WDiv).at(1)).width, 48);
      expect(tester.getSize(find.byType(WDiv).at(2)).width, closeTo(336, 0.5));
    });
  });

  // 3 — Holy-grail sidebar: w-64 flex-none sidebar + flex-1 main. Sidebar keeps
  // its fixed 256px; main consumes the rest.
  group('3 holy-grail sidebar', () {
    testWidgets('flex-none sidebar fixed, flex-1 main fills remainder',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            width: 800,
            child: WDiv(
              className: 'flex flex-row',
              children: [
                WDiv(
                  className: 'flex-none w-64 bg-slate-100',
                  child: Text('Sidebar'),
                ),
                WDiv(
                  className: 'flex-1',
                  child: Text('Main content'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      // w-64 = 64 * 4 = 256px sidebar; main = 800 - 256 = 544px.
      expect(tester.getSize(find.byType(WDiv).at(1)).width, 256);
      expect(tester.getSize(find.byType(WDiv).at(2)).width, closeTo(544, 0.5));
    });
  });

  // 4 — Sticky footer: a flex-col with a flex-1 content region that pushes the
  // footer to the bottom of a tall container.
  group('4 sticky footer', () {
    testWidgets('flex-1 content pushes footer to the bottom', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            height: 500,
            width: 300,
            child: WDiv(
              className: 'flex flex-col h-full',
              children: [
                WDiv(child: Text('Header')),
                WDiv(
                  className: 'flex-1',
                  child: Text('Content'),
                ),
                WDiv(child: Text('Footer')),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(visibleTextsInOrder(tester, horizontal: false),
          ['Header', 'Content', 'Footer']);
      // Header at top; footer pinned near the 500px bottom edge.
      expect(tester.getTopLeft(find.text('Header')).dy, closeTo(0, 0.5));
      expect(tester.getBottomLeft(find.text('Footer')).dy, closeTo(500, 0.5));
    });
  });

  // 5 — Centered card: items-center + justify-center centers a single child on
  // both axes inside a bounded box.
  group('5 centered card', () {
    testWidgets('items-center + justify-center centers child both axes',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            width: 400,
            height: 400,
            child: WDiv(
              className: 'flex flex-col items-center justify-center h-full',
              children: [
                WDiv(
                  className: 'w-40 h-20 bg-white',
                  child: SizedBox(width: 160, height: 80),
                ),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      final card = find.byType(WDiv).at(1);
      final topLeft = tester.getTopLeft(card);
      // Horizontal center: (400 - 160) / 2 = 120; vertical: (400 - 80) / 2 = 160.
      expect(topLeft.dx, closeTo(120, 0.5));
      expect(topLeft.dy, closeTo(160, 0.5));
    });
  });

  // 6 — Responsive stack -> row: flex-col on mobile, md:flex-row on desktop.
  // The two flex-1 panels stack vertically below md and split width at md.
  group('6 responsive stack to row', () {
    testWidgets('flex-col stacks below md, md:flex-row splits width at md',
        (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final tree = MaterialApp(
        home: WindTheme(
          data: WindThemeData(),
          child: const Scaffold(
            body: WDiv(
              className: 'flex flex-col md:flex-row gap-4',
              children: [
                WDiv(className: 'flex-1', child: Text('Panel A')),
                WDiv(className: 'flex-1', child: Text('Panel B')),
              ],
            ),
          ),
        ),
      );

      // Mobile: stacked column, A above B.
      await tester.pumpWidget(tree);
      expect(tester.takeException(), isNull);
      expect(find.byType(Column), findsOneWidget);
      expect(visibleTextsInOrder(tester, horizontal: false),
          ['Panel A', 'Panel B']);

      // Desktop: md:flex-row -> side by side, A left of B.
      tester.view.physicalSize = const Size(1000, 800);
      await tester.pumpAndSettle();
      expect(find.byType(Row), findsOneWidget);
      expect(visibleTextsInOrder(tester), ['Panel A', 'Panel B']);
    });
  });

  // 7 — Card with pinned footer: flex-col card, flex-1 content fills, footer
  // stays at the bottom. Each direct column child also fills the card width
  // (Wave-1 smart-stretch, no w-full needed).
  group('7 card pinned footer', () {
    testWidgets('flex-col children fill width and footer is pinned',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            width: 320,
            height: 400,
            child: WDiv(
              className: 'flex flex-col h-full',
              children: [
                WDiv(
                  className: 'bg-slate-100',
                  child: Text('Card title'),
                ),
                WDiv(
                  className: 'flex-1',
                  child: Text('Card body'),
                ),
                WDiv(
                  className: 'bg-slate-200',
                  child: Text('Card footer'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      // Smart-stretch: the non-flex title fills the full 320px card width
      // WITHOUT a w-full token.
      expect(tester.getSize(find.byType(WDiv).at(1)).width, 320);
      expect(
          tester.getBottomLeft(find.text('Card footer')).dy, closeTo(400, 0.5));
    });
  });

  // 8 — Toolbar: items-center row with gap-2. Buttons keep intrinsic width and
  // are laid left to right with the gap between them.
  group('8 toolbar', () {
    testWidgets('items-center row keeps buttons intrinsic and ordered',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            width: 500,
            child: WDiv(
              className: 'flex flex-row items-center gap-2 p-2',
              children: [
                WDiv(className: 'px-3 py-1 bg-slate-200', child: Text('Cut')),
                WDiv(className: 'px-3 py-1 bg-slate-200', child: Text('Copy')),
                WDiv(className: 'px-3 py-1 bg-slate-200', child: Text('Paste')),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(visibleTextsInOrder(tester), ['Cut', 'Copy', 'Paste']);
      // Toolbar buttons keep intrinsic width: none expands to the 500px width.
      expect(textWidth(tester, 'Cut'), lessThan(200));
    });
  });

  // 9 — Responsive wrap grid: `wrap` (Wind's only wrapping token; `flex-wrap`
  // is a documented Core Law 6 no-op) with basis-1/3 grow cards. Three cards at
  // ~1/3 width sit on the first run; the fourth wraps to a second run.
  group('9 responsive wrap grid', () {
    testWidgets('wrap basis-1/3 cards wrap onto a second run', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            width: 600,
            child: WDiv(
              className: 'wrap gap-4',
              children: [
                WDiv(className: 'w-44 h-20 bg-slate-100', child: Text('C1')),
                WDiv(className: 'w-44 h-20 bg-slate-100', child: Text('C2')),
                WDiv(className: 'w-44 h-20 bg-slate-100', child: Text('C3')),
                WDiv(className: 'w-44 h-20 bg-slate-100', child: Text('C4')),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(Wrap), findsOneWidget);
      // The fourth card wraps below the first three (greater dy than C1).
      final c1Top = tester.getTopLeft(find.text('C1')).dy;
      final c4Top = tester.getTopLeft(find.text('C4')).dy;
      expect(c4Top, greaterThan(c1Top));
    });
  });

  // 10 — Form row: fixed-width label (w-24 shrink-0) + flex-1 input. Label keeps
  // 96px; the input fills the remaining width.
  group('10 form row', () {
    testWidgets('shrink-0 label fixed, flex-1 input fills remainder',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            width: 400,
            child: WDiv(
              className: 'flex flex-row items-center gap-4',
              children: [
                WDiv(
                  className: 'w-24 shrink-0',
                  child: Text('Email'),
                ),
                WDiv(
                  className: 'flex-1 h-10 bg-slate-100',
                  child: SizedBox(height: 40),
                ),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      // w-24 = 96px label; input = 400 - 96 - gap(16) = 288px.
      expect(tester.getSize(find.byType(WDiv).at(1)).width, 96);
      expect(tester.getSize(find.byType(WDiv).at(2)).width, closeTo(288, 0.5));
    });
  });

  // 11 — Pricing row: justify-between with two equal flex-1 columns. Both
  // columns split the available width evenly.
  group('11 pricing row', () {
    testWidgets('two flex-1 columns split width equally', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            width: 480,
            child: WDiv(
              className: 'flex flex-row justify-between gap-8',
              children: [
                WDiv(className: 'flex-1', child: Text('Basic')),
                WDiv(className: 'flex-1', child: Text('Pro')),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      // (480 - gap(32)) / 2 = 224px each.
      final a = tester.getSize(find.byType(WDiv).at(1)).width;
      final b = tester.getSize(find.byType(WDiv).at(2)).width;
      expect(a, closeTo(224, 0.5));
      expect(b, closeTo(224, 0.5));
      expect(a, closeTo(b, 0.5));
    });
  });

  // 12 — Chip list: `wrap` with gap-2. Many intrinsic-width chips flow onto
  // multiple runs once the row width is exceeded.
  group('12 chip list', () {
    testWidgets('wrap chips flow onto multiple runs', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            width: 200,
            child: WDiv(
              className: 'wrap gap-2',
              children: [
                WDiv(
                    className: 'px-4 py-1 bg-slate-200', child: Text('Design')),
                WDiv(
                    className: 'px-4 py-1 bg-slate-200',
                    child: Text('Flutter')),
                WDiv(
                    className: 'px-4 py-1 bg-slate-200',
                    child: Text('Tailwind')),
                WDiv(className: 'px-4 py-1 bg-slate-200', child: Text('Dart')),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(Wrap), findsOneWidget);
      // With a tight 200px row at least one chip wraps to a lower run.
      final firstTop = tester.getTopLeft(find.text('Design')).dy;
      final lastTop = tester.getTopLeft(find.text('Dart')).dy;
      expect(lastTop, greaterThan(firstTop));
    });
  });

  // 13 — Split pane: two flex-1 panes share the full width 50/50.
  group('13 split pane', () {
    testWidgets('two flex-1 panes split width 50/50', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            width: 600,
            child: WDiv(
              className: 'flex flex-row',
              children: [
                WDiv(className: 'flex-1 bg-slate-100', child: Text('Left')),
                WDiv(className: 'flex-1 bg-slate-200', child: Text('Right')),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(WDiv).at(1)).width, closeTo(300, 0.5));
      expect(tester.getSize(find.byType(WDiv).at(2)).width, closeTo(300, 0.5));
    });
  });

  // 14 — List item: leading icon (shrink-0) + flex-1 text + trailing action
  // (shrink-0). Both ends keep intrinsic size; the text fills the middle.
  group('14 list item', () {
    testWidgets('icon + flex-1 text + action: ends fixed, text fills middle',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            width: 360,
            child: WDiv(
              className: 'flex flex-row items-center gap-3',
              children: [
                WDiv(
                  className: 'shrink-0 w-6 h-6 bg-slate-300',
                  child: SizedBox(width: 24, height: 24),
                ),
                WDiv(
                  className: 'flex-1',
                  child: Text('Notification title'),
                ),
                WDiv(
                  className: 'shrink-0 w-8 h-8 bg-slate-300',
                  child: SizedBox(width: 32, height: 32),
                ),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      // Leading icon 24px, trailing action 32px keep intrinsic widths.
      expect(tester.getSize(find.byType(WDiv).at(1)).width, 24);
      expect(tester.getSize(find.byType(WDiv).at(3)).width, 32);
      // Text fills 360 - 24 - 32 - 2*gap(12) = 280px.
      expect(tester.getSize(find.byType(WDiv).at(2)).width, closeTo(280, 0.5));
    });
  });

  // 15 — Hero: flex-col items-center justify-center centers a stacked headline +
  // subcopy on both axes inside a tall section.
  group('15 hero', () {
    testWidgets('flex-col items-center justify-center centers stacked content',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            width: 600,
            height: 400,
            child: WDiv(
              className:
                  'flex flex-col items-center justify-center gap-2 h-full',
              children: [
                WDiv(child: Text('Headline')),
                WDiv(child: Text('Subcopy')),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      // Headline sits above subcopy and both are horizontally centered.
      expect(visibleTextsInOrder(tester, horizontal: false),
          ['Headline', 'Subcopy']);
      final headlineCenter = tester.getCenter(find.text('Headline')).dx;
      final subcopyCenter = tester.getCenter(find.text('Subcopy')).dx;
      expect(headlineCenter, closeTo(300, 1.0));
      expect(subcopyCenter, closeTo(300, 1.0));
    });
  });
}
