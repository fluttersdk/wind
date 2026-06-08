import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';
import 'package:fluttersdk_wind/src/debug_resolver.dart';
import 'package:fluttersdk_wind_diagnostics_contracts/fluttersdk_wind_diagnostics_contracts.dart';

/// Tests for `Wind` facade — install flag management and registry integration.
///
/// `kDebugMode` is always `true` under `flutter test`, so the `!kDebugMode`
/// branch in `installDebugResolver()` is unreachable from this suite and
/// intentionally left uncovered.
void main() {
  setUp(() {
    Wind.resetForTesting();
    WindDebugRegistry.resetForTesting();
  });

  tearDown(() {
    Wind.resetForTesting();
    WindDebugRegistry.resetForTesting();
  });

  group('Wind.installDebugResolver()', () {
    test(
      'registers a WindDebugResolverImpl instance in WindDebugRegistry',
      () {
        // Precondition: registry starts empty.
        expect(WindDebugRegistry.current, isNull);

        Wind.installDebugResolver();

        expect(WindDebugRegistry.current, isNotNull);
        expect(WindDebugRegistry.current, isA<WindDebugResolverImpl>());
      },
    );

    test(
      'is idempotent: second call does not replace the registered instance',
      () {
        Wind.installDebugResolver();
        final firstInstance = WindDebugRegistry.current;

        Wind.installDebugResolver();
        final secondInstance = WindDebugRegistry.current;

        // The registry must hold the exact same object reference.
        expect(identical(firstInstance, secondInstance), isTrue);
      },
    );

    test(
      'resetForTesting() makes the install gate re-entrant',
      () {
        // 1. First install registers the resolver.
        Wind.installDebugResolver();
        expect(WindDebugRegistry.current, isNotNull);

        // 2. Reset both the flag and the registry.
        Wind.resetForTesting();
        WindDebugRegistry.resetForTesting();
        expect(WindDebugRegistry.current, isNull);

        // 3. Re-installing after reset registers a fresh resolver.
        Wind.installDebugResolver();
        expect(WindDebugRegistry.current, isNotNull);
        expect(WindDebugRegistry.current, isA<WindDebugResolverImpl>());
      },
    );
  });
}
