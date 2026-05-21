import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Coverage-fill tests for the simpler uncovered branches in
/// `lib/src/widgets/w_div.dart`. Sister file to `spacing_test.dart` and
/// friends. Each `testWidgets` case targets a single decorator branch in
/// `_buildImpl` or `_buildCompositionPipeline` whose existing coverage was 0.
///
/// Out-of-scope (covered by the deeper layout fixtures elsewhere):
/// - Intrinsic-height edges (lines ~745-803)
/// - scroll-primary deep nesting (lines ~1084-1141)
/// - WindFlexOverflowScope interaction
Widget wrapWithTheme(Widget child) {
  return MaterialApp(
    home: WindTheme(
      data: WindThemeData(),
      child: child,
    ),
  );
}

void main() {
  setUp(() {
    WindParser.clearCache();
  });

  group('WDiv coverage padding', () {
    group('text-style decorator wrap', () {
      testWidgets(
        'text-color triggers DefaultTextStyle.merge wrap (lines 228-237)',
        (tester) async {
          // text-red-500 sets WindStyle.color, which makes toTextStyle()
          // non-empty, which routes into the DefaultTextStyle.merge branch.
          await tester.pumpWidget(
            wrapWithTheme(
              const WDiv(
                className: 'text-red-500 text-center',
                child: Text('Hello'),
              ),
            ),
          );

          expect(tester.takeException(), isNull);
          final merge = tester.widget<DefaultTextStyle>(
            find
                .descendant(
                  of: find.byType(WDiv),
                  matching: find.byType(DefaultTextStyle),
                )
                .first,
          );
          expect(merge.style.color, isNotNull);
          expect(merge.textAlign, TextAlign.center);
        },
      );
    });

    group('opacity decorator wrap', () {
      testWidgets(
        'opacity + transition wraps with AnimatedOpacity (lines 254-260)',
        (tester) async {
          // opacity-50 + duration-300 routes into the AnimatedOpacity branch
          // (opacity != null && transitionDuration != null).
          await tester.pumpWidget(
            wrapWithTheme(
              const WDiv(
                className: 'opacity-50 duration-300',
                child: Text('Fading'),
              ),
            ),
          );

          expect(tester.takeException(), isNull);
          expect(find.byType(AnimatedOpacity), findsOneWidget);
          final fade = tester.widget<AnimatedOpacity>(
            find.byType(AnimatedOpacity),
          );
          expect(fade.opacity, closeTo(0.5, 0.001));
          expect(fade.duration, const Duration(milliseconds: 300));
        },
      );

      testWidgets(
        'opacity-only without duration wraps with static Opacity (line 263)',
        (tester) async {
          await tester.pumpWidget(
            wrapWithTheme(
              const WDiv(
                className: 'opacity-25',
                child: Text('Quiet'),
              ),
            ),
          );

          expect(tester.takeException(), isNull);
          expect(find.byType(Opacity), findsWidgets);
          expect(find.byType(AnimatedOpacity), findsNothing);
        },
      );
    });

    group('outer-layer decorators', () {
      testWidgets(
        'mx-auto wraps the widget with Align(topCenter) (lines 1270-1274)',
        (tester) async {
          // mx-auto sets WindStyle.marginXAuto = true and routes into the
          // Align(alignment: Alignment.topCenter) branch.
          await tester.pumpWidget(
            wrapWithTheme(
              const WDiv(
                className: 'mx-auto w-32',
                child: Text('Centered'),
              ),
            ),
          );

          expect(tester.takeException(), isNull);
          final aligns = tester
              .widgetList<Align>(
                find.descendant(
                  of: find.byType(WDiv),
                  matching: find.byType(Align),
                ),
              )
              .where((a) => a.alignment == Alignment.topCenter);
          expect(
            aligns.isNotEmpty,
            isTrue,
            reason: 'mx-auto must produce Align(topCenter) wrapper',
          );
        },
      );

      testWidgets(
        'flex-fit produces Flexible parent-data wrapper (lines 1294-1298)',
        (tester) async {
          // shrink alone sets flexFit (without flex), routing into the
          // Flexible branch instead of Expanded.
          await tester.pumpWidget(
            wrapWithTheme(
              Row(
                children: const [
                  WDiv(
                    className: 'shrink',
                    child: Text('Shrinkable'),
                  ),
                ],
              ),
            ),
          );

          expect(tester.takeException(), isNull);
          // The shrink token resolves to flexFit: FlexFit.loose (or tight),
          // which produces a Flexible wrapper as the OUTERMOST WDiv child.
          expect(
            find.descendant(
              of: find.byType(WDiv),
              matching: find.byType(Flexible),
            ),
            findsWidgets,
          );
        },
      );
    });

    group('debug + visibility short-circuits', () {
      testWidgets(
        'debug className triggers logger path without exception (lines 178-179)',
        (tester) async {
          // The `debug` token flips styles.debug = true, exercising the
          // logger.logStep + setFinalStyles + printFinalCode calls.
          await tester.pumpWidget(
            wrapWithTheme(
              const WDiv(
                className: 'debug p-4 bg-red-500',
                child: Text('Inspect me'),
              ),
            ),
          );

          expect(tester.takeException(), isNull);
          expect(find.text('Inspect me'), findsOneWidget);
        },
      );

      testWidgets(
        'hidden short-circuits to SizedBox.shrink (line 188)',
        (tester) async {
          // styles.isHidden routes to the early-return SizedBox.shrink branch.
          await tester.pumpWidget(
            wrapWithTheme(
              const WDiv(
                className: 'hidden',
                child: Text('You cannot see me'),
              ),
            ),
          );

          expect(tester.takeException(), isNull);
          expect(find.text('You cannot see me'), findsNothing);
          expect(
            find.descendant(
              of: find.byType(WDiv),
              matching: find.byType(SizedBox),
            ),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'scroll-primary stored without overflow leaves no scroll widget',
        (tester) async {
          // scrollPrimary: true is a no-op when no overflow class is set.
          // Verifies the flag is stored but does not insert a ScrollView.
          await tester.pumpWidget(
            wrapWithTheme(
              const WDiv(
                className: 'p-4',
                scrollPrimary: true,
                child: Text('No scroll'),
              ),
            ),
          );

          expect(tester.takeException(), isNull);
          expect(find.byType(SingleChildScrollView), findsNothing);
          expect(find.text('No scroll'), findsOneWidget);
        },
      );
    });

    group('wrap layout main/cross axis translation', () {
      testWidgets(
        'wrap with justify-between exercises _translateMainAxisToWrap (lines 1326-1333)',
        (tester) async {
          // The wrap display layout routes mainAxisAlignment through the
          // _translateMainAxisToWrap switch. spaceBetween hits a non-default
          // arm of the switch.
          await tester.pumpWidget(
            wrapWithTheme(
              const WDiv(
                className: 'wrap justify-between items-center gap-2',
                children: [
                  Text('A'),
                  Text('B'),
                  Text('C'),
                ],
              ),
            ),
          );

          expect(tester.takeException(), isNull);
          final wrap = tester.widget<Wrap>(find.byType(Wrap));
          expect(wrap.alignment, WrapAlignment.spaceBetween);
          expect(wrap.crossAxisAlignment, WrapCrossAlignment.center);
        },
      );

      testWidgets(
        'wrap with justify-center + items-end maps to center / end',
        (tester) async {
          // Hits the MainAxisAlignment.center and CrossAxisAlignment.end
          // arms of the wrap-translation switches (lines 1330 + 1341).
          await tester.pumpWidget(
            wrapWithTheme(
              const WDiv(
                className: 'wrap justify-center items-end',
                children: [
                  Text('A'),
                  Text('B'),
                ],
              ),
            ),
          );

          expect(tester.takeException(), isNull);
          final wrap = tester.widget<Wrap>(find.byType(Wrap));
          expect(wrap.alignment, WrapAlignment.center);
          expect(wrap.crossAxisAlignment, WrapCrossAlignment.end);
        },
      );

      testWidgets(
        'wrap with justify-around exercises spaceAround arm (line 1332)',
        (tester) async {
          // Hits MainAxisAlignment.spaceAround arm of the wrap translation.
          await tester.pumpWidget(
            wrapWithTheme(
              const WDiv(
                className: 'wrap justify-around',
                children: [
                  Text('A'),
                  Text('B'),
                ],
              ),
            ),
          );

          expect(tester.takeException(), isNull);
          final wrap = tester.widget<Wrap>(find.byType(Wrap));
          expect(wrap.alignment, WrapAlignment.spaceAround);
        },
      );
    });

    group('extra decorator branches', () {
      testWidgets(
        'animate-spin wraps the widget via wrapWithAnimation (lines 270-276)',
        (tester) async {
          // animate-spin sets WindStyle.animationType, routing through the
          // animation-wrapper branch in _buildImpl.
          await tester.pumpWidget(
            wrapWithTheme(
              const WDiv(
                className: 'animate-spin',
                child: Icon(Icons.refresh),
              ),
            ),
          );

          // Cannot pumpAndSettle - animation runs forever - but pump should
          // not throw.
          expect(tester.takeException(), isNull);
          expect(find.byIcon(Icons.refresh), findsOneWidget);
        },
      );

      testWidgets(
        'align-self-center wraps with Align outer layer (lines 1264-1265)',
        (tester) async {
          // align-self-center sets WindStyle.alignment, routing into the
          // outer-layer Align branch.
          await tester.pumpWidget(
            wrapWithTheme(
              const WDiv(
                className: 'align-self-center',
                child: Text('Self centered'),
              ),
            ),
          );

          expect(tester.takeException(), isNull);
          final aligns = tester
              .widgetList<Align>(
                find.descendant(
                  of: find.byType(WDiv),
                  matching: find.byType(Align),
                ),
              )
              .where((a) => a.alignment == Alignment.center);
          expect(aligns.isNotEmpty, isTrue);
        },
      );

      testWidgets(
        'hover prefix wraps WDiv with WAnchor (lines 136-140, 152-155)',
        (tester) async {
          // Presence of `hover:` triggers the WAnchor wrap + state injection
          // path at the top of build().
          await tester.pumpWidget(
            wrapWithTheme(
              const WDiv(
                className: 'hover:bg-red-500',
                child: Text('Hoverable'),
              ),
            ),
          );

          expect(tester.takeException(), isNull);
          expect(
            find.descendant(
              of: find.byType(WDiv),
              matching: find.byType(WAnchor),
            ),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'relative single absolute child renders Stack with Positioned (lines 302, 304)',
        (tester) async {
          // Single child + relative + child is itself absolute-positioned
          // routes through the early Stack(_buildPositionedChild) branch.
          await tester.pumpWidget(
            wrapWithTheme(
              const WDiv(
                className: 'relative w-32 h-32',
                child: WDiv(
                  className: 'absolute top-0 left-0',
                  child: Text('Pinned'),
                ),
              ),
            ),
          );

          expect(tester.takeException(), isNull);
          expect(
            find.descendant(
              of: find.byType(WDiv).first,
              matching: find.byType(Stack),
            ),
            findsWidgets,
          );
          expect(
            find.descendant(
              of: find.byType(WDiv).first,
              matching: find.byType(Positioned),
            ),
            findsWidgets,
          );
        },
      );

      testWidgets(
        'relative parent with grid display children mixes layouts (line 412)',
        (tester) async {
          // relative + grid + normal children + absolute child exercises the
          // grid-inside-relative branch in _buildCoreStructure (Case B).
          await tester.pumpWidget(
            wrapWithTheme(
              const WDiv(
                className: 'relative grid grid-cols-2 gap-2',
                children: [
                  Text('A'),
                  Text('B'),
                  WDiv(
                    className: 'absolute top-0 right-0',
                    child: Text('Badge'),
                  ),
                ],
              ),
            ),
          );

          expect(tester.takeException(), isNull);
          expect(find.text('A'), findsOneWidget);
          expect(find.text('Badge'), findsOneWidget);
        },
      );

      testWidgets(
        'grid with overflow-x-scroll uses Row layout (lines 745-758)',
        (tester) async {
          // overflow-x-scroll on a grid container routes into the Row-Grid
          // branch in _buildGridStructure (horizontal-scrollable grid).
          await tester.pumpWidget(
            wrapWithTheme(
              const SizedBox(
                width: 200,
                height: 200,
                child: WDiv(
                  className: 'grid grid-cols-3 overflow-x-scroll gap-4',
                  children: [
                    Text('A'),
                    Text('B'),
                    Text('C'),
                    Text('D'),
                  ],
                ),
              ),
            ),
          );

          expect(tester.takeException(), isNull);
          // The Row-Grid branch produces a Row + SingleChildScrollView wrap
          // for horizontal scroll.
          expect(find.byType(SingleChildScrollView), findsWidgets);
        },
      );
    });
  });
}
