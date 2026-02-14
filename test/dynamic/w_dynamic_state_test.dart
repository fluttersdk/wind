import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/dynamic/wind_dynamic_state.dart';

void main() {
  late WindDynamicState state;

  setUp(() {
    state = WindDynamicState();
  });

  tearDown(() {
    state.dispose();
  });

  group('WindDynamicState', () {
    test('get returns null for unknown id', () {
      expect(state.get('unknown'), isNull);
    });

    test('set and get stores value', () {
      state.set('email', 'test@example.com');
      expect(state.get('email'), 'test@example.com');
    });

    test('set notifies ChangeNotifier listeners', () {
      int notifyCount = 0;
      state.addListener(() => notifyCount++);

      state.set('name', 'Alice');
      expect(notifyCount, 1);
    });

    test('set does not notify when value unchanged', () {
      state.set('name', 'Alice');
      int notifyCount = 0;
      state.addListener(() => notifyCount++);

      state.set('name', 'Alice');
      expect(notifyCount, 0);
    });

    test('getAll returns all values', () {
      state.set('email', 'test@example.com');
      state.set('name', 'Alice');
      state.set('agreed', true);

      final all = state.getAll();
      expect(all, {
        'email': 'test@example.com',
        'name': 'Alice',
        'agreed': true,
      });
    });

    test('getAll returns unmodifiable map', () {
      state.set('key', 'value');
      final all = state.getAll();
      expect(() => all['new'] = 'fail', throwsA(isA<UnsupportedError>()));
    });

    test('reset clears all values', () {
      state.set('email', 'test@example.com');
      state.set('name', 'Alice');
      state.reset();

      expect(state.get('email'), isNull);
      expect(state.get('name'), isNull);
      expect(state.getAll(), isEmpty);
    });

    test('has returns true for existing keys', () {
      state.set('email', 'test@example.com');
      expect(state.has('email'), isTrue);
      expect(state.has('missing'), isFalse);
    });

    test('addIdListener fires for specific id', () {
      String? lastValue;
      state.addIdListener('email', (value) => lastValue = value);

      state.set('email', 'test@example.com');
      expect(lastValue, 'test@example.com');

      state.set('name', 'Alice');
      expect(lastValue, 'test@example.com'); // unchanged
    });

    test('addIdListener dispose stops notifications', () {
      int callCount = 0;
      final dispose = state.addIdListener('email', (_) => callCount++);

      state.set('email', 'a');
      expect(callCount, 1);

      dispose();
      state.set('email', 'b');
      expect(callCount, 1); // no more calls
    });
  });
}
