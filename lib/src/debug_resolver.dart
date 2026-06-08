import 'package:flutter/widgets.dart';
import 'package:fluttersdk_wind_diagnostics_contracts/fluttersdk_wind_diagnostics_contracts.dart';

import 'parser/wind_context.dart';
import 'parser/wind_parser.dart';
// WindStyle is declared in parser/wind_style.dart and is NOT
// transitively re-exported by wind_parser.dart. Importing it here
// is mandatory; without it Dart fails with "Undefined name 'WindStyle'".
import 'parser/wind_style.dart';

/// Concrete WindDebugResolver wired into the registry at app boot
/// via `Wind.installDebugResolver()`. Resolves up to 7 fields (5 always
/// present, `bgColor` + `textColor` only when non-null) per the
/// fluttersdk_wind_diagnostics_contracts v1 contract.
class WindDebugResolverImpl implements WindDebugResolver {
  const WindDebugResolverImpl();

  @override
  Map<String, Object?> resolve(Element element) {
    final widget = element.widget;
    // 1. Filter to W-prefixed widgets that actually expose a `className` API.
    if (!widget.runtimeType.toString().startsWith('W')) {
      return const {};
    }
    final String? className = _readClassName(widget);
    if (className == null || className.isEmpty) {
      return const {};
    }
    // 2. Resolve context + style at snapshot time (Element IS a BuildContext)
    final WindContext ctx = WindContext.build(element);
    final WindStyle style = WindParser.parse(className, element);
    // 3. Build the field map: 5 fields always present, bgColor + textColor
    //    conditional on non-null resolved values (up to 7 total) when the
    //    widget is a valid W-widget.
    final Map<String, Object?> data = <String, Object?>{
      'className': className,
      // WindContext.activeBreakpoint and .platform are `String`, not enums
      // (see references/wind/lib/src/parser/wind_context.dart:33,38).
      // Do NOT append `.name`.
      'breakpoint': ctx.activeBreakpoint,
      'brightness': ctx.theme.brightness == Brightness.dark ? 'dark' : 'light',
      'platform': ctx.platform,
      'states': ctx.activeStates.toList(growable: false),
    };
    final Color? bgColor = style.decoration?.color;
    if (bgColor != null) {
      data['bgColor'] = '#${_hexRgb(bgColor)}';
    }
    final Color? textColor = style.color;
    if (textColor != null) {
      data['textColor'] = '#${_hexRgb(textColor)}';
    }
    return data;
  }

  /// Reads the optional `className` field from a W-widget via dynamic dispatch.
  ///
  /// Several W-prefixed widgets are interaction- or structure-only and expose
  /// no `className` (WAnchor, WBreakpoint, WindAnimationWrapper,
  /// WKeyboardActions). Reading `.className` on them throws
  /// `NoSuchMethodError`; treating that as the documented "not className-
  /// stylable" signal keeps a bare WAnchor in the tree from crashing the whole
  /// diagnostic snapshot. Only the missing-member error is handled here; any
  /// other failure propagates.
  String? _readClassName(Widget widget) {
    try {
      return (widget as dynamic).className as String?;
    } on NoSuchMethodError {
      return null;
    }
  }
}

/// Formats a Color as 6-char RGB hex (alpha channel dropped, uppercase).
///
/// Preserves the snapshot YAML hex format that downstream agent consumers
/// (e.g. `fluttersdk_dusk`) parse.
String _hexRgb(Color color) {
  final String hex = color.toARGB32().toRadixString(16).padLeft(8, '0');
  return hex.substring(2).toUpperCase();
}
