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
  setUp(() {
    WindParser.clearCache();
  });

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

    group('Documented form-state example', () {
      testWidgets(
        'an id-bound input with no onChange reaches an action that reads state',
        (tester) async {
          // This is the worked example printed in
          // doc/core-concepts/dynamic-rendering.md and demoed on the gallery's
          // Form State Management section: an input carrying only an `id`, and
          // a button whose action reads that id. It could not work while the
          // state write lived inside the parsed onChange callback, so the
          // greeting always read "Hello, Guest!".
          String? greeting;

          await tester.pumpWidget(
            wrapWithTheme(
              WDynamic(
                json: const {
                  'type': 'WDiv',
                  'props': {'className': 'flex flex-col gap-3'},
                  'children': [
                    {
                      'type': 'WInput',
                      'props': {
                        'id': 'username',
                        'placeholder': 'Type your name',
                      },
                    },
                    {
                      'type': 'WButton',
                      'props': {
                        'onTap': {'action': 'greet'},
                      },
                      'children': [
                        {
                          'type': 'WText',
                          'props': {'text': 'Greet me'},
                        },
                      ],
                    },
                  ],
                },
                actions: {
                  'greet': (args, state) {
                    final name = (state.get('username') as String?) ?? 'Guest';
                    greeting = 'Hello, $name!';
                  },
                },
              ),
            ),
          );

          await tester.enterText(find.byType(EditableText), 'Anilcan');
          await tester.pump();

          await tester.tap(find.text('Greet me'));
          await tester.pump();

          expect(greeting, 'Hello, Anilcan!');
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

    group('Reactive rebuilds', () {
      // THE REGRESSION the id binding opened. The WRITE half landed without the
      // READ half: `WDynamicState.set` notified nobody in the render path, so an
      // id-bound checkbox wrote `true` on its first tap and kept rendering
      // unchecked. The second tap then sent `!false` = `true` again, which `set`
      // drops as unchanged, so the box could never be unticked either. Before the
      // binding existed the same node rendered DISABLED, which at least did not
      // promise a toggle it could not deliver.
      //
      // WInput hid all of this by owning a TextEditingController.
      testWidgets(
        'an id-bound checkbox ticks on tap and unticks on the next one',
        (tester) async {
          final controller = WDynamicController();
          addTearDown(controller.dispose);

          await tester.pumpWidget(
            wrapWithTheme(
              WDynamic(
                json: const {
                  'type': 'WCheckbox',
                  'props': {'id': 'agree'},
                },
                controller: controller,
              ),
            ),
          );

          expect(
            tester.widget<WCheckbox>(find.byType(WCheckbox)).value,
            isFalse,
          );

          await tester.tap(find.byType(WCheckbox));
          await tester.pump();

          expect(controller.state.get('agree'), isTrue);
          expect(
            tester.widget<WCheckbox>(find.byType(WCheckbox)).value,
            isTrue,
          );

          await tester.tap(find.byType(WCheckbox));
          await tester.pump();

          expect(controller.state.get('agree'), isFalse);
          expect(
            tester.widget<WCheckbox>(find.byType(WCheckbox)).value,
            isFalse,
          );
        },
      );

      // The other direction: a host writing through the controller is the whole
      // point of exposing one, and it reached the state without reaching the
      // screen.
      testWidgets(
        'a write through the controller reaches the screen',
        (tester) async {
          final controller = WDynamicController();
          addTearDown(controller.dispose);

          await tester.pumpWidget(
            wrapWithTheme(
              WDynamic(
                json: const {
                  'type': 'WCheckbox',
                  'props': {'id': 'agree'},
                },
                controller: controller,
              ),
            ),
          );

          controller.setValue('agree', true);
          await tester.pump();

          expect(
            tester.widget<WCheckbox>(find.byType(WCheckbox)).value,
            isTrue,
          );
        },
      );

      // A borrowed state outlives the widget that read it, so the listener has to
      // come off on dispose. The `mounted` guard inside the callback would keep a
      // leaked listener from throwing, which is exactly why this asserts the
      // subscription itself rather than the absence of an exception.
      testWidgets(
        'the listener comes off a state the widget only borrowed',
        (tester) async {
          final state = _ObservableDynamicState();
          final controller = WDynamicController.fromState(state);
          addTearDown(state.dispose);

          await tester.pumpWidget(
            wrapWithTheme(
              WDynamic(
                json: const {
                  'type': 'WCheckbox',
                  'props': {'id': 'agree'},
                },
                controller: controller,
              ),
            ),
          );

          expect(state.isObserved, isTrue);

          await tester.pumpWidget(wrapWithTheme(const SizedBox.shrink()));

          expect(state.isObserved, isFalse);
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

/// A [WDynamicState] that reports whether anything is currently subscribed.
///
/// `ChangeNotifier.hasListeners` is protected, so reading it needs a subclass.
/// Without it the dispose test could only assert that nothing threw, which a
/// leaked listener would satisfy too because the callback guards on `mounted`.
class _ObservableDynamicState extends WDynamicState {
  bool get isObserved => hasListeners;
}
