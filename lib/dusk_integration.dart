/// Wind ↔ fluttersdk_dusk integration adapter sub-barrel.
///
/// Import this file when your app uses both fluttersdk_wind and
/// fluttersdk_dusk and wants the WindDuskIntegration enricher wired
/// into DuskPlugin. Consumers MUST add fluttersdk_dusk to their own
/// pubspec.yaml dependencies; wind ships fluttersdk_dusk as a
/// dev-dependency only, so transitive resolution does not happen
/// through wind itself.
///
/// Host integration (debug-only in lib/main.dart). WindDuskIntegration
/// runs alongside DuskPlugin.install() before runApp() (or before
/// Magic.init() on Magic-stack apps); the enricher reads className
/// + WindStyle at snapshot time, so no IoC bootstrap is required:
///
/// ```dart
/// if (kDebugMode) {
///   DuskPlugin.install();
///   WindDuskIntegration.install();
/// }
/// ```
///
/// See `references/wind/lib/src/dusk_integration.dart` for the
/// concrete WindDuskIntegration class and the windClassNameEnricher
/// function.
library;

export 'src/dusk_integration.dart';
