import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';
import 'package:fluttersdk_wind/src/state/wind_flex_overflow_scope.dart';

Widget wrapWithTheme(Widget child) {
  return MaterialApp(
    home: WindTheme(
      data: WindThemeData(),
      child: child,
    ),
  );
}

/// `WindFlexOverflowScope` is read as `maybeOf(context)?.skipExpanded ?? false`,
/// by exactly two call sites (`WDiv.build` and `WText.build`). A scope carrying
/// the value its own context already provides therefore answers every reader
/// identically to no scope at all, and costs an Element plus an inherited
/// dependency per flex container for it.
///
/// Measured driving uptizm: 729 of these across a four-route tour, 0.66 per
/// `WDiv` built, on an app that has no main-axis-scrollable flex on those
/// screens at all. So nearly every one of them was carrying `false` under a
/// `false`.
///
/// The scope is NOT always redundant, which is the whole reason this needs a
/// test rather than a delete: a `false` under an ancestor `true` is a real
/// shadow, and removing it would leak the ancestor's `true` into a subtree that
/// must see `false`.
void main() {
  /// Every `WindFlexOverflowScope` element in the current tree.
  int scopeCount() => find.byType(WindFlexOverflowScope).evaluate().length;

  group('WindFlexOverflowScope elision', () {
    testWidgets('a plain nested flex tree emits no scope at all',
        (WidgetTester tester) async {
      // Nothing here scrolls on its main axis, so every scope would carry
      // `false` under a `false`.
      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(
            className: 'flex flex-col',
            children: <Widget>[
              WDiv(
                className: 'flex flex-row',
                children: <Widget>[
                  WText('a'),
                  WText('b'),
                ],
              ),
              WDiv(
                className: 'flex flex-col',
                children: <Widget>[WText('c')],
              ),
            ],
          ),
        ),
      );

      expect(
        scopeCount(),
        0,
        reason: 'a scope that answers what the context already answers is '
            'an Element bought for nothing',
      );
      expect(find.text('a'), findsOneWidget);
      expect(find.text('c'), findsOneWidget);
    });

    testWidgets('a main-axis scrollable flex still emits its scope',
        (WidgetTester tester) async {
      // `overflow-y-auto` on a column makes the flex main-axis scrollable,
      // which is exactly the case `skipExpanded: true` exists to signal.
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            height: 200,
            child: WDiv(
              className: 'flex flex-col overflow-y-auto',
              children: <Widget>[WText('scrolling')],
            ),
          ),
        ),
      );

      expect(
        scopeCount(),
        greaterThanOrEqualTo(1),
        reason: 'true under an inherited false is a real change and must '
            'still be published',
      );
    });

    testWidgets(
        'a non-scrollable flex inside a scrollable one re-publishes '
        'false, so the ancestor true does not leak',
        (WidgetTester tester) async {
      // The case that makes elision conditional rather than unconditional.
      // The inner row does not scroll, so everything below it must read
      // `false` even though an ancestor published `true`.
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            height: 200,
            child: WDiv(
              className: 'flex flex-col overflow-y-auto',
              children: <Widget>[
                WDiv(
                  className: 'flex flex-row',
                  children: <Widget>[WText('inner')],
                ),
              ],
            ),
          ),
        ),
      );

      final BuildContext innerContext = tester.element(find.text('inner'));
      expect(
        WindFlexOverflowScope.maybeOf(innerContext)?.skipExpanded ?? false,
        isFalse,
        reason: 'the inner row is not scrollable; its subtree must not '
            'inherit the outer column true',
      );
    });
  });
}
