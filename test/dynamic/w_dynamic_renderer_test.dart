import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';
import 'package:fluttersdk_wind/src/dynamic/w_dynamic_renderer.dart';

/// Helper to wrap widget in MaterialApp with WindTheme
Widget wrapWithTheme(Widget child) {
  return MaterialApp(
    home: WindTheme(
      data: WindThemeData(),
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  group('WDynamicRenderer Tests', () {
    late WDynamicState state;
    late WActionHandler actionHandler;
    late WDynamicConfig config;
    late WDynamicRenderer renderer;

    setUp(() {
      WindParser.clearCache();
      state = WDynamicState();
      actionHandler = WActionHandler(actions: {}, state: state);
      config = const WDynamicConfig();
      renderer = WDynamicRenderer(
        config: config,
        actionHandler: actionHandler,
        state: state,
      );
    });

    tearDown(() {
      state.dispose();
    });

    group('Basic Rendering', () {
      testWidgets('renders WDiv with className from JSON', (tester) async {
        final json = {
          'type': 'WDiv',
          'props': {
            'className': 'flex gap-4 p-6 bg-blue-500',
          },
        };

        await tester.pumpWidget(wrapWithTheme(renderer.build(json)));

        expect(find.byType(WDiv), findsOneWidget);
      });

      testWidgets('renders WText with text prop', (tester) async {
        final json = {
          'type': 'WText',
          'props': {
            'text': 'Hello World',
            'className': 'text-xl font-bold',
          },
        };

        await tester.pumpWidget(wrapWithTheme(renderer.build(json)));

        expect(find.byType(WText), findsOneWidget);
        expect(find.text('Hello World'), findsOneWidget);
      });

      testWidgets('renders nested children (WDiv > WText)', (tester) async {
        final json = {
          'type': 'WDiv',
          'props': {'className': 'p-4'},
          'children': [
            {
              'type': 'WText',
              'props': {'text': 'Child 1'},
            },
            {
              'type': 'WText',
              'props': {'text': 'Child 2'},
            },
          ],
        };

        await tester.pumpWidget(wrapWithTheme(renderer.build(json)));

        expect(find.byType(WDiv), findsOneWidget);
        expect(find.byType(WText), findsNWidgets(2));
        expect(find.text('Child 1'), findsOneWidget);
        expect(find.text('Child 2'), findsOneWidget);
      });

      testWidgets('returns SizedBox.shrink for null JSON', (tester) async {
        await tester.pumpWidget(wrapWithTheme(renderer.build(null)));

        expect(find.byType(SizedBox), findsOneWidget);
      });

      testWidgets('returns SizedBox.shrink for empty JSON', (tester) async {
        await tester.pumpWidget(wrapWithTheme(renderer.build({})));

        expect(find.byType(SizedBox), findsOneWidget);
      });
    });

    group('Security - Whitelist', () {
      testWidgets('rejects denied widget types', (tester) async {
        final customConfig = const WDynamicConfig(
          denyWidgets: {'WButton'},
        );
        final customRenderer = WDynamicRenderer(
          config: customConfig,
          actionHandler: actionHandler,
          state: state,
        );

        final json = {
          'type': 'WButton',
          'props': {'className': 'bg-blue-500'},
        };

        await tester.pumpWidget(wrapWithTheme(customRenderer.build(json)));

        // Should render error widget (Container with red border)
        expect(find.byType(WButton), findsNothing);
        expect(find.byType(Container), findsWidgets);
        expect(find.text('Error: Denied'), findsOneWidget);
      });

      testWidgets('calls onUnknownWidget for denied types', (tester) async {
        bool onUnknownCalled = false;
        final customConfig = WDynamicConfig(
          denyWidgets: const {'WButton'},
          onUnknownWidget: (type, props) {
            onUnknownCalled = true;
            return const Text('Custom Unknown Widget');
          },
        );
        final customRenderer = WDynamicRenderer(
          config: customConfig,
          actionHandler: actionHandler,
          state: state,
        );

        final json = {
          'type': 'WButton',
          'props': {},
        };

        await tester.pumpWidget(wrapWithTheme(customRenderer.build(json)));

        expect(onUnknownCalled, isTrue);
        expect(find.text('Custom Unknown Widget'), findsOneWidget);
      });
    });

    group('Depth Limiting', () {
      testWidgets('enforces maxDepth limit', (tester) async {
        final customConfig = const WDynamicConfig(maxDepth: 2);
        final customRenderer = WDynamicRenderer(
          config: customConfig,
          actionHandler: actionHandler,
          state: state,
        );

        // Create deeply nested structure (depth > 2)
        final json = {
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
                      'props': {'text': 'Too deep'},
                    },
                  ],
                },
              ],
            },
          ],
        };

        await tester.pumpWidget(wrapWithTheme(customRenderer.build(json)));

        // Should render error widget for depth exceeded
        expect(find.text('Error: MaxDepth'), findsOneWidget);
      });
    });

    group('Custom Builders', () {
      testWidgets('custom builder is used for custom types', (tester) async {
        final customConfig = WDynamicConfig(
          builders: {
            'CustomWidget': (props, children) {
              return Text('Custom: ${props['name']}');
            },
          },
        );
        final customRenderer = WDynamicRenderer(
          config: customConfig,
          actionHandler: actionHandler,
          state: state,
        );

        final json = {
          'type': 'CustomWidget',
          'props': {'name': 'TestWidget'},
        };

        await tester.pumpWidget(wrapWithTheme(customRenderer.build(json)));

        expect(find.text('Custom: TestWidget'), findsOneWidget);
      });

      testWidgets('custom builder error is caught', (tester) async {
        final customConfig = WDynamicConfig(
          builders: {
            'ErrorWidget': (props, children) {
              throw Exception('Builder error');
            },
          },
        );
        final customRenderer = WDynamicRenderer(
          config: customConfig,
          actionHandler: actionHandler,
          state: state,
        );

        final json = {
          'type': 'ErrorWidget',
          'props': {},
        };

        await tester.pumpWidget(wrapWithTheme(customRenderer.build(json)));

        // Should render error widget
        expect(find.text('Error: ErrorWidget'), findsOneWidget);
      });
    });

    group('Actions', () {
      testWidgets('onTap action fires registered handler', (tester) async {
        bool actionFired = false;
        Map<String, dynamic>? receivedArgs;

        final customActionHandler = WActionHandler(
          actions: {
            'testAction': (args) {
              actionFired = true;
              receivedArgs = args;
            },
          },
          state: state,
        );

        final customRenderer = WDynamicRenderer(
          config: config,
          actionHandler: customActionHandler,
          state: state,
        );

        final json = {
          'type': 'WButton',
          'props': {
            'onTap': {
              'action': 'testAction',
              'args': {'buttonId': 'submit'},
            },
          },
          'children': [
            {
              'type': 'WText',
              'props': {'text': 'Click Me'},
            },
          ],
        };

        await tester.pumpWidget(wrapWithTheme(customRenderer.build(json)));

        // Tap the button
        await tester.tap(find.byType(WButton));
        await tester.pump();

        expect(actionFired, isTrue);
        expect(receivedArgs, {'buttonId': 'submit'});
      });
    });

    group('State Management', () {
      testWidgets('WInput onChange updates state', (tester) async {
        String? capturedValue;

        final customActionHandler = WActionHandler(
          actions: {
            'inputChanged': (args, state) {
              capturedValue = args['_value'];
            },
          },
          state: state,
        );

        final customRenderer = WDynamicRenderer(
          config: config,
          actionHandler: customActionHandler,
          state: state,
        );

        final json = {
          'type': 'WInput',
          'props': {
            'id': 'email',
            'value': '',
            'placeholder': 'Enter email',
            'onChange': {
              'action': 'inputChanged',
              'args': {},
            },
          },
        };

        await tester.pumpWidget(wrapWithTheme(customRenderer.build(json)));

        // Enter text
        await tester.enterText(find.byType(EditableText), 'test@example.com');
        await tester.pump();

        // Check state was updated
        expect(state.get('email'), 'test@example.com');
        expect(capturedValue, 'test@example.com');
      });

      testWidgets('WCheckbox onChange updates state', (tester) async {
        bool? capturedValue;

        final customActionHandler = WActionHandler(
          actions: {
            'checkboxChanged': (args, state) {
              capturedValue = args['_value'];
            },
          },
          state: state,
        );

        final customRenderer = WDynamicRenderer(
          config: config,
          actionHandler: customActionHandler,
          state: state,
        );

        final json = {
          'type': 'WCheckbox',
          'props': {
            'id': 'agree',
            'checked': false,
            'onChange': {
              'action': 'checkboxChanged',
              'args': {},
            },
          },
        };

        await tester.pumpWidget(wrapWithTheme(customRenderer.build(json)));

        // Tap the checkbox
        await tester.tap(find.byType(WCheckbox));
        await tester.pump();

        // Check state was updated
        expect(state.get('agree'), true);
        expect(capturedValue, true);
      });

      testWidgets('reads initial value from state', (tester) async {
        // Pre-populate state
        state.set('username', 'john_doe');

        final json = {
          'type': 'WInput',
          'props': {
            'id': 'username',
            'value': 'fallback_value',
          },
        };

        await tester.pumpWidget(wrapWithTheme(renderer.build(json)));

        // Should use state value, not fallback
        expect(find.text('john_doe'), findsOneWidget);
      });
    });

    group('Flutter Core Widgets', () {
      testWidgets('renders Column with children', (tester) async {
        final json = {
          'type': 'Column',
          'props': {
            'mainAxisAlignment': 'center',
          },
          'children': [
            {
              'type': 'WText',
              'props': {'text': 'Item 1'}
            },
            {
              'type': 'WText',
              'props': {'text': 'Item 2'}
            },
          ],
        };

        await tester.pumpWidget(wrapWithTheme(renderer.build(json)));

        expect(find.byType(Column), findsOneWidget);
        expect(find.text('Item 1'), findsOneWidget);
        expect(find.text('Item 2'), findsOneWidget);
      });

      testWidgets('renders Row with children', (tester) async {
        final json = {
          'type': 'Row',
          'props': {
            'mainAxisAlignment': 'spaceBetween',
          },
          'children': [
            {
              'type': 'WText',
              'props': {'text': 'Left'}
            },
            {
              'type': 'WText',
              'props': {'text': 'Right'}
            },
          ],
        };

        await tester.pumpWidget(wrapWithTheme(renderer.build(json)));

        expect(find.byType(Row), findsOneWidget);
        expect(find.text('Left'), findsOneWidget);
        expect(find.text('Right'), findsOneWidget);
      });

      testWidgets('renders SizedBox with dimensions', (tester) async {
        final json = {
          'type': 'SizedBox',
          'props': {
            'width': 100,
            'height': 50,
          },
          'children': [
            {
              'type': 'WText',
              'props': {'text': 'Content'}
            },
          ],
        };

        await tester.pumpWidget(wrapWithTheme(renderer.build(json)));

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
        expect(sizedBox.width, 100.0);
        expect(sizedBox.height, 50.0);
      });

      testWidgets('renders Expanded widget', (tester) async {
        final json = {
          'type': 'Row',
          'children': [
            {
              'type': 'Expanded',
              'props': {'flex': 2},
              'children': [
                {
                  'type': 'WText',
                  'props': {'text': 'Flex 2'}
                },
              ],
            },
            {
              'type': 'Expanded',
              'props': {'flex': 1},
              'children': [
                {
                  'type': 'WText',
                  'props': {'text': 'Flex 1'}
                },
              ],
            },
          ],
        };

        await tester.pumpWidget(wrapWithTheme(renderer.build(json)));

        expect(find.byType(Expanded), findsNWidgets(2));
      });
    });

    group('Error Handling', () {
      testWidgets('calls onError when build throws', (tester) async {
        bool onErrorCalled = false;
        final customConfig = WDynamicConfig(
          onError: (type, error) {
            onErrorCalled = true;
            return Text('Error in $type');
          },
          builders: {
            'BrokenWidget': (props, children) {
              throw Exception('Broken');
            },
          },
        );

        final customRenderer = WDynamicRenderer(
          config: customConfig,
          actionHandler: actionHandler,
          state: state,
        );

        final json = {
          'type': 'BrokenWidget',
          'props': {},
        };

        await tester.pumpWidget(wrapWithTheme(customRenderer.build(json)));

        expect(onErrorCalled, isTrue);
        expect(find.text('Error in BrokenWidget'), findsOneWidget);
      });

      testWidgets('degrades gracefully when type is not a string',
          (tester) async {
        // Untrusted JSON must never throw past build(); a non-string type
        // routes through the whitelist and emits the denied error widget.
        await tester.pumpWidget(
          wrapWithTheme(renderer.build({'type': 123})),
        );

        expect(tester.takeException(), isNull);
        expect(find.textContaining('Error: Denied'), findsOneWidget);
      });

      testWidgets('degrades gracefully when children is not a list',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            renderer.build({'type': 'WDiv', 'children': 'oops'}),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.byType(WDiv), findsOneWidget);
      });
    });

    // ============================================================
    // Coverage matrix: per-widget-type dispatch via WDynamic (public API).
    // Each test asserts that the JSON `type` token routes to the expected
    // Flutter widget. Behavioral, not structural — props are minimal.
    // ============================================================

    group('Widget type dispatch', () {
      testWidgets('dispatches WDiv', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WDynamic(json: {'type': 'WDiv'})),
        );

        expect(find.byType(WDiv), findsOneWidget);
      });

      testWidgets('dispatches WText', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'WText',
                'props': {'text': 'hello'},
              },
            ),
          ),
        );

        expect(find.byType(WText), findsOneWidget);
        expect(find.text('hello'), findsOneWidget);
      });

      testWidgets('dispatches WButton', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'WButton',
                'children': [
                  {
                    'type': 'WText',
                    'props': {'text': 'tap'},
                  },
                ],
              },
            ),
          ),
        );

        expect(find.byType(WButton), findsOneWidget);
      });

      testWidgets('dispatches WImage with non-empty src', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'WImage',
                'props': {'src': 'asset://test.png'},
              },
            ),
          ),
        );

        // WImage uses Image.asset which fails to resolve in tests because no
        // asset is bundled; the widget itself still lives in the tree.
        // Drain any async image-loading exceptions before asserting.
        await tester.pump();
        tester.takeException();

        expect(find.byType(WImage), findsOneWidget);
      });

      testWidgets('dispatches WImage to SizedBox.shrink for empty src',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'WImage',
                'props': {'src': ''},
              },
            ),
          ),
        );

        // Empty src returns SizedBox.shrink, not WImage.
        expect(find.byType(WImage), findsNothing);
        expect(find.byType(SizedBox), findsWidgets);
      });

      testWidgets('dispatches WIcon with named icon', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'WIcon',
                'props': {'icon': 'home'},
              },
            ),
          ),
        );

        expect(find.byType(WIcon), findsOneWidget);
      });

      testWidgets('dispatches WAnchor with single child', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'WAnchor',
                'children': [
                  {
                    'type': 'WText',
                    'props': {'text': 'link'},
                  },
                ],
              },
            ),
          ),
        );

        expect(find.byType(WAnchor), findsOneWidget);
        expect(find.text('link'), findsOneWidget);
      });

      testWidgets('dispatches WAnchor with no children', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(json: {'type': 'WAnchor'}),
          ),
        );

        expect(find.byType(WAnchor), findsOneWidget);
      });

      testWidgets('dispatches WAnchor with multiple children wraps in WDiv',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'WAnchor',
                'children': [
                  {
                    'type': 'WText',
                    'props': {'text': 'a'},
                  },
                  {
                    'type': 'WText',
                    'props': {'text': 'b'},
                  },
                ],
              },
            ),
          ),
        );

        expect(find.byType(WAnchor), findsOneWidget);
        expect(find.text('a'), findsOneWidget);
        expect(find.text('b'), findsOneWidget);
      });

      testWidgets('dispatches WInput', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'WInput',
                'props': {'placeholder': 'type here'},
              },
            ),
          ),
        );

        expect(find.byType(WInput), findsOneWidget);
      });

      testWidgets('dispatches WInput with each InputType variant',
          (tester) async {
        for (final variant in const [
          'email',
          'password',
          'number',
          'multiline',
          'textarea',
          'unknown_falls_through',
        ]) {
          await tester.pumpWidget(
            wrapWithTheme(
              WDynamic(
                json: {
                  'type': 'WInput',
                  'props': {'type': variant},
                },
              ),
            ),
          );

          expect(find.byType(WInput), findsOneWidget,
              reason: 'WInput type=$variant should still render');
        }
      });

      testWidgets('dispatches WCheckbox', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'WCheckbox',
                'props': {'checked': true},
              },
            ),
          ),
        );

        expect(find.byType(WCheckbox), findsOneWidget);
      });

      testWidgets('dispatches WSvg from inline svgContent', (tester) async {
        const svg =
            '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 10">'
            '<rect width="10" height="10" fill="red"/></svg>';
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'WSvg',
                'props': {'svgContent': svg},
              },
            ),
          ),
        );

        expect(find.byType(WSvg), findsOneWidget);
      });

      testWidgets('dispatches WSvg from asset path', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'WSvg',
                'props': {'asset': 'assets/icon.svg'},
              },
            ),
          ),
        );

        expect(find.byType(WSvg), findsOneWidget);
      });

      testWidgets('dispatches WSvg fallback to WIcon when no source',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(json: {'type': 'WSvg'}),
          ),
        );

        // Fallback is a WIcon, not a WSvg.
        expect(find.byType(WSvg), findsNothing);
        expect(find.byType(WIcon), findsOneWidget);
      });

      testWidgets('dispatches WSelect with map options', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'WSelect',
                'props': {
                  'placeholder': 'choose',
                  'options': [
                    {'value': 'a', 'label': 'Alpha'},
                    {'value': 'b', 'label': 'Bravo'},
                  ],
                },
              },
            ),
          ),
        );

        // WSelect is generic (WSelect<T>); match on the runtime base via
        // predicate so we are not coupled to the inferred type argument.
        expect(find.byWidgetPredicate((w) => w is WSelect), findsOneWidget);
      });

      testWidgets(
          'dispatches WSelect with simple string options and catches '
          'downstream type error', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'WSelect',
                'props': {
                  'options': ['x', 'y', 'z'],
                },
              },
            ),
          ),
        );

        // String options infer `SelectOption<String>` → `WSelect<String>`, but
        // `value: null` violates the inferred non-nullable type during state
        // init. The renderer's _buildByType catch path swallows it and emits
        // a WSelect-tagged error widget — covers the catch-and-handle path.
        expect(find.text('Error: WSelect'), findsOneWidget);
      });

      testWidgets('dispatches WPopover with trigger + content', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'WPopover',
                'children': [
                  {
                    'type': 'WText',
                    'props': {'text': 'trigger'},
                  },
                  {
                    'type': 'WText',
                    'props': {'text': 'content'},
                  },
                ],
              },
            ),
          ),
        );

        expect(find.byType(WPopover), findsOneWidget);
        // Only trigger is visible by default; content is built on open.
        expect(find.text('trigger'), findsOneWidget);
      });

      testWidgets('dispatches WDatePicker with ISO initial value',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'WDatePicker',
                'props': {'value': '2026-01-15'},
              },
            ),
          ),
        );

        expect(find.byType(WDatePicker), findsOneWidget);
      });

      testWidgets('dispatches WSpacer', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'Row',
                'children': [
                  {'type': 'WSpacer'},
                ],
              },
            ),
          ),
        );

        expect(find.byType(WSpacer), findsOneWidget);
      });

      testWidgets('dispatches Column with alignment options', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'Column',
                'props': {
                  'mainAxisSize': 'max',
                  'mainAxisAlignment': 'space-between',
                  'crossAxisAlignment': 'stretch',
                },
              },
            ),
          ),
        );

        final column = tester.widget<Column>(find.byType(Column));
        expect(column.mainAxisSize, MainAxisSize.max);
        expect(column.mainAxisAlignment, MainAxisAlignment.spaceBetween);
        expect(column.crossAxisAlignment, CrossAxisAlignment.stretch);
      });

      testWidgets('dispatches Row with alignment options', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'Row',
                'props': {
                  'mainAxisAlignment': 'end',
                  'crossAxisAlignment': 'start',
                },
                'children': [
                  {
                    'type': 'WText',
                    'props': {'text': 'cell'},
                  },
                ],
              },
            ),
          ),
        );

        final row = tester.widget<Row>(find.byType(Row));
        expect(row.mainAxisAlignment, MainAxisAlignment.end);
        expect(row.crossAxisAlignment, CrossAxisAlignment.start);
      });

      testWidgets('dispatches Center', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'Center',
                'children': [
                  {
                    'type': 'WText',
                    'props': {'text': 'centered'},
                  },
                ],
              },
            ),
          ),
        );

        expect(find.byType(Center), findsOneWidget);
        expect(find.text('centered'), findsOneWidget);
      });

      testWidgets('dispatches SizedBox', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'SizedBox',
                'props': {'width': 120, 'height': 30},
              },
            ),
          ),
        );

        expect(find.byType(SizedBox), findsWidgets);
      });

      testWidgets('dispatches Expanded inside Row', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'Row',
                'children': [
                  {
                    'type': 'Expanded',
                    'props': {'flex': 3},
                  },
                ],
              },
            ),
          ),
        );

        final expanded = tester.widget<Expanded>(find.byType(Expanded));
        expect(expanded.flex, 3);
      });

      testWidgets('dispatches Container to SizedBox', (tester) async {
        // Note: _buildContainer in the renderer returns a SizedBox, not a real
        // Container — verify the dispatch routes there without crashing.
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'Container',
                'props': {'width': 50, 'height': 50},
              },
            ),
          ),
        );

        expect(find.byType(SizedBox), findsWidgets);
      });

      testWidgets('dispatches Wrap with spacing and alignment', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'Wrap',
                'props': {
                  'spacing': 8,
                  'runSpacing': 4,
                  'alignment': 'space-around',
                },
                'children': [
                  {
                    'type': 'WText',
                    'props': {'text': 'item'},
                  },
                ],
              },
            ),
          ),
        );

        final wrap = tester.widget<Wrap>(find.byType(Wrap));
        expect(wrap.spacing, 8.0);
        expect(wrap.runSpacing, 4.0);
        expect(wrap.alignment, WrapAlignment.spaceAround);
      });

      testWidgets('dispatches Stack with fit and alignment', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'Stack',
                'props': {
                  'alignment': 'top-right',
                  'fit': 'expand',
                },
                'children': [
                  {
                    'type': 'WText',
                    'props': {'text': 'layer'},
                  },
                ],
              },
            ),
          ),
        );

        // Scaffold also uses Stack internally — scope to the WDynamic subtree.
        final stack = tester.widget<Stack>(
          find.descendant(
            of: find.byType(WDynamic),
            matching: find.byType(Stack),
          ),
        );
        expect(stack.alignment, Alignment.topRight);
        expect(stack.fit, StackFit.expand);
      });

      testWidgets('dispatches Positioned inside Stack', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'Stack',
                'children': [
                  {
                    'type': 'Positioned',
                    'props': {
                      'top': 4,
                      'left': 8,
                      'width': 20,
                      'height': 20,
                    },
                  },
                ],
              },
            ),
          ),
        );

        expect(find.byType(Positioned), findsOneWidget);
      });

      testWidgets('dispatches Padding with uniform padding', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'Padding',
                'props': {'padding': 12},
                'children': [
                  {
                    'type': 'WText',
                    'props': {'text': 'padded'},
                  },
                ],
              },
            ),
          ),
        );

        final padding = tester.widget<Padding>(find.byType(Padding).first);
        expect(padding.padding, const EdgeInsets.all(12));
      });

      testWidgets('dispatches Padding with per-side padding', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'Padding',
                'props': {'top': 4, 'left': 8, 'right': 8, 'bottom': 16},
              },
            ),
          ),
        );

        final padding = tester.widget<Padding>(find.byType(Padding).first);
        expect(
          padding.padding,
          const EdgeInsets.only(top: 4, left: 8, right: 8, bottom: 16),
        );
      });

      testWidgets('dispatches Align', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'Align',
                'props': {
                  'alignment': 'bottom-left',
                  'widthFactor': 1.5,
                  'heightFactor': 0.5,
                },
              },
            ),
          ),
        );

        final align = tester.widget<Align>(find.byType(Align));
        expect(align.alignment, Alignment.bottomLeft);
        expect(align.widthFactor, 1.5);
        expect(align.heightFactor, 0.5);
      });

      testWidgets('dispatches Opacity', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'Opacity',
                'props': {'opacity': 0.25},
              },
            ),
          ),
        );

        final opacity = tester.widget<Opacity>(find.byType(Opacity));
        expect(opacity.opacity, 0.25);
      });

      testWidgets('dispatches AspectRatio', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'AspectRatio',
                'props': {'aspectRatio': 2.0},
              },
            ),
          ),
        );

        final aspect = tester.widget<AspectRatio>(find.byType(AspectRatio));
        expect(aspect.aspectRatio, 2.0);
      });

      testWidgets('dispatches FittedBox', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'FittedBox',
                'props': {'fit': 'cover', 'alignment': 'center-right'},
                'children': [
                  {
                    'type': 'WText',
                    'props': {'text': 'fit'},
                  },
                ],
              },
            ),
          ),
        );

        final fitted = tester.widget<FittedBox>(find.byType(FittedBox));
        expect(fitted.fit, BoxFit.cover);
        expect(fitted.alignment, Alignment.centerRight);
      });

      testWidgets('dispatches ClipRRect', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'ClipRRect',
                'props': {'borderRadius': 16},
              },
            ),
          ),
        );

        final clip = tester.widget<ClipRRect>(find.byType(ClipRRect));
        expect(clip.borderRadius, BorderRadius.circular(16));
      });

      testWidgets('dispatches Spacer inside Row', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'Row',
                'children': [
                  {
                    'type': 'Spacer',
                    'props': {'flex': 2},
                  },
                ],
              },
            ),
          ),
        );

        final spacer = tester.widget<Spacer>(find.byType(Spacer));
        expect(spacer.flex, 2);
      });
    });

    group('Security and error paths', () {
      testWidgets('denyWidgets blocks default-whitelisted type via WDynamic',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'Container',
                'props': {'width': 10, 'height': 10},
              },
              denyWidgets: {'Container'},
            ),
          ),
        );

        // Error widget rendered with the "Denied" label.
        expect(find.text('Error: Denied'), findsOneWidget);
      });

      testWidgets('custom builder takes precedence over default type',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WDynamic(
              json: const {
                'type': 'CustomCard',
                'children': [
                  {
                    'type': 'WText',
                    'props': {'text': 'inside card'},
                  },
                ],
              },
              builders: {
                'CustomCard': (props, children) {
                  return Card(child: Column(children: children));
                },
              },
            ),
          ),
        );

        expect(find.byType(Card), findsOneWidget);
        expect(find.text('inside card'), findsOneWidget);
      });

      testWidgets('maxDepth ceiling renders MaxDepth error widget',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDynamic(
              json: {
                'type': 'WDiv',
                'children': [
                  {
                    'type': 'WDiv',
                    'children': [
                      {
                        'type': 'WDiv',
                        'children': [
                          {'type': 'WDiv'},
                        ],
                      },
                    ],
                  },
                ],
              },
              maxDepth: 2,
            ),
          ),
        );

        expect(find.text('Error: MaxDepth'), findsOneWidget);
        expect(find.text('Recursion depth exceeded 2'), findsOneWidget);
      });

      testWidgets('onError callback receives type when builder throws',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WDynamic(
              json: const {
                'type': 'Broken',
                'props': {},
              },
              builders: {
                'Broken': (props, children) {
                  throw StateError('boom');
                },
              },
              onError: (type, error) => Text('handled $type'),
            ),
          ),
        );

        expect(find.text('handled Broken'), findsOneWidget);
      });

      testWidgets('onUnknownWidget callback receives unknown type and props',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WDynamic(
              json: const {
                'type': 'Bogus',
                'props': {'label': 'whatever'},
              },
              onUnknownWidget: (type, props) {
                return Text('unknown $type:${props['label']}');
              },
            ),
          ),
        );

        expect(find.text('unknown Bogus:whatever'), findsOneWidget);
      });
    });

    group('Value action and state binding', () {
      testWidgets('WInput with id pushes entered text into state',
          (tester) async {
        late WDynamicState capturedState;
        late Map<String, dynamic> capturedArgs;

        await tester.pumpWidget(
          wrapWithTheme(
            WDynamic(
              json: const {
                'type': 'WInput',
                'props': {
                  'id': 'name',
                  'onChange': {
                    'action': 'capture',
                    'args': {},
                  },
                },
              },
              actions: {
                'capture': (Map<String, dynamic> args, WDynamicState s) {
                  capturedArgs = args;
                  capturedState = s;
                },
              },
            ),
          ),
        );

        await tester.enterText(find.byType(EditableText), 'Anilcan');
        await tester.pump();

        expect(capturedState.get('name'), 'Anilcan');
        expect(capturedArgs['_value'], 'Anilcan');
      });

      testWidgets('WCheckbox with id flips state to true on tap',
          (tester) async {
        late WDynamicState capturedState;
        late Map<String, dynamic> capturedArgs;

        await tester.pumpWidget(
          wrapWithTheme(
            WDynamic(
              json: const {
                'type': 'WCheckbox',
                'props': {
                  'id': 'agree',
                  'onChange': {
                    'action': 'capture',
                    'args': {},
                  },
                },
              },
              actions: {
                'capture': (Map<String, dynamic> args, WDynamicState s) {
                  capturedArgs = args;
                  capturedState = s;
                },
              },
            ),
          ),
        );

        await tester.tap(find.byType(WCheckbox));
        await tester.pump();

        expect(capturedState.get('agree'), true);
        expect(capturedArgs['_value'], true);
      });

      testWidgets('value action merges args + _value injection',
          (tester) async {
        Map<String, dynamic>? captured;

        await tester.pumpWidget(
          wrapWithTheme(
            WDynamic(
              json: const {
                'type': 'WInput',
                'props': {
                  'id': 'email',
                  'onChange': {
                    'action': 'capture',
                    'args': {'field': 'email', 'origin': 'form'},
                  },
                },
              },
              actions: {
                'capture': (Map<String, dynamic> args, WDynamicState s) {
                  captured = args;
                },
              },
            ),
          ),
        );

        await tester.enterText(find.byType(EditableText), 'a@b.co');
        await tester.pump();

        expect(captured, isNotNull);
        expect(captured!['field'], 'email');
        expect(captured!['origin'], 'form');
        expect(captured!['_value'], 'a@b.co');
      });
    });
  });
}
