/// Platform gate for `WKeyboardActions` toolbar visibility.
///
/// Controls which mobile platforms render the keyboard toolbar overlay.
/// Pass a value as the `platform` parameter on `WKeyboardActions`. The
/// string-based API (`'ios'`, `'android'`, `'all'`) maps to this enum
/// internally; consumers that prefer a typed constant may use this directly
/// (exported from `package:fluttersdk_wind/fluttersdk_wind.dart`).
enum WKeyboardPlatform {
  /// Show the toolbar only on Android.
  android,

  /// Show the toolbar only on iOS.
  ios,

  /// Show the toolbar on both Android and iOS.
  all,
}
