import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/dynamic/w_action_handler.dart';
import 'package:fluttersdk_wind/src/dynamic/w_dynamic_state.dart';

void main() {
  late WDynamicState state;

  setUp(() {
    state = WDynamicState();
  });

  tearDown(() {
    state.dispose();
  });

  group('WActionHandler', () {
    test('dispatch calls simple action with args', () {
      Map<String, dynamic>? receivedArgs;
      final handler = WActionHandler(
        actions: {
          'test': (Map<String, dynamic> args) => receivedArgs = args,
        },
        state: state,
      );

      handler.dispatch('test', {'key': 'value'});
      expect(receivedArgs, {'key': 'value'});
    });

    test('dispatch calls stateful action with args and state', () {
      Map<String, dynamic>? receivedArgs;
      WDynamicState? receivedState;
      final handler = WActionHandler(
        actions: {
          'test': (Map<String, dynamic> args, WDynamicState s) {
            receivedArgs = args;
            receivedState = s;
          },
        },
        state: state,
      );

      state.set('email', 'test@example.com');
      handler.dispatch('test', {'key': 'value'});

      expect(receivedArgs, {'key': 'value'});
      expect(receivedState, same(state));
      expect(receivedState!.get('email'), 'test@example.com');
    });

    test('dispatch ignores unknown action silently', () {
      final handler = WActionHandler(actions: {}, state: state);
      // Should not throw
      handler.dispatch('unknown', {});
    });

    test('parseAction returns VoidCallback from JSON', () {
      bool called = false;
      final handler = WActionHandler(
        actions: {
          'doSomething': (Map<String, dynamic> args) => called = true,
        },
        state: state,
      );

      final callback = handler.parseAction({
        'action': 'doSomething',
        'args': {'id': 123},
      });

      expect(callback, isNotNull);
      callback!();
      expect(called, isTrue);
    });

    test('parseAction returns null for invalid input', () {
      final handler = WActionHandler(actions: {}, state: state);

      expect(handler.parseAction(null), isNull);
      expect(handler.parseAction('string'), isNull);
      expect(handler.parseAction({}), isNull);
      expect(handler.parseAction({'action': 123}), isNull);
    });

    test('parseValueAction returns typed callback', () {
      Map<String, dynamic>? receivedArgs;
      final handler = WActionHandler(
        actions: {
          'inputChanged': (Map<String, dynamic> args) => receivedArgs = args,
        },
        state: state,
      );

      final callback = handler.parseValueAction<String>(
        {
          'action': 'inputChanged',
          'args': {'field': 'email'}
        },
        stateId: 'email',
      );

      expect(callback, isNotNull);
      callback!('new@email.com');

      expect(receivedArgs!['field'], 'email');
      expect(receivedArgs!['_value'], 'new@email.com');
      expect(state.get('email'), 'new@email.com');
    });

    test('parseValueAction without stateId does not update state', () {
      final handler = WActionHandler(
        actions: {
          'test': (Map<String, dynamic> args) {},
        },
        state: state,
      );

      final callback = handler.parseValueAction<String>(
        {'action': 'test'},
      );

      callback!('value');
      expect(state.has('test'), isFalse);
    });
  });
}
