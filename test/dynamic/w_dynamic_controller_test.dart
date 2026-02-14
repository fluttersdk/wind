import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/dynamic/wind_dynamic_controller.dart';
import 'package:fluttersdk_wind/src/dynamic/wind_dynamic_state.dart';

void main() {
  group('WindDynamicController', () {
    test('creates own state when constructed without arguments', () {
      final controller = WindDynamicController();
      expect(controller.state, isNotNull);
      controller.dispose();
    });

    test('getValue and setValue work through controller', () {
      final controller = WindDynamicController();

      controller.setValue('email', 'test@example.com');
      expect(controller.getValue('email'), 'test@example.com');

      controller.dispose();
    });

    test('getAll returns all values', () {
      final controller = WindDynamicController();

      controller.setValue('a', 1);
      controller.setValue('b', 2);
      expect(controller.getAll(), {'a': 1, 'b': 2});

      controller.dispose();
    });

    test('reset clears all values', () {
      final controller = WindDynamicController();

      controller.setValue('a', 1);
      controller.reset();
      expect(controller.getAll(), isEmpty);

      controller.dispose();
    });

    test('addListener fires on value change', () {
      final controller = WindDynamicController();

      dynamic lastValue;
      final dispose = controller.addListener('email', (v) => lastValue = v);

      controller.setValue('email', 'new@email.com');
      expect(lastValue, 'new@email.com');

      dispose();
      controller.dispose();
    });

    test('fromState wraps existing state without owning it', () {
      final state = WindDynamicState();
      state.set('pre', 'existing');

      final controller = WindDynamicController.fromState(state);
      expect(controller.getValue('pre'), 'existing');

      // Dispose controller should NOT dispose the state
      controller.dispose();

      // State should still be usable
      state.set('post', 'value');
      expect(state.get('post'), 'value');

      state.dispose();
    });
  });
}
