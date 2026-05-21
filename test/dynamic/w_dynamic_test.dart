import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Helper to wrap widget in MaterialApp with WindTheme.
Widget wrapWithTheme(Widget child) {
  return MaterialApp(
    home: WindTheme(
      data: WindThemeData(),
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  group('WDynamic Widget Tests', () {
    group('Self-Owned State', () {
      testWidgets(
        'renders WText from JSON without external controller',
        (tester) async {
          await tester.pumpWidget(
            wrapWithTheme(
              const WDynamic(
                json: {
                  'type': 'WText',
                  'props': {'text': 'hi'},
                },
              ),
            ),
          );

          expect(find.text('hi'), findsOneWidget);
        },
      );
    });

    group('External Controller State', () {
      testWidgets(
        'uses controller state and does not reset pre-populated values',
        (tester) async {
          final controller = WDynamicController();
          addTearDown(controller.dispose);

          // 1. Set a value on the controller state before pumping.
          controller.state.set('key', 'value');

          await tester.pumpWidget(
            wrapWithTheme(
              WDynamic(
                json: const {
                  'type': 'WText',
                  'props': {'text': 'external'},
                },
                controller: controller,
              ),
            ),
          );

          // 2. Verify the controller's state was not replaced by a fresh one.
          expect(controller.state.get('key'), 'value');
        },
      );
    });

    group('Default Parameters', () {
      testWidgets(
        'renders without errors when no actions, builders, customIcons supplied',
        (tester) async {
          await tester.pumpWidget(
            wrapWithTheme(
              const WDynamic(
                json: {
                  'type': 'WText',
                  'props': {'text': 'foo'},
                },
              ),
            ),
          );

          expect(find.text('foo'), findsOneWidget);
        },
      );

      testWidgets(
        'denyWidgets defaults to empty — no whitelist errors for known types',
        (tester) async {
          await tester.pumpWidget(
            wrapWithTheme(
              const WDynamic(
                json: {
                  'type': 'WDiv',
                  'props': {'className': 'p-4'},
                  'children': [
                    {
                      'type': 'WText',
                      'props': {'text': 'nested'},
                    },
                  ],
                },
              ),
            ),
          );

          expect(find.text('nested'), findsOneWidget);
        },
      );
    });

    group('Depth Limiting', () {
      testWidgets(
        'shows MaxDepth error when nesting exceeds maxDepth',
        (tester) async {
          // 4-level deep structure with maxDepth: 2 forces depth exceeded.
          await tester.pumpWidget(
            wrapWithTheme(
              const WDynamic(
                maxDepth: 2,
                json: {
                  'type': 'WDiv',
                  'children': [
                    {
                      'type': 'WDiv',
                      'children': [
                        {
                          'type': 'WDiv',
                          'children': [
                            {
                              'type': 'WText',
                              'props': {'text': 'too deep'},
                            },
                          ],
                        },
                      ],
                    },
                  ],
                },
              ),
            ),
          );

          expect(find.text('Error: MaxDepth'), findsOneWidget);
        },
      );
    });

    group('Error Callback', () {
      testWidgets(
        'calls onError when a custom builder throws',
        (tester) async {
          await tester.pumpWidget(
            wrapWithTheme(
              WDynamic(
                json: const {
                  'type': 'BrokenWidget',
                  'props': {},
                },
                builders: {
                  'BrokenWidget': (props, children) {
                    throw Exception('builder exploded');
                  },
                },
                onError: (type, error) => Text('handled $type'),
              ),
            ),
          );

          expect(find.text('handled BrokenWidget'), findsOneWidget);
        },
      );
    });

    group('Unknown Widget Callback', () {
      testWidgets(
        'calls onUnknownWidget for an unregistered type',
        (tester) async {
          await tester.pumpWidget(
            wrapWithTheme(
              WDynamic(
                json: const {
                  'type': 'NonExistentWidget',
                  'props': {},
                },
                onUnknownWidget: (type, props) => Text('unknown $type'),
              ),
            ),
          );

          expect(find.text('unknown NonExistentWidget'), findsOneWidget);
        },
      );
    });

    group('Dispose Behaviour', () {
      testWidgets(
        'disposes owned state on unmount without errors',
        (tester) async {
          await tester.pumpWidget(
            wrapWithTheme(
              const WDynamic(
                json: {
                  'type': 'WText',
                  'props': {'text': 'disposable'},
                },
              ),
            ),
          );

          // Replace the widget tree to trigger dispose.
          await tester.pumpWidget(wrapWithTheme(const SizedBox.shrink()));

          // No exception = owned state was disposed cleanly.
          expect(find.byType(SizedBox), findsOneWidget);
        },
      );

      testWidgets(
        'does not dispose external controller state on unmount',
        (tester) async {
          final controller = WDynamicController();
          controller.state.set('persist', 'yes');

          await tester.pumpWidget(
            wrapWithTheme(
              WDynamic(
                json: const {
                  'type': 'WText',
                  'props': {'text': 'external dispose'},
                },
                controller: controller,
              ),
            ),
          );

          // Unmount the WDynamic widget.
          await tester.pumpWidget(wrapWithTheme(const SizedBox.shrink()));

          // Controller state must still be accessible after widget disposal.
          expect(controller.state.get('persist'), 'yes');

          controller.dispose();
        },
      );
    });
  });
}
