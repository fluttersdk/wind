import 'package:flutter/material.dart';
import 'package:fluttersdk_dusk/dusk.dart';

import 'parser/wind_context.dart';
import 'parser/wind_parser.dart';
import 'parser/wind_style.dart';
import 'widgets/w_button.dart';
import 'widgets/w_checkbox.dart';
import 'widgets/w_date_picker.dart';
import 'widgets/w_div.dart';
import 'widgets/w_form_checkbox.dart';
import 'widgets/w_form_date_picker.dart';
import 'widgets/w_form_input.dart';
import 'widgets/w_form_select.dart';
import 'widgets/w_icon.dart';
import 'widgets/w_image.dart';
import 'widgets/w_input.dart';
import 'widgets/w_popover.dart';
import 'widgets/w_select.dart';
import 'widgets/w_spacer.dart';
import 'widgets/w_svg.dart';
import 'widgets/w_text.dart';

/// **Wind ↔ Dusk integration hook.**
///
/// Registers a [DuskSnapshotEnricher] that appends Wind-specific styling
/// metadata to every Dusk snapshot ref whose underlying widget consumes a
/// `className` (i.e. a W-prefixed widget).
///
/// Host integration:
/// ```dart
/// void main() {
///   WidgetsFlutterBinding.ensureInitialized();
///   if (kDebugMode) {
///     DuskPlugin.install();
///     WindDuskIntegration.install();
///   }
///   runApp(app);
/// }
/// ```
///
/// The enricher emits a six-field YAML block under the snapshot ref:
///
/// ```yaml
/// wind:
///     breakpoint: md
///     brightness: light
///     platform: web
///     states: [hover]
///     bgColor: '#3B82F6'
///     textColor: '#FFFFFF'
/// ```
///
/// `bgColor` and `textColor` are emitted only when the resolved [WindStyle]
/// carries a non-null `decoration.color` or `color`. The other four fields
/// are always present.
///
/// Idempotent: subsequent `install()` calls are no-ops, mirroring the
/// [DuskPlugin] install pattern.
class WindDuskIntegration {
  WindDuskIntegration._();

  static bool _installed = false;

  /// Whether [install] has already wired the enricher in this isolate.
  ///
  /// Exposed primarily for tests; production callers should rely on the
  /// idempotency contract of [install] itself.
  static bool get isInstalled => _installed;

  /// Registers the Wind className enricher with [DuskPlugin].
  ///
  /// Safe to call multiple times — only the first call mutates
  /// [DuskPlugin.enrichers]. Pair with [DuskPlugin.install] inside the
  /// host's `kDebugMode` branch.
  static void install() {
    if (_installed) {
      return;
    }
    _installed = true;
    DuskPlugin.enrichers.add(_windClassNameEnricher);
  }
}

/// Wind className enricher. Matches the [DuskSnapshotEnricher] typedef.
///
/// Returns null when the [element] is not a W-prefixed widget or carries
/// no className — the dispatcher skips null returns per the
/// [DuskSnapshotEnricher] contract.
String? _windClassNameEnricher(Element element, RefRegistry refs) {
  final widget = element.widget;

  // 1. Filter to W-prefixed widgets that expose a className API.
  if (!_isWindWidget(widget)) {
    return null;
  }

  // 2. Extract className via dynamic dispatch — the surface is uniform
  //    across every W-widget so a single accessor covers all 16 types.
  final dynamic w = widget;
  final String? className = w.className as String?;
  if (className == null || className.isEmpty) {
    return null;
  }

  // 3. Resolve context + style at snapshot time so the captured values
  //    reflect the active breakpoint, brightness, platform, and states.
  final WindContext context = WindContext.build(element);
  final WindStyle style = WindParser.parse(className, element);

  // 4. Assemble the six-field YAML block. Indent matches dusk's snapshot
  //    bullet convention (4-space indent under the ref line).
  final StringBuffer buf = StringBuffer('wind:\n');
  buf.writeln('    breakpoint: ${context.activeBreakpoint}');
  buf.writeln(
    '    brightness: ${context.theme.brightness == Brightness.dark ? 'dark' : 'light'}',
  );
  buf.writeln('    platform: ${context.platform}');
  buf.writeln('    states: [${context.activeStates.join(', ')}]');

  final Color? bgColor = style.decoration?.color;
  if (bgColor != null) {
    buf.writeln("    bgColor: '#${_hexRgb(bgColor)}'");
  }

  final Color? textColor = style.color;
  if (textColor != null) {
    buf.writeln("    textColor: '#${_hexRgb(textColor)}'");
  }

  return buf.toString();
}

/// Returns true when [widget] is one of the 16 W-prefixed widgets that
/// accept a className. WAnchor / WBreakpoint / WindAnimationWrapper /
/// WKeyboardActions are intentionally excluded — they do not consume
/// className tokens directly.
bool _isWindWidget(Widget widget) {
  return widget is WDiv ||
      widget is WText ||
      widget is WButton ||
      widget is WInput ||
      widget is WFormInput ||
      widget is WSelect ||
      widget is WFormSelect ||
      widget is WFormMultiSelect ||
      widget is WCheckbox ||
      widget is WFormCheckbox ||
      widget is WDatePicker ||
      widget is WFormDatePicker ||
      widget is WIcon ||
      widget is WImage ||
      widget is WSvg ||
      widget is WPopover ||
      widget is WSpacer;
}

/// Formats [color] as a 6-char RGB hex string (alpha dropped, uppercase).
///
/// `toARGB32()` yields a 32-bit `0xAARRGGBB` integer; padding to 8 hex
/// chars then slicing the trailing 6 keeps the RGB triplet only.
String _hexRgb(Color color) {
  final String hex = color.toARGB32().toRadixString(16).padLeft(8, '0');
  return hex.substring(2).toUpperCase();
}
