import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/dynamic/wind_action_handler.dart';
import 'package:fluttersdk_wind/src/dynamic/wind_dynamic_state.dart';

void main() {
  late WindDynamicState state;

  setUp(() {
    state = WindDynamicState();
  });

  tearDown(() {
    state.dispose();
  });

  group('WindActionHandler', () {
    test('dispatch calls simple action with args', () {
      Map<String, dynamic>? receivedArgs;
      final handler = WindActionHandler(
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
      WindDynamicState? receivedState;
      final handler = WindActionHandler(
        actions: {
          'test': (Map<String, dynamic> args, WindDynamicState s) {
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
      final handler = WindActionHandler(actions: {}, state: state);
      // Should not throw
      handler.dispatch('unknown', {});
    });

    test('parseAction returns VoidCallback from JSON', () {
      bool called = false;
      final handler = WindActionHandler(
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
      final handler = WindActionHandler(actions: {}, state: state);

      expect(handler.parseAction(null), isNull);
      expect(handler.parseAction('string'), isNull);
      expect(handler.parseAction({}), isNull);
      expect(handler.parseAction({'action': 123}), isNull);
    });

    test('parseValueAction returns typed callback', () {
      Map<String, dynamic>? receivedArgs;
      final handler = WindActionHandler(
        actions: {
          'inputChanged': (Map<String, dynamic> args) => receivedArgs = args,
        },
        state: state,
      );

      final callback = handler.parseValueAction<String>(
        {'action': 'inputChanged', 'args': {'field': 'email'}},
        stateId: 'email',
      );

      expect(callback, isNotNull);
      callback!('new@email.com');

      expect(receivedArgs!['field'], 'email');
      expect(receivedArgs!['_value'], 'new@email.com');
      expect(state.get('email'), 'new@email.com');
    });

    test('parseValueAction without stateId does not update state', () {
      final handler = WindActionHandler(
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
