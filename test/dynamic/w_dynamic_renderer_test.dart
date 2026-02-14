import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

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
        await tester.enterText(find.byType(TextField), 'test@example.com');
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
    });
  });
}
